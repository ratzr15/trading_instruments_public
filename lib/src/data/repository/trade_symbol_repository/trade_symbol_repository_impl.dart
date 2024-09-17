import 'package:trading_instruments/src/data/datasource/trade_symbols_data_source/trade_symbols_data_source.dart';

import '../../../domain/models/symbol_model.dart';
import '../../../domain/repository/trade_symbol_repository.dart';
import '../../mapper/trade_symbol_mapper/trade_symbols_remote_to_domain_mapper.dart';

class TradeSymbolRepositoryImpl implements TradeSymbolRepository {
  final TradeSymbolsDataSource forexSymbolsDataSource;
  final TradeSymbolsRemoteToDomainMapper forexSymbolsRemoteToDomainMapper;

  TradeSymbolRepositoryImpl({
    required this.forexSymbolsDataSource,
    required this.forexSymbolsRemoteToDomainMapper,
  });

  @override
  Future<List<SymbolModel>?> call({
    required String exchange,
  }) async {
    final result = await forexSymbolsDataSource(exchange: exchange);

    return forexSymbolsRemoteToDomainMapper(result);
  }
}
