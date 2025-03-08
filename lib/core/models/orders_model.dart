import 'dart:convert';

class OrdersModel {
  final List<OrdersData>? data;
  OrdersModel({this.data});

  factory OrdersModel.fromJson(List<dynamic> json) {
    return OrdersModel(
        data: json.map((data) => OrdersData.fromJson(data)).toList());
  }
}

class OrdersData {
  final String id;
  final SelectedPlanDetails selectedPlanDetails;
  final Address address;
  final Customer customer;
  final List<ProductItem> productItems;
  final String plan;
  final int totalPrice;
  final String paymentMethod;
  final int total;
  final String paymentStatus;
  final bool planIsActive;

  OrdersData({
    required this.id,
    required this.selectedPlanDetails,
    required this.address,
    required this.customer,
    required this.productItems,
    required this.plan,
    required this.totalPrice,
    required this.paymentMethod,
    required this.total,
    required this.paymentStatus,
    required this.planIsActive,
  });

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    return OrdersData(
      id: json['_id'],
      selectedPlanDetails:
          SelectedPlanDetails.fromJson(json['selectedPlanDetails']),
      productItems: (json['productItems'] as List)
          .map((item) => ProductItem.fromJson(item))
          .toList(),
      address: Address.fromJson(json['address']),
      customer: Customer.fromJson(json['customer']),
      plan: json['plan'],
      totalPrice: json['totalPrice'],
      paymentMethod: json['paymentMethod'],
      total: json['Total'],
      paymentStatus: json['paymentStatus'],
      planIsActive: json['planisActive'],
    );
  }
}

class SelectedPlanDetails {
  final String planType;
  final List<dynamic> dates;
  final bool isActive;

  SelectedPlanDetails({
    required this.planType,
    required this.dates,
    required this.isActive,
  });

  factory SelectedPlanDetails.fromJson(Map<String, dynamic> json) {
    return SelectedPlanDetails(
      planType: json['planType'],
      dates: json['dates'],
      isActive: json['isActive'],
    );
  }
}

class Address {
  final String postcode;
  final String streetAddress;
  final String apartment;

  Address({
    required this.postcode,
    required this.streetAddress,
    required this.apartment,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      postcode: json['postcode'],
      streetAddress: json['streetAddress'],
      apartment: json['apartment'],
    );
  }
}

class Customer {
  final String id;
  final String email;
  final String name;
  final String customerId;
  final String phone;
  final String? image;
  final String routeNo;
  final int customerIndex;

  Customer({
    required this.id,
    required this.email,
    required this.name,
    required this.customerId,
    required this.customerIndex,
    this.image,
    required this.phone,
    required this.routeNo,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        id: json['_id'],
        email: json['email'],
        customerIndex: json['customerindex'],
        customerId: json["customerId"],
        name: json['name'],
        phone: json['phone'],
        routeNo: json['routeno'],
        image: json['image']);
  }
}

class ProductItem {
  final Product product;
  final int quantity;
  final int routePrice;

  ProductItem({
    required this.product,
    required this.quantity,
    required this.routePrice,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      routePrice: json['routePrice'],
    );
  }
}

class Product {
  final String id;
  final String title;
  final String productId;
  final String category;
  final int price;

  Product({
    required this.id,
    required this.title,
    required this.productId,
    required this.category,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      title: json['title'],
      productId: json['productId'],
      category: json['category'],
      price: json['price'],
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
