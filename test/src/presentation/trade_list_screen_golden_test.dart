import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trading_instruments/src/presentation/bloc/trade_list_screen_bloc.dart';
import 'package:trading_instruments/src/presentation/models/trade_item_display_model.dart';
import 'package:trading_instruments/src/presentation/trade_list_screen.dart';

void main() {
  late TradeListScreenBloc mockBloc;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockBloc = MockTradeListScreenBloc();
    // Ensure that the close method returns a Future<void>
    when(() => mockBloc.close()).thenAnswer((_) async {});
  });

  testWidgets('Golden Test - Loading State', (WidgetTester tester) async {
    // Arrange
    when(() => mockBloc.state).thenReturn(
      TradeListScreenLoadingState(),
    );
    whenListen(
      mockBloc,
      Stream.fromIterable([
        TradeListScreenLoadingState(),
      ]),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest(mockBloc));

    await tester.pumpAndSettle();

    // Take a screenshot
    await expectLater(
      find.byType(TradeListScreenWidget),
      matchesGoldenFile('golden/loading_state.png'),
    );
  });

  testWidgets('Golden Test - Loaded State', (WidgetTester tester) async {
    // Arrange
    const tradeItems = [
      TradeItemDisplayModel(
        symbol: 'OOANDA',
        description: 'description',
      ),
      TradeItemDisplayModel(
        symbol: 'OOANDA2',
        description: 'description2r',
      ),
    ];
    when(() => mockBloc.state).thenReturn(
      const TradeListScreenLoadedState(
        tradeItems,
      ),
    );
    whenListen(
      mockBloc,
      Stream.fromIterable([
        const TradeListScreenLoadedState(
          tradeItems,
        )
      ]),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest(mockBloc));

    await tester.pumpAndSettle();

    // Take a screenshot
    await expectLater(
      find.byType(TradeListScreenWidget),
      matchesGoldenFile('golden/loaded_state.png'),
    );
  });
}

Widget createWidgetUnderTest(TradeListScreenBloc mockBloc) {
  return MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blueGrey,
    ),
    home: BlocProvider<TradeListScreenBloc>(
      create: (_) => mockBloc,
      child: const TradeListScreenWidget(),
    ),
  );
}

class MockTradeListScreenBloc extends Mock implements TradeListScreenBloc {}
