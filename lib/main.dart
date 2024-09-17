import 'package:flutter/material.dart';
import 'package:trading_instruments/src/di/trade_list_provider.dart';

void main() {
  const initialRoute = '/home';
  const title = 'Forex';

  runApp(
    MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: initialRoute,
      routes: {
        initialRoute: (context) => const TradeListProvider(),
      },
    ),
  );
}
