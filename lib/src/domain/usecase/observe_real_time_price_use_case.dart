import 'package:trading_instruments/src/domain/repository/price_socket_repository.dart';

class ObserveRealTimePriceUseCase {
  final PriceSocketRepository priceSocketRepository;

  ObserveRealTimePriceUseCase({
    required this.priceSocketRepository,
  });

  Future<void> initialize() async {
    await priceSocketRepository.connect();
  }

  Stream<dynamic>? call(String? symbol) {
    return priceSocketRepository.subscribe(symbol: symbol)?.asBroadcastStream();
  }
}
