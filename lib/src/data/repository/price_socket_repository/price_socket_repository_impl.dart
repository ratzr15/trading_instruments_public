import 'dart:async';

import 'package:trading_instruments/src/data/datasource/models/price_socket_query.dart';
import 'package:trading_instruments/src/data/datasource/price_data_source/price_socket_data_source.dart';
import 'package:trading_instruments/src/domain/models/price_model.dart';
import 'package:trading_instruments/src/domain/repository/price_socket_repository.dart';

class PriceSocketRepositoryImpl implements PriceSocketRepository {
  final PriceSocketDataSource priceSocketDataSource;

  StreamSubscription<PriceModels>? priceSubscription;

  PriceSocketRepositoryImpl({
    required this.priceSocketDataSource,
  });

  @override
  Future<void> connect() async {
    await priceSocketDataSource.connect();
  }

  @override
  Stream<dynamic>? subscribe({
    required String? symbol,
  }) {
    final query = PriceSocketQuery(
      symbol: symbol,
      type: 'subscribe',
    );
    priceSocketDataSource.subscribeToSymbol(query);
    return priceSocketDataSource.priceStream;
  }

  @override
  void disconnect() {
    priceSocketDataSource.disconnect();
  }
}
