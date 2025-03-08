import 'dart:convert';

class OrdersModelWithSub {
  final List<Data>? data;

  OrdersModelWithSub({this.data});

  factory OrdersModelWithSub.fromJson(List<dynamic> json) {
    return OrdersModelWithSub(
        data: json.map((items) => Data.fromJson(items)).toList());
  }
}

class Data {
  final String id;
  final double totalPrice;
  final String paymentMethod;
  final String paymentStatus;
  final bool planIsActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SelectedPlanDetails selectedPlanDetails;
  final Plan plan;

  Data({
    required this.id,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.planIsActive,
    required this.createdAt,
    required this.updatedAt,
    required this.selectedPlanDetails,
    required this.plan,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['_id'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      planIsActive: json['planisActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      selectedPlanDetails:
          SelectedPlanDetails.fromJson(json['selectedPlanDetails']),
      plan: Plan.fromJson(json['plan']),
    );
  }
}





class ProductItems {
  final Product product;
  final int quantity;
  final double routePrice;

  ProductItems({
    required this.product,
    required this.quantity,
    required this.routePrice,
  });

  factory ProductItems.fromJson(Map<String, dynamic> json) {
    return ProductItems(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      routePrice: (json['routePrice'] as num).toDouble(),
    );
  }
}

class Product {
  final String id;
  final String title;
  final String description;
 
  final String quantity;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      quantity: json['quantity'],
    );
  }
}

class SelectedPlanDetails {
  final String planType;
  final List<DatePlan> dates;
  final bool isActive;

  SelectedPlanDetails({
    required this.planType,
    required this.dates,
    required this.isActive,
  });

  factory SelectedPlanDetails.fromJson(Map<String, dynamic> json) {
    return SelectedPlanDetails(
      planType: json['planType'],
      dates: (json['dates'] as List)
          .map((item) => DatePlan.fromJson(item))
          .toList(),
      isActive: json['isActive'],
    );
  }
}

class DatePlan {
  final DateTime date;
  final String status;

  DatePlan({
    required this.date,
    required this.status,
  });

  factory DatePlan.fromJson(Map<String, dynamic> json) {
    return DatePlan(
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }
}

class Plan {
  final String id;
  final String planType;

  Plan({
    required this.id,
    required this.planType,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['_id'],
      planType: json['planType'],
    );
  }
}
