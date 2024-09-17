import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class PriceSocketQuery extends Equatable {
  const PriceSocketQuery({
    required this.type,
    required this.symbol,
  });

  final String? type;
  final String? symbol;

  String toJson() {
    final data = {
      'type': type,
      'symbol': symbol,
    };
    data.removeWhere(
      (key, value) => value == null,
    );
    return json.encode(data);
  }

  @override
  List<Object?> get props => [
        type,
        symbol,
      ];
}
