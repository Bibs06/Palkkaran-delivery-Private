class BottleInfoModel {
  final List<Data> data;

  BottleInfoModel({required this.data});

  factory BottleInfoModel.fromJson(List<dynamic> json) {
    return BottleInfoModel(
        data: json.map((data) => Data.fromJson(data)).toList());
  }
}

class Data {
  final int bottles;
  final int returnedBottles;
  final int pendingBottles;
  final Plan plan;

  Data(
      {required this.bottles,
      required this.returnedBottles,
      required this.plan,
      required this.pendingBottles});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        bottles: json['bottles'],
        returnedBottles: json['returnedBottles'],
        plan: Plan.fromJson( json['plan']),
        pendingBottles: json['pendingBottles']);
  }
}

class Plan {
  final String planType;

  Plan({required this.planType});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(planType: json['planType']);
  }
}
