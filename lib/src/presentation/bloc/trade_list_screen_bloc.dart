import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_instruments/src/domain/usecase/get_trading_symbols_use_case.dart';
import 'package:trading_instruments/src/presentation/mapper/trade_item_display_mapper.dart';
import 'package:trading_instruments/src/presentation/models/trade_item_display_model.dart';

part 'trade_list_screen_event.dart';
part 'trade_list_screen_state.dart';

class TradeListScreenBloc
    extends Bloc<TradeListScreenEvent, TradeListScreenState> {
  final GetTradeSymbolsUseCase getTradeSymbolsUseCase;
  final TradeItemDisplayMapper tradeItemDisplayMapper;

  TradeListScreenBloc({
    required this.getTradeSymbolsUseCase,
    required this.tradeItemDisplayMapper,
  }) : super(TradeListScreenLoadingState()) {
    on<TradeListScreenInitialEvent>(_onListScreenInitialEvent);
  }

  Future<void> _onListScreenInitialEvent(
    TradeListScreenInitialEvent event,
    Emitter<TradeListScreenState> emit,
  ) async {
    try {
      emit(TradeListScreenLoadingState());
      final response = await getTradeSymbolsUseCase();

      if (response.isEmpty) {
        emit(const TradeListScreenErrorState(
            title: 'Sorry, trade information not found'));
      } else {
        final displayItems = tradeItemDisplayMapper(domainModels: response);
        emit(TradeListScreenLoadedState(displayItems));
      }
    } catch (e) {
      emit(const TradeListScreenErrorState(
          title: 'Sorry, trade information could not be fetched'));
    }
  }
}
