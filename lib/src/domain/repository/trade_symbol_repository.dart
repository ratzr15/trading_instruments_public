import 'package:trading_instruments/src/domain/models/symbol_model.dart';

abstract class TradeSymbolRepository {
  Future<List<SymbolModel>?> call({
    required String exchange,
  });
}
