import 'dart:convert';

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;
  final String image;
  final bool blocked;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.image,
    required this.blocked,
  });

  // Factory constructor to create an instance from a JSON map
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
      phone: json["phone"],
      image: json["image"],
      blocked: json["blocked"],
    );
  }

  

  // Convert JSON string to a Dart object
  static ProfileModel fromJsonString(String jsonString) {
    return ProfileModel.fromJson(json.decode(jsonString));
  }

 
}
