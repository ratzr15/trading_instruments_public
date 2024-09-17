import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trading_instruments/src/presentation/bloc/trade_list_screen_bloc.dart';
import 'package:trading_instruments/src/presentation/models/trade_item_display_model.dart';
import 'package:trading_instruments/src/presentation/trade_list_screen.dart';

void main() {
  late TradeListScreenBloc mockBloc;

  setUp(() {
    mockBloc = MockTradeListScreenBloc();
    // Ensure that the close method returns a Future<void>
    when(() => mockBloc.close()).thenAnswer((_) async {});
  });

  testWidgets('Loading State', (WidgetTester tester) async {
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
    await tester.pumpWidget(createWidgetUnderTest(
      mockBloc,
    ));

    // Assert
    expect(
      find.byKey(TradeListKeys.loading),
      findsOneWidget,
    );
  });

  testWidgets('Error State', (WidgetTester tester) async {
    // Arrange
    const errorTitle = 'An error occurred';
    when(() => mockBloc.state).thenReturn(
      const TradeListScreenErrorState(
        title: errorTitle,
      ),
    );
    whenListen(
      mockBloc,
      Stream.fromIterable(const [
        TradeListScreenErrorState(
          title: errorTitle,
        )
      ]),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest(
      mockBloc,
    ));

    // Assert
    expect(find.byKey(TradeListKeys.error), findsOneWidget);
    expect(find.text(errorTitle), findsOneWidget);
  });

  testWidgets('Loaded State', (WidgetTester tester) async {
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
    when(() => mockBloc.state).thenReturn(const TradeListScreenLoadedState(
      tradeItems,
    ));
    whenListen(
      mockBloc,
      Stream.fromIterable(const [
        TradeListScreenLoadedState(
          tradeItems,
        )
      ]),
    );

    // Act
    await tester.pumpWidget(createWidgetUnderTest(mockBloc));

    // Assert
    expect(find.byKey(TradeListKeys.loaded), findsOneWidget);
    expect(find.text(tradeItems[0].symbol), findsOneWidget);
    expect(find.text(tradeItems[0].description), findsOneWidget);
    expect(find.text(tradeItems[1].symbol), findsOneWidget);
    expect(find.text(tradeItems[1].description), findsOneWidget);
  });
}

Widget createWidgetUnderTest(TradeListScreenBloc mockBloc) {
  return MaterialApp(
    home: BlocProvider<TradeListScreenBloc>(
      create: (_) => mockBloc,
      child: const TradeListScreenWidget(),
    ),
  );
}

class MockTradeListScreenBloc extends Mock implements TradeListScreenBloc {}
