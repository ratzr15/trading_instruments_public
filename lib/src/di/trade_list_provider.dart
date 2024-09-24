import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_instruments/src/data/datasource/price_data_source/price_socket_data_source.dart';
import 'package:trading_instruments/src/data/datasource/trade_symbols_data_source/trade_symbols_data_source.dart';
import 'package:trading_instruments/src/data/datasource/trade_symbols_data_source/trade_symbols_data_source_impl.dart';
import 'package:trading_instruments/src/data/mapper/trade_symbol_mapper/trade_symbols_remote_to_domain_mapper.dart';
import 'package:trading_instruments/src/data/repository/price_socket_repository/price_socket_repository_impl.dart';
import 'package:trading_instruments/src/data/repository/trade_symbol_repository/trade_symbol_repository_impl.dart';
import 'package:trading_instruments/src/domain/repository/price_socket_repository.dart';
import 'package:trading_instruments/src/domain/repository/trade_symbol_repository.dart';
import 'package:trading_instruments/src/domain/usecase/get_trading_symbols_use_case.dart';
import 'package:trading_instruments/src/domain/usecase/observe_real_time_price_use_case.dart';
import 'package:trading_instruments/src/presentation/bloc/trade_list_screen_bloc.dart';
import 'package:trading_instruments/src/presentation/components/price/bloc/price_bloc.dart';
import 'package:trading_instruments/src/presentation/mapper/price_display_mapper.dart';
import 'package:trading_instruments/src/presentation/mapper/trade_item_display_mapper.dart';
import 'package:trading_instruments/src/presentation/trade_list_screen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TradeListProvider extends StatelessWidget {
  const TradeListProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return _registerRepositories(context);
  }
}

Widget _registerRepositories(BuildContext context) {
  return MultiProvider(
    providers: [
      Provider(create: (_) => _initTradeSymbolRepository(context)),
      Provider(create: (_) => _initPriceRepository(context)),
      Provider(create: (_) => _initGetTradeSymbolsUseCase(context)),
      Provider(create: (_) => _initPriceUseCase(context)),
    ],
    builder: (context, __) => _registerUseCase(context),
  );
}

Widget _registerUseCase(BuildContext context) {
  return MultiProvider(
    providers: [
      Provider(create: (_) => context.read<GetTradeSymbolsUseCase>()),
      Provider(create: (_) => context.read<ObserveRealTimePriceUseCase>()),
    ],
    child: _registerBloc(context),
  );
}

Widget _registerBloc(BuildContext context) {
  return MultiProvider(
    providers: [
      Provider(create: (_) => _initPriceBloc(context)),
      Provider(create: (_) => _initListBloc(context)),
    ],
    child: const TradeListScreenWidget(),
  );
}

// Init methods
TradeSymbolRepository _initTradeSymbolRepository(BuildContext context) {
  return TradeSymbolRepositoryImpl(
    forexSymbolsDataSource: _initTradeSymbolRemoteDataSource(),
    forexSymbolsRemoteToDomainMapper: _initTradeRemoteToDomainMapper(),
  );
}

TradeSymbolsDataSource _initTradeSymbolRemoteDataSource() {
  return TradeSymbolsDataSourceImpl(
    apiClient: apiClient,
    baseUrl: _Constants.baseUrl,
  );
}

ApiClient get apiClient {
  var dio = Dio();
  return ApiClientImpl(dio);
}

TradeSymbolsRemoteToDomainMapper _initTradeRemoteToDomainMapper() {
  return TradeSymbolsRemoteToDomainMapperImpl();
}

GetTradeSymbolsUseCase _initGetTradeSymbolsUseCase(BuildContext context) {
  return GetTradeSymbolsUseCaseImpl(
    tradeSymbolRepository: _initTradeSymbolRepository(context),
  );
}

TradeListScreenBloc _initListBloc(BuildContext context) {
  return TradeListScreenBloc(
    getTradeSymbolsUseCase: context.read(),
    tradeItemDisplayMapper: TradeItemDisplayMapper(),
  );
}

abstract class _Constants {
  static const sixtySeconds = Duration(seconds: 60);
  static const baseUrl = 'https://finnhub.io';
  static const url =
      'wss://ws.finnhub.io/?token=crjeknhr01qnnbrrnhogcrjeknhr01qnnbrrnhp0';
}

// Init methods
PriceSocketRepository _initPriceRepository(BuildContext context) {
  return PriceSocketRepositoryImpl(
    priceSocketDataSource: _initPriceRemoteDataSource(),
  );
}

PriceSocketDataSource _initPriceRemoteDataSource() {
  return PriceSocketDataSource();
}

PriceDisplayMapper _initPriceDisplayMapper() {
  return PriceDisplayMapper();
}

ObserveRealTimePriceUseCase _initPriceUseCase(BuildContext context) {
  return ObserveRealTimePriceUseCase(
    priceSocketRepository: _initPriceRepository(context),
  );
}

PriceBloc _initPriceBloc(BuildContext context) {
  final wsUrl = Uri.parse(_Constants.url);

  return PriceBloc(
    observeRealTimePriceUseCase: context.read(),
    displayMapper: _initPriceDisplayMapper(),
    channel: WebSocketChannel.connect(wsUrl),
  );
}
