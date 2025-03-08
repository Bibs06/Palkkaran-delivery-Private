import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:palkkaran/core/models/message_model.dart';
import 'package:palkkaran/core/utils/endpoints.dart';
import 'package:palkkaran/core/utils/local_storage.dart';


class AuthService {
  static final client = http.Client();

  static Future<MessageModel?> login(Map<String, dynamic> payload) async {
    try {
      var response = await client.post(Uri.parse(ApiEndpoints.loginUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(payload));
      if (response.statusCode == 200) {
        Map<String,dynamic> responseData = jsonDecode(response.body);
        await LocalStorage.setString({
          'accessToken': responseData['token'],
          'userId': responseData['adminDetails']['_id'],
          'username': responseData['adminDetails']['name'],
          'routeNo': responseData['adminDetails']['route'],
        });
        return MessageModel(message: 'Login success', success: true);
      } else {
        var responseData = jsonDecode(response.body);
        log(response.body);
        return MessageModel(message: responseData['message'], success: false);
      }
    } on SocketException catch (e) {
      return MessageModel(message: 'Network issue', success: false);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<MessageModel?> signUp(Map<String, dynamic> payload) async {
    try {
      var response = await client.post(Uri.parse(ApiEndpoints.loginUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(payload));
      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        log(response.body);
        LocalStorage.setString({
          'accessToken': responseData['accessToken'],
          'userId': responseData['user']['userId'],
          // 'address': responseData['user']['address'][0]['streetAddress'],
          'username': responseData['user']['username']
        });
        return MessageModel(message: 'Login success', success: true);
      } else {
        var responseData = jsonDecode(response.body);
        return MessageModel(message: responseData['message'], success: false);
      }
    } on SocketException catch (e) {
      return MessageModel(message: 'Network issue', success: false);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
