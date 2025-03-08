import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:palkkaran/core/models/customer_profile_model.dart';
import 'package:palkkaran/core/models/message_model.dart';
import 'package:palkkaran/core/models/profile_model.dart';
import 'package:palkkaran/core/utils/endpoints.dart';
import 'package:palkkaran/core/utils/local_storage.dart';

class ProfileService {
  static final client = http.Client();

  static Future<ProfileModel?> getProfile() async {
    try {
      final userId = await LocalStorage.getString('userId');
      var response = await client.get(
        Uri.parse(
          ApiEndpoints.profileUrl.replaceFirst('{userId}', userId.toString()),
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        log(response.body);

        return ProfileModel.fromJson(responseData);
      } else {
        log(response.body);

        return null;
      }
    } on SocketException catch (e) {
      return null;
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }

  static Future<MessageModel?> updatePassword(
      Map<String, dynamic> payload) async {
    try {
      final userId = await LocalStorage.getString('userId');
      var response = await client.put(
          headers: {
            'Content-Type': 'application/json',
          },
          Uri.parse(
            ApiEndpoints.changePassUrl.replaceFirst(
              '{userId}',
              userId.toString(),
            ),
          ),
          body: jsonEncode(payload));
      if (response.statusCode == 200) {
        return MessageModel(message: 'updated', success: true);
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return MessageModel(message: responseData['message'], success: false);
      }
    } on SocketException catch (e) {
      return MessageModel(message: 'Network issue', success: false);
    } catch (e) {
      return null;
    }
  }

  static Future<CustomerProfileModel?> getCustomerProfile(String userId) async {
    try {
      var response = await client.get(
        Uri.parse(ApiEndpoints.customerProfileUrl
            .replaceFirst('{userId}', userId.toString())),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        return CustomerProfileModel.fromJson(responseData);
      } else {
        return null;
      }
    } on SocketException catch (e) {
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<MessageModel?> updateProfile(
      Map<String, dynamic> payload) async {
    var request = http.MultipartRequest('PUT',
        Uri.parse('https://api.palkkaran.in/admin/67a4555f06fb649e03f30c83'));
    request.fields.addAll({
      'name': 'Akmal',
      'email': 'akmal@gmail.com',
      'phone': '9090909090',
      'role': 'Delivery Boy'
    });
    request.files
        .add(await http.MultipartFile.fromPath('image', payload['image']));

    http.StreamedResponse response = await request.send();
    try {
      if (response.statusCode == 200) {
        log(await response.stream.bytesToString());
        return MessageModel(message: 'Success', success: true);
      } else {
        log(await response.stream.bytesToString());
        return MessageModel(message: 'failed', success: false);
      }
    } on SocketException catch (e) {
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // static Future<MessageModel?> updateProfile(
  //     Map<String, dynamic> payload) async {
  //   try {
  //     var uri = Uri.parse(ApiEndpoints.profileUrl);
  //     var request = http.MultipartRequest("PUT", uri)
  //       ..headers["Content-Type"] = "multipart/form-data";

  //     payload.forEach((key, value) {
  //       if (value is String) {
  //         request.fields[key] = value;
  //       }
  //     });

  //     if (payload['image'] != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           "image",
  //           payload['image'],
  //         ),
  //       );
  //     }

  //      log(request.fields.toString());

  //     var response = await request.send();

  //     if (response.statusCode == 200) {
  //       log(await response.stream.bytesToString());
  //       return MessageModel(message: 'Success', success: true);
  //     } else {
  //       log(await response.stream.bytesToString());
  //       return MessageModel(message: 'failed', success: false);
  //     }
  //   } on SocketException catch (e) {
  //     return null;
  //   } catch (e) {
  //     log(e.toString());
  //     return null;
  //   }
  // }
}
