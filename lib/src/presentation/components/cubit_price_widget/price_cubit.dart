import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../mapper/price_display_mapper.dart';

// Define States
abstract class AppState {}

class PriceInitial extends AppState {}

class PriceLoading extends AppState {}

class PriceLoaded extends AppState {
  final String price;
  PriceLoaded(this.price);
}

class PriceError extends AppState {
  final String message;
  PriceError(this.message);
}

class PriceWidgetCubit extends Cubit<AppState> {
  WebSocketChannel? _channel;
  final String token = 'crjeknhr01qnnbrrnhogcrjeknhr01qnnbrrnhp0';
  StreamSubscription<dynamic>? _subscription;
  final PriceDisplayMapper displayMapper;

  PriceWidgetCubit(this.displayMapper) : super(PriceInitial());

  void connect(String symbol) {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('wss://ws.finnhub.io/?token=$token'),
      );
      _channel?.sink.add('{"type":"subscribe","symbol":"$symbol"}');
      emit(PriceLoading());

      // Listen to WebSocket stream
      _subscription = _channel?.stream.listen(
        (message) {
          final mappedPrice = displayMapper(message);
          final price = mappedPrice.data.first.price.toString();

          emit(PriceLoaded(price.toString()));
        },
      );
    } catch (e) {
      emit(PriceError('Failed to connect: $e'));
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
  }
}
