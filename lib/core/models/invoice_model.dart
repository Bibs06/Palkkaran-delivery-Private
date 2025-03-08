class InvoiceModel {
  final List<Data> data;

  InvoiceModel({required this.data});

  factory InvoiceModel.fromJson(List<dynamic> json) {
    return InvoiceModel(data:
        json.map((data) => Data.fromJson(data)).toList());
  }
}

class Data {
  final String month;
  final num totalAmount;
  final num paid;
  final num balance;

  Data(
      {required this.month,
      required this.totalAmount,
      required this.paid,
      required this.balance});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        month: json['month'],
        totalAmount: json['totalAmount'],
        paid: json['paid'],
        balance: json['balance']);
  }
}
