import 'package:trading_instruments/src/domain/models/symbol_model.dart';
import 'package:trading_instruments/src/presentation/models/trade_item_display_model.dart';

class TradeItemDisplayMapper {
  List<TradeItemDisplayModel> call({
    required List<SymbolModel> domainModels,
  }) {
    return domainModels
        .map((item) => TradeItemDisplayModel(
              description: item.description,
              symbol: item.symbol,
            ))
        .toList();
  }
}
