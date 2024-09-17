class PriceModels {
  final List<PriceDataModel> data;

  PriceModels({required this.data});

  factory PriceModels.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List<dynamic>;
    List<PriceDataModel> dataList =
        list.map((price) => PriceDataModel.fromJson(price)).toList();

    return PriceModels(
      data: dataList,
    );
  }
}

class PriceDataModel {
  final double? price;

  PriceDataModel({
    required this.price,
  });

  factory PriceDataModel.fromJson(dynamic json) {
    return PriceDataModel(
      price: (json['p'] as num).toDouble(),
    );
  }
}
