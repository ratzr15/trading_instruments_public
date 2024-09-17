part of 'trade_list_screen_bloc.dart';

abstract class TradeListScreenState extends Equatable {
  const TradeListScreenState();
}

class TradeListScreenLoadingState extends TradeListScreenState {
  @override
  List<Object?> get props => [];
}

class TradeListScreenLoadedState extends TradeListScreenState {
  final List<TradeItemDisplayModel> displayModels;

  const TradeListScreenLoadedState(this.displayModels);

  @override
  List<Object?> get props => [displayModels];
}

class TradeListScreenErrorState extends TradeListScreenState {
  final String title;

  const TradeListScreenErrorState({required this.title});

  @override
  List<Object?> get props => [title];
}
