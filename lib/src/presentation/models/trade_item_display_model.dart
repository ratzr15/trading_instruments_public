import 'package:equatable/equatable.dart';

class TradeItemDisplayModel extends Equatable {
  final String description;
  final String symbol;

  const TradeItemDisplayModel({
    required this.description,
    required this.symbol,
  });

  @override
  List<Object?> get props => [
        description,
        symbol,
      ];
}
