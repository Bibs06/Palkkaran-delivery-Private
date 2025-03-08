import 'dart:convert';


class InvoiceModel {
  final List<Invoice> invoice;

  InvoiceModel({
    required this.invoice,
  });
 factory InvoiceModel.fromJson(List<dynamic> json) {
    return InvoiceModel(
      invoice: json.map((data) => Invoice.fromJson(data)).toList(),
    );
  }
}

class Invoice {
  final InvoiceData invoiceData;

  Invoice({
    required this.invoiceData,
  });
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
        invoiceData:  InvoiceData.fromJson(json));
  }
}

class InvoiceData {
  final Customer customer;
  final InvoiceDetails invoiceDetails;
  final int total;

  InvoiceData(
      {required this.customer,
      required this.invoiceDetails,
      required this.total});
  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
        customer: Customer.fromJson(json['customer']),
       
        invoiceDetails: InvoiceDetails.fromJson(json['invoiceDetails']),
        total: json['total']);
  }
}

class OrderModel {
  Customer customer;
  InvoiceDetails invoiceDetails;
  List<OrderItem> orderItems;
  double total;
  double paidAmount;

  OrderModel({
    required this.customer,
    required this.invoiceDetails,
    required this.orderItems,
    required this.total,
    required this.paidAmount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      customer: Customer.fromJson(json['customer']),
      invoiceDetails: InvoiceDetails.fromJson(json['invoiceDetails']),
      orderItems: (json['orderItems'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      total: json['total'].toDouble(),
      paidAmount: json['paidAmount'].toDouble(),
    );
  }
}

class Customer {
  String id;
  String customerId;
  String email;
  String name;
  String phone;
  List<PaidAmount> paidAmounts;

  Customer({
    required this.id,
    required this.customerId,
    required this.email,
    required this.name,
    required this.phone,
    required this.paidAmounts,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'],
      customerId: json['customerId'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      paidAmounts: (json['paidAmounts'] as List)
          .map((item) => PaidAmount.fromJson(item))
          .toList(),
    );
  }
}

class PaidAmount {
  String id;
  String date;
  double amount;
  bool isGet;

  PaidAmount({
    required this.id,
    required this.date,
    required this.amount,
    required this.isGet,
  });

  factory PaidAmount.fromJson(Map<String, dynamic> json) {
    return PaidAmount(
      id: json['_id'],
      date: json['date'],
      amount: json['amount'].toDouble(),
      isGet: json['isGet'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date,
      'amount': amount,
      'isGet': isGet,
    };
  }
}

class InvoiceDetails {
  String invoiceNo;
  String paymentType;
  String paymentStatus;

  InvoiceDetails({
    required this.invoiceNo,
    required this.paymentType,
    required this.paymentStatus,
  });

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) {
    return InvoiceDetails(
      invoiceNo: json['invoiceNo'],
      paymentType: json['paymentType'],
      paymentStatus: json['paymentStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceNo': invoiceNo,
      'paymentType': paymentType,
      'paymentStatus': paymentStatus,
    };
  }
}

class OrderItem {
  int no;
  String date;
  String status;
  List<Product> products;

  OrderItem({
    required this.no,
    required this.date,
    required this.status,
    required this.products,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      no: json['no'],
      date: json['date'],
      status: json['status'],
      products: (json['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'date': date,
      'status': status,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }
}

class Product {
  String product;
  int quantity;
  double routePrice;
  double subtotal;

  Product({
    required this.product,
    required this.quantity,
    required this.routePrice,
    required this.subtotal,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product: json['product'],
      quantity: json['quantity'],
      routePrice: json['routePrice'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'quantity': quantity,
      'routePrice': routePrice,
      'subtotal': subtotal,
    };
  }
}
