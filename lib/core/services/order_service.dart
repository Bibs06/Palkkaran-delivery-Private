import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:palkkaran/core/models/bottle_info_model.dart';
import 'package:palkkaran/core/models/customers_model.dart';
import 'package:palkkaran/core/models/invoice_model.dart';
import 'package:palkkaran/core/models/message_model.dart';
import 'package:palkkaran/core/models/orders_model.dart';
import 'package:palkkaran/core/models/orders_model_with_sub.dart';
import 'package:palkkaran/core/models/payment_history_model.dart';
import 'package:palkkaran/core/models/quantity_model.dart';
import 'package:palkkaran/core/utils/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:palkkaran/core/utils/local_storage.dart';

class OrderService {
  static final client = http.Client();

  static Future<String?> selectPlan(Map<String, dynamic> payload) async {
    final userId = await LocalStorage.getString('userId');
    payload['customerId'] = userId;

    try {
      var response = await client.post(headers: {
        'Content-Type': 'application/json',
      }, Uri.parse(ApiEndpoints.selectPlanUrl), body: jsonEncode(payload));

      if (response.statusCode == 201) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        return responseData['plan']['_id'].toString();
      } else {
        return null;
      }
    } on SocketException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<MessageModel?> changePlan(Map<String, dynamic> payload) async {
    try {
      var response = await client.put(headers: {
        'Content-Type': 'application/json',
      }, Uri.parse(ApiEndpoints.changePlan), body: jsonEncode(payload));

      // log(response.body);
      log(payload.toString());

      if (response.statusCode == 200) {
        return MessageModel(message: 'Success', success: true);
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        log(response.body);

        return MessageModel(message: responseData['error'], success: false);
      }
    } on SocketException catch (e) {
      return MessageModel(message: 'Network issue', success: false);
    } catch (e) {
      return null;
    }
  }

