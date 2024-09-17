import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_instruments/src/presentation/components/price/bloc/price_bloc.dart';
import 'package:trading_instruments/src/presentation/components/price/bloc/price_event.dart';
import 'package:trading_instruments/src/presentation/components/price/bloc/price_state.dart';
import 'package:utils/utils.dart';

class PriceWidget extends StatefulWidget {
  final String? symbol;

  const PriceWidget({
    super.key,
    required this.symbol,
  });

  @override
  State<PriceWidget> createState() => _PriceWidgetWidgetState();
}

class _PriceWidgetWidgetState extends State<PriceWidget> {
  late PriceBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<PriceBloc>();

    _dispatch(InitPriceEvent());
  }

  void _dispatch(PriceEvent event) => _bloc.add(event);

  @override
  Widget build(BuildContext context) {
    _dispatch(SubscribeToPrice(widget.symbol));

    return BlocConsumer<PriceBloc, PriceState>(
      bloc: _bloc,
      buildWhen: (previous, current) => true, // Always rebuild on new state
      listenWhen: (previous, current) =>
          true, // Always listen for state changes
      builder: _onStateChangeBuilder,
      listener: (context, state) {
        if (state is PriceError) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading price: ${state.message}')));
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant PriceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.symbol != widget.symbol) {
      _dispatch(
        InitPriceEvent(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

Widget _onStateChangeBuilder(
  BuildContext context,
  PriceState state,
) {
  return _buildState(context, state);
}

Widget _buildState(BuildContext context, PriceState state) {
  if (state is PriceLoading) {
    return const Center(child: CircularProgressIndicator());
  } else if (state is PriceLoaded) {
    return Text(
      state.price,
      style: const TextStyle(
        fontSize: Dimens.large,
        fontWeight: FontWeight.bold,
      ),
    );
  } else {
    return const Text(
      'N/A',
      style: TextStyle(
        fontSize: Dimens.large,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
