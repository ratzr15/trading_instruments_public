import 'package:flutter_test/flutter_test.dart';
import 'package:trading_instruments/src/data/mapper/trade_symbol_mapper/trade_symbols_remote_to_domain_mapper.dart';
import 'package:trading_instruments/src/domain/models/symbol_model.dart';
import 'package:utils/utils.dart';

void main() {
  test(
    "correct mapping - full data",
    () {
      const map = [
        {
          'description': 'description1',
          'displaySymbol': 'displaySymbol1',
          'symbol': 'symbol1',
        },
        {
          'description': 'description2',
          'displaySymbol': 'displaySymbol2',
          'symbol': 'symbol2',
        },
      ];

      final decodedMap = JsonUtil.toDecodedMap(map);
      const expectedResult = [
        SymbolModel(
          description: 'description1',
          displaySymbol: 'displaySymbol1',
          symbol: 'symbol1',
        ),
        SymbolModel(
          description: 'description2',
          displaySymbol: 'displaySymbol2',
          symbol: 'symbol2',
        ),
      ];

      final mapper = TradeSymbolsRemoteToDomainMapperImpl();

      final result = mapper(decodedMap);

      expect(result, expectedResult);
    },
  );
}
