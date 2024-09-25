import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_instruments/src/presentation/mapper/price_display_mapper.dart';

import 'price_cubit.dart';

class TradePriceWidget extends StatelessWidget {
  final String symbol;

  const TradePriceWidget({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PriceWidgetCubit(PriceDisplayMapper())..connect(symbol),
      child: BlocBuilder<PriceWidgetCubit, AppState>(
        builder: (context, state) {
          if (state is PriceLoading) {
            return _buildLoading();
          } else if (state is PriceLoaded) {
            return _buildPrice(state.price);
          } else if (state is PriceError) {
            return _buildError(state.message);
          } else {
            return _buildInitial();
          }
        },
      ),
    );
  }

  Widget _buildInitial() {
    return const Center(
      child: Text('Waiting for price...'),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildPrice(String price) {
    return Center(
      child: Text(
        '$price USD',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text(
        'Error: $message',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
