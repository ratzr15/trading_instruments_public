import 'package:equatable/equatable.dart';

abstract class PriceState extends Equatable {}

class PriceInitial extends PriceState {
  @override
  List<Object?> get props => [];
}

class PriceLoading extends PriceState {
  @override
  List<Object?> get props => [];
}

class PriceLoaded extends PriceState {
  final String price;

  PriceLoaded(this.price);

  @override
  List<Object> get props => [
        price,
      ];
}

class PriceError extends PriceState {
  final String message;

  PriceError(this.message);

  @override
  List<Object?> get props => [
        message,
      ];
}
