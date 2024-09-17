import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_instruments/src/presentation/bloc/trade_list_screen_bloc.dart';
import 'package:trading_instruments/src/presentation/components/price/price_widget.dart';
import 'package:trading_instruments/src/presentation/models/trade_item_display_model.dart';
import 'package:utils/utils.dart';

class TradeListScreenWidget extends StatefulWidget {
  const TradeListScreenWidget({super.key});

  @override
  State<TradeListScreenWidget> createState() => _TradeListScreenWidgetState();
}

class _TradeListScreenWidgetState extends State<TradeListScreenWidget> {
  late TradeListScreenBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<TradeListScreenBloc>();
  }

  void _dispatch(TradeListScreenEvent event) => _bloc.add(event);

  @override
  Widget build(BuildContext context) {
    _dispatch(const TradeListScreenInitialEvent());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forex'),
      ),
      body: BlocConsumer<TradeListScreenBloc, TradeListScreenState>(
        bloc: _bloc,
        buildWhen: alwaysTrue,
        listenWhen: alwaysFalse,
        builder: _onStateChangeBuilder,
        listener: idleListener,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

Widget _onStateChangeBuilder(
  BuildContext context,
  TradeListScreenState state,
) {
  return _buildState(context, state);
}

Widget _buildState(BuildContext context, TradeListScreenState state) {
  if (state is TradeListScreenLoadingState) {
    return const _TradeListLoadingWidget(
      key: TradeListKeys.loading,
    );
  } else if (state is TradeListScreenLoadedState) {
    return _TradeListLoadedWidget(
      key: TradeListKeys.loaded,
      tradeDisplayItems: state.displayModels,
    );
  } else if (state is TradeListScreenErrorState) {
    return _TradeListErrorWidget(
      key: TradeListKeys.error,
      title: state.title,
    );
  } else {
    return const _TradeListErrorWidget(
      key: TradeListKeys.error,
      title: _Constants.errorTitle,
    );
  }
}

class _TradeListErrorWidget extends StatelessWidget {
  final String title;

  const _TradeListErrorWidget({
    required super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title),
    );
  }
}

class _TradeListLoadingWidget extends StatelessWidget {
  const _TradeListLoadingWidget({
    required super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        _Constants.loadingTitle,
      ),
    );
  }
}

class _TradeListLoadedWidget extends StatelessWidget {
  final List<TradeItemDisplayModel> tradeDisplayItems;

  const _TradeListLoadedWidget({
    required super.key,
    required this.tradeDisplayItems,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tradeDisplayItems.length,
      itemBuilder: (context, index) {
        final item = tradeDisplayItems[index];

        return Padding(
          padding: const EdgeInsets.all(Dimens.small),
          child: Row(
            children: [
              Container(
                width: Dimens.width,
                height: Dimens.height,
                color: DesignColor.background,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(
                  Dimens.small,
                ),
                child: SizedBox(
                  child: PriceWidget(
                    symbol: item.symbol,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.small),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.symbol,
                        style: const TextStyle(
                          fontSize: Dimens.largeText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: Dimens.small),
                      Text(
                        item.description,
                        style: const TextStyle(fontSize: Dimens.large),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

abstract class _Constants {
  static const errorTitle = 'Sorry, unexpected error';
  static const loadingTitle = 'Fetching trade...';
}

abstract class TradeListKeys {
  static const loading = Key('loading_key');
  static const loaded = Key('loaded_key');
  static const error = Key('error_key');
}
