abstract class PriceEvent {}

class InitPriceEvent extends PriceEvent {}

class SubscribeToPrice extends PriceEvent {
  final String? symbol;

  SubscribeToPrice(this.symbol);
}