  static Future<MessageModel?> stopPlan(String planId) async {
    try {
      var response = await client.put(
        Uri.parse(ApiEndpoints.stopPlan.replaceFirst('{planId}', planId)),
      );

      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return MessageModel(message: responseData['message'], success: true);
      } else {
        return MessageModel(message: responseData['message'], success: false);
      }
    } on SocketException catch (e) {
      return MessageModel(message: 'Network issue', success: false);
    } catch (e) {
      return null;
    }
  }

  static Future<OrdersModelWithSub?> getOrdersWithSub(String userId) async {
    try {
      var response = await client.get(
          headers: {
            'Content-Type': 'application/json',
          },
          Uri.parse(ApiEndpoints.ordersWithSubUrl
              .replaceFirst('{userId}', userId.toString())));

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        // log(responseData.toString());
        return OrdersModelWithSub.fromJson(responseData);
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

  static Future<OrdersModel?> getOrders() async {
    final routeId = await LocalStorage.getString('routeNo');

    try {
      var response = await client.get(
          headers: {
            'Content-Type': 'application/json',
          },
          Uri.parse(ApiEndpoints.orderUrl
              .replaceFirst('{routeId}', routeId.toString())));

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        // log(responseData.toString());

        return OrdersModel.fromJson(responseData);
      } else {
        return OrdersModel.fromJson([]);
      }
    } on SocketException catch (e) {
      return null;
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }

  static Future<CustomersModel?> getUsers() async {
    final routeId = await LocalStorage.getString('routeNo');

    try {
      var response = await client.get(
          headers: {
            'Content-Type': 'application/json',
          },
          Uri.parse(ApiEndpoints.usersUrl
              .replaceFirst('{routeId}', routeId.toString())));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        // log(responseData.toString());

        return CustomersModel.fromJson(responseData);
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

  static Future<PaymentHistoryModel?> getPaymentHistory(String csId) async {
    try {
      var response = await client.get(
          headers: {
            'Content-Type': 'application/json',
          },
          Uri.parse(
              ApiEndpoints.paymentHistoryUrl.replaceFirst('{csId}', csId)));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        // log(responseData.toString());

        return PaymentHistoryModel.fromJson(responseData);
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

  static Future<InvoiceModel?> getInvoice(String userId) async {
    try {
      var response = await client.get(headers: {
        'Content-Type': 'application/json',
      }, Uri.parse(ApiEndpoints.invoiceUrl.replaceFirst('{userId}', userId)));

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        // log(responseData.toString());

        return InvoiceModel.fromJson(responseData);
      } else {
        // log(response.body);
        return null;
      }
    } on SocketException catch (e) {
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<BottleInfoModel?> bottleInfo(String userId) async {
    try {
      var response = await client.get(
          headers: {
            'Content-Type': 'application/json',
          },
          Uri.parse(
              ApiEndpoints.bottleStockUrl.replaceFirst('{userId}', userId)));

      final url = ApiEndpoints.bottleStockUrl.replaceFirst('{userId}', userId);

      log(url);
      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);

        return BottleInfoModel.fromJson(responseData);
      } else {
        log(response.body);
        return null;
      }
    } on SocketException catch (e) {
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<QuantityModel?> getTodaysQuantity() async {
    try {
      var response = await client.get(headers: {
        'Content-Type': 'application/json',
      }, Uri.parse(ApiEndpoints.todaysQuantityUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        return QuantityModel.fromJson(responseData);
      } else {
        // log(response.body);
        return null;
      }
    } on SocketException catch (e) {
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<QuantityModel?> getTommorowsQuantity() async {
    try {
      var response = await client.get(headers: {
        'Content-Type': 'application/json',
      }, Uri.parse(ApiEndpoints.tommorowQuantityUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        return QuantityModel.fromJson(responseData);
      } else {
        log(response.body);
        return null;
      }
    } on SocketException catch (e) {
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<MessageModel?> addHomeImg(String img, String csId) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
          ApiEndpoints.uploadCustomerHomeUrl.replaceFirst('{customerId}', csId),
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath('image', img),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return MessageModel(message: 'Success', success: true);
      } else {
        print(response.reasonPhrase);
        Map<String, dynamic> responseData =
            jsonDecode(await response.stream.bytesToString());
        return MessageModel(message: responseData['message'], success: false);
      }
    }on SocketException catch (e) {
      return MessageModel(message: 'Network error', success: false);
    }  catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<MessageModel?> deliverProduct(
      String orderId, Map<String, dynamic> payload) async {
    try {
      final url =
          ApiEndpoints.deliverProdUrl.replaceFirst('{orderId}', orderId);
      var response = await client.patch(
          headers: {
            'Content-Type': 'application/json',
          },
          Uri.parse(
              ApiEndpoints.deliverProdUrl.replaceFirst('{orderId}', orderId)),
          body: jsonEncode(payload));

      if (response.statusCode == 200) {
        log(response.body);

        Map<String, dynamic> responseData = jsonDecode(response.body);

        log(responseData.toString());

        return MessageModel(message: responseData['message'], success: true);
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        log(responseData.toString());

        return MessageModel(message: responseData['message'], success: false);
      }
    } on SocketException catch (e) {
      return MessageModel(message: 'Network error', success: false);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<MessageModel?> updateBottle(
      String userId, Map<String, dynamic> payload) async {
    try {
      var response = await client.put(
          headers: {
            'Content-Type': 'application/json',
          },
          Uri.parse(
              ApiEndpoints.returnBottleUrl.replaceFirst('{userId}', userId)),
          body: jsonEncode(payload));

      if (response.statusCode == 200) {
        log(response.body);

        Map<String, dynamic> responseData = jsonDecode(response.body);

        log(responseData.toString());

        return MessageModel(message: responseData['message'], success: true);
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        log(responseData.toString());

        return MessageModel(message: responseData['message'], success: false);
      }
    } on SocketException catch (e) {
      return MessageModel(message: 'Network error', success: false);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  static Future<MessageModel?> addPayment(Map<String, dynamic> payload) async {
    try {
      var response = await client.post(headers: {
        'Content-Type': 'application/json',
      }, Uri.parse(ApiEndpoints.addPaymentUrl), body: jsonEncode(payload));

      if (response.statusCode == 200) {
        log(response.body);

        Map<String, dynamic> responseData = jsonDecode(response.body);

        log(responseData.toString());

        return MessageModel(message: responseData['message'], success: true);
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);

        log(responseData.toString());

        return MessageModel(message: responseData['message'], success: false);
      }
    } on SocketException catch (e) {
      return MessageModel(message: 'Network error', success: false);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
