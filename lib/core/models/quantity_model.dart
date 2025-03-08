class QuantityModel {
  final bool success;
  final String? message;
  final Map<String, RouteData> data;

  QuantityModel({required this.success, required this.data,this.message});

  factory QuantityModel.fromJson(Map<String, dynamic> json) {
    return QuantityModel(
      success: json['success'],
      data: (json['data'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, RouteData.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((key, value) => MapEntry(key, value.toJson())),
    };
  }
}

class RouteData {
  final Map<String, ProductType> products;

  RouteData({required this.products});

  factory RouteData.fromJson(Map<String, dynamic> json) {
    return RouteData(
      products: json.map(
        (key, value) => MapEntry(key, ProductType.fromJson(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return products.map((key, value) => MapEntry(key, value.toJson()));
  }
}

class ProductType {
  final Map<String, int> quantities;
  final double totalLiters;

  ProductType({required this.quantities, required this.totalLiters});

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      quantities: (json['quantities'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value as int)),
      totalLiters: (json['totalLiters'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantities': quantities,
      'totalLiters': totalLiters,
    };
  }
}
