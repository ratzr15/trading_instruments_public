import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_instruments/src/data/datasource/models/price_socket_query.dart';
import 'package:trading_instruments/src/domain/usecase/observe_real_time_price_use_case.dart';
import 'package:trading_instruments/src/presentation/components/price/bloc/price_event.dart';
import 'package:trading_instruments/src/presentation/components/price/bloc/price_state.dart';
import 'package:trading_instruments/src/presentation/mapper/price_display_mapper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PriceBloc extends Bloc<PriceEvent, PriceState> {
  final ObserveRealTimePriceUseCase observeRealTimePriceUseCase;
  final PriceDisplayMapper displayMapper;
  final WebSocketChannel channel;

  // A map to track separate streams for each symbol
  final Map<String, StreamSubscription<dynamic>> _symbolSubscriptions = {};

  PriceBloc({
    required this.observeRealTimePriceUseCase,
    required this.displayMapper,
    required this.channel,
  }) : super(PriceInitial()) {
    on<InitPriceEvent>((event, emit) async {});

    on<SubscribeToPrice>((event, emit) async {
      final query = PriceSocketQuery(
        symbol: event.symbol,
        type: 'subscribe',
      );

      final message = query.toJson();
      channel.sink.add(message);

      try {
        // Make the handler async and await the listen call
        final subscription =
            await channel.stream.asBroadcastStream().listen((data) async {
          final price = displayMapper(data);
          emit(PriceLoaded(price.data.first.price.toString()));
        });

        // Store the subscription for potential management
        _symbolSubscriptions[event.symbol ?? ''] = subscription;
      } catch (e) {
        emit(
          PriceError('N/A'),
        );
      }
    });
  }

  @override
  Future<void> close() {
    // Cancel all subscriptions when the bloc is closed
    for (final subscription in _symbolSubscriptions.values) {
      subscription.cancel();
    }
    return super.close();
  }
}
