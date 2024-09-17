import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trading_instruments/src/domain/models/symbol_model.dart';
import 'package:trading_instruments/src/domain/repository/trade_symbol_repository.dart';
import 'package:trading_instruments/src/domain/usecase/get_trading_symbols_use_case.dart';

void main() {
  late TradeSymbolRepository tradeSymbolRepository;

  late GetTradeSymbolsUseCase sut;

  setUp(() {
    tradeSymbolRepository = MockTradeSymbolRepository();

    sut = GetTradeSymbolsUseCaseImpl(
      tradeSymbolRepository: tradeSymbolRepository,
    );
  });

  test("Success", () async {
    // Arrange
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

    when(() => tradeSymbolRepository(
          exchange: 'oanda',
        )).thenAnswer((_) async => [
          symbols,
          symbols2,
        ]);

    // Act
    final _ = sut();

    // Assert
    verify(
      () => tradeSymbolRepository(exchange: 'oanda'),
    ).called(1);
  });
}

class MockTradeSymbolRepository extends Mock implements TradeSymbolRepository {}
