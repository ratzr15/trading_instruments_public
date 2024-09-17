import 'package:trading_instruments/src/data/datasource/models/price_socket_query.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PriceSocketDataSource {
  bool _isConnected = false;

  WebSocketChannel? _channel;

  PriceSocketDataSource();

  final wsUrl = Uri.parse(_Constants.url);

  Future<void> connect() async {
    if (_isConnected) return;

    _channel = WebSocketChannel.connect(wsUrl);
    await _channel?.ready;

    _isConnected = true;
  }

  void subscribeToSymbol(PriceSocketQuery query) {
    final message = query.toJson();
    _channel?.sink.add(message);
  }

  Stream<dynamic>? get priceStream => _channel?.stream.asBroadcastStream().map(
        (event) => event,
      );

  void disconnect() {
    _channel?.sink.close();
  }
}

abstract class _Constants {
  //TODO: move to `.secret` by adapting git secret{https://sobolevn.me/git-secret/}
  static const url =
      'wss://ws.finnhub.io/?token=crjeknhr01qnnbrrnhogcrjeknhr01qnnbrrnhp0';
}
