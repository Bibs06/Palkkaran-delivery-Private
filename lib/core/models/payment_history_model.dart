class PaymentHistoryModel {
  final List<PaymentDetails> paidAmounts;

  PaymentHistoryModel({required this.paidAmounts});

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      paidAmounts: (json['paidAmounts'] as List<dynamic>)
          .map((item) => PaymentDetails.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paidAmounts': paidAmounts.map((item) => item.toJson()).toList(),
    };
  }
}

class PaymentDetails {
  final String id;
  final String date;
  final double amount;
  final bool isGet;

  PaymentDetails({
    required this.id,
    required this.date,
    required this.amount,
    required this.isGet,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      id: json['_id'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      isGet: json['isGet'] ?? false,
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



