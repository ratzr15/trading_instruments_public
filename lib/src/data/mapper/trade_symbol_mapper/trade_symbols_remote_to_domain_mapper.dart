import 'package:trading_instruments/src/domain/models/symbol_model.dart';

abstract class TradeSymbolsRemoteToDomainMapper {
  List<SymbolModel>? call(dynamic response);
}

class TradeSymbolsRemoteToDomainMapperImpl
    implements TradeSymbolsRemoteToDomainMapper {
  @override
  List<SymbolModel>? call(response) {
    if (response is List) {
      return _mapForexSymbolsResponse(response);
    } else {
      throw Exception('Mapping exception');
    }
  }

  List<SymbolModel> _mapForexSymbolsResponse(List<dynamic> response) {
    return response.map((item) => SymbolModel.fromJson(item)).toList();
  }
}

abstract class _Constants {
  static const displaySymbol = "displaySymbol";
  static const description = "description";
  static const symbol = "symbol";
}
