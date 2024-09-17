import 'package:equatable/equatable.dart';

class SymbolModel extends Equatable {
  final String description;
  final String displaySymbol;
  final String symbol;

  const SymbolModel({
    required this.description,
    required this.displaySymbol,
    required this.symbol,
  });

  factory SymbolModel.fromJson(dynamic json) {
    return SymbolModel(
      description: json['description'].toString(),
      displaySymbol: json['displaySymbol'].toString(),
      symbol: json['symbol'].toString(),
    );
  }

  @override
  List<Object> get props => [
        description,
        displaySymbol,
        symbol,
      ];
}
