import 'dart:convert';


class CustomerProfileModel {
  final String id;
  final String customerId;
  final String email;
  final String name;
  final String phone;
  final List<Address> address;
  final String location;
  final String routeNo;
  final String routeName;
  final String tokens;
  final bool isConfirmed;
  final List<PaidAmount> paidAmounts;

  CustomerProfileModel({
    required this.id,
    required this.customerId,
    required this.email,
    required this.name,
    required this.phone,
    required this.address,
    required this.location,
    required this.routeNo,
    required this.routeName,
    required this.tokens,
    required this.isConfirmed,
    required this.paidAmounts,
  });

  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileModel(
      id: json['_id'] ?? '',
      customerId: json['customerId'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: List<Address>.from(
          json['address']?.map((x) => Address.fromJson(x)) ?? []),
      location: json['location'] ?? '',
      routeNo: json['routeno'] ?? '',
      routeName: json['routename'] ?? '',
      tokens: json['tokens'] ?? '',
      isConfirmed: json['isConfirmed'] ?? false,
      paidAmounts: List<PaidAmount>.from(
         json['paidAmounts']?.map((x) => PaidAmount.fromJson(x)) ?? []),
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
      postcode: json['postcode'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      apartment: json['apartment'] ?? '',
    );
  }
}

class PaidAmount {
  final String date;
  final double amount;
  final bool isGet;

  PaidAmount({
    required this.date,
    required this.amount,
    required this.isGet,
  });

  factory PaidAmount.fromJson(Map<String, dynamic> json) {
    return PaidAmount(
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      isGet: json['isGet'] ?? false,
    );
  }
}
