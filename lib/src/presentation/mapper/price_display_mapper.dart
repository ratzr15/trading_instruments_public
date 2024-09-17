import 'dart:convert';

import 'package:trading_instruments/src/domain/models/price_model.dart';

class PriceDisplayMapper {
  PriceModels call(dynamic response) {
    final decoded = jsonDecode(response.toString());

    if (decoded is Map<String, dynamic>) {
      return _mapForexSymbolsResponse(decoded);
    } else {
      throw Exception('Mapping exception');
    }
  }

  PriceModels _mapForexSymbolsResponse(Map<String, dynamic> response) {
    return PriceModels.fromJson(response);
  }
}
