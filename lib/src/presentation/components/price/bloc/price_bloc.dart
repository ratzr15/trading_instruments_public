import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_instruments/src/domain/usecase/observe_real_time_price_use_case.dart';
import 'package:trading_instruments/src/presentation/components/price/bloc/price_event.dart';
import 'package:trading_instruments/src/presentation/components/price/bloc/price_state.dart';
import 'package:trading_instruments/src/presentation/mapper/price_display_mapper.dart';

class PriceBloc extends Bloc<PriceEvent, PriceState> {
  final ObserveRealTimePriceUseCase observeRealTimePriceUseCase;
  final PriceDisplayMapper displayMapper;

  PriceBloc({
    required this.observeRealTimePriceUseCase,
    required this.displayMapper,
  }) : super(PriceInitial()) {
    on<InitPriceEvent>((event, emit) async {
      await observeRealTimePriceUseCase.initialize();
    });

    on<SubscribeToPrice>((event, emit) async {
      observeRealTimePriceUseCase(event.symbol)?.asBroadcastStream().listen(
        (dynamic message) {
          final price = displayMapper(message);

          emit(PriceLoaded(
            price.data.first.price.toString(),
          ));
        },
        onError: (error) {
          emit(PriceError('N/A'));
        },
      );
    });
  }
}
