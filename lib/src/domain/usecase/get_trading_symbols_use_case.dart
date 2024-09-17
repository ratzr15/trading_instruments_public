import 'package:trading_instruments/src/domain/models/symbol_model.dart';
import 'package:trading_instruments/src/domain/repository/trade_symbol_repository.dart';

abstract class GetTradeSymbolsUseCase {
  Future<List<SymbolModel>> call();
}

class GetTradeSymbolsUseCaseImpl implements GetTradeSymbolsUseCase {
  final TradeSymbolRepository _tradeSymbolRepository;

  const GetTradeSymbolsUseCaseImpl({
    required TradeSymbolRepository tradeSymbolRepository,
  }) : _tradeSymbolRepository = tradeSymbolRepository;

  @override
  Future<List<SymbolModel>> call() async {
    try {
      final result = await _tradeSymbolRepository(
        exchange: _Constants.exchange,
      );

      if (result != null && result.isNotEmpty) {
        return result;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}

abstract class _Constants {
  static const exchange = 'oanda';
}
