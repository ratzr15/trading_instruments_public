import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_instruments/src/domain/usecase/observe_real_time_price_use_case.dart';
import 'package:trading_instruments/src/presentation/components/price/bloc/price_event.dart';
import 'package:trading_instruments/src/presentation/components/price/bloc/price_state.dart';
import 'package:trading_instruments/src/presentation/mapper/price_display_mapper.dart';

class PriceBloc extends Bloc<PriceEvent, PriceState> {
  final ObserveRealTimePriceUseCase observeRealTimePriceUseCase;
  final PriceDisplayMapper displayMapper;

  // A map to track separate streams for each symbol
  final Map<String, StreamSubscription<dynamic>> _symbolSubscriptions = {};

  PriceBloc({
    required this.observeRealTimePriceUseCase,
    required this.displayMapper,
  }) : super(PriceInitial()) {
    on<InitPriceEvent>((event, emit) async {
      await observeRealTimePriceUseCase.initialize();
    });

    on<SubscribeToPrice>((event, emit) async {
      await emit.forEach<dynamic>(
        observeRealTimePriceUseCase(event.symbol)!,
        onData: (message) {
          final price = displayMapper(message);
          return PriceLoaded(price.data.first.price.toString());
        },
        onError: (error, stackTrace) => PriceError('N/A'),
      );
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
