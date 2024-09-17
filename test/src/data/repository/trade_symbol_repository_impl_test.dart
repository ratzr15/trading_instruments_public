import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trading_instruments/src/data/datasource/trade_symbols_data_source/trade_symbols_data_source.dart';
import 'package:trading_instruments/src/data/mapper/trade_symbol_mapper/trade_symbols_remote_to_domain_mapper.dart';
import 'package:trading_instruments/src/data/repository/trade_symbol_repository/trade_symbol_repository_impl.dart';
import 'package:trading_instruments/src/domain/models/symbol_model.dart';

void main() {
  late TradeSymbolRepositoryImpl sut;
  late TradeSymbolsDataSource dataSource;
  late TradeSymbolsRemoteToDomainMapper mapper;

  setUp(() {
    // given
    dataSource = MockForexSymbolsDataSource();
    mapper = MockForexSymbolsRemoteToDomainMapper();

    sut = TradeSymbolRepositoryImpl(
      forexSymbolsDataSource: dataSource,
      forexSymbolsRemoteToDomainMapper: mapper,
    );
  });

  test(
      'Success: should return list of symbols if the data source ForexSymbolsDataSource succeeds',
      () async {
    // arrange
    final response = [<String, dynamic>{}];

    const symbols = SymbolModel(
      description: 'description',
      displaySymbol: 'displaySymbol',
      symbol: 'symbol',
    );

    const symbols2 = SymbolModel(
      description: 'description2',
      displaySymbol: 'displaySymbol2',
      symbol: 'symbol2',
    );

    when(() => dataSource(
          exchange: 'forex',
        )).thenAnswer((_) async => response);

    when(() => mapper(response)).thenReturn([
      symbols,
      symbols2,
    ]);

    // act/assert
    final actual = await sut(exchange: 'forex');
    expect(actual, [
      symbols,
      symbols2,
    ]);
  });

  test(
      'Failure: should throw an exception if the data source ForexSymbolsDataSource throws an exception',
      () async {
    // arrange
    final error = Exception("Something went wrong");

    when(() => dataSource(
          exchange: 'forex',
        )).thenThrow(error);

    // act/assert
    await expectLater(
      () => sut(exchange: 'forex'),
      throwsA(isA<Exception>()),
    );
    verifyZeroInteractions(mapper);
  });
}

class MockForexSymbolsDataSource extends Mock
    implements TradeSymbolsDataSource {}

class MockForexSymbolsRemoteToDomainMapper extends Mock
    implements TradeSymbolsRemoteToDomainMapper {}
