import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palkkaran/core/enums/view_state.dart';
import 'package:palkkaran/core/models/bottle_info_model.dart';
import 'package:palkkaran/core/models/customer_profile_model.dart';
import 'package:palkkaran/core/models/customers_model.dart';
import 'package:palkkaran/core/models/invoice_model.dart';
import 'package:palkkaran/core/models/message_model.dart';
import 'package:palkkaran/core/models/orders_model.dart';
import 'package:palkkaran/core/models/orders_model_with_sub.dart';
import 'package:palkkaran/core/models/payment_history_model.dart';
import 'package:palkkaran/core/models/quantity_model.dart';
import 'package:palkkaran/core/services/order_service.dart';
import 'package:palkkaran/core/services/profile_service.dart';
import 'package:palkkaran/core/utils/local_storage.dart';

class OrderViewModel extends StateNotifier<OrderState> {
  OrderViewModel() : super(OrderState());

  List<OrdersData> pendingOrdersData = [];
  List<OrdersData> allOrdersData = [];
  OrdersModel? ordersModel;
  String? planId;

  Future<void> getOrders() async {
    // Set both states to loading
    state = state.copyWith(
      pendingOrderState: ViewState.loading,
      allOrderState: ViewState.loading,
    );

    // Fetch the orders once
    ordersModel = await OrderService.getOrders();
    DateTime today = DateTime.now();

    if (ordersModel != null &&
        ordersModel!.data != null &&
        ordersModel!.data!.isNotEmpty) {
      // Filter pending orders
      pendingOrdersData = ordersModel!.data!.where((data) {
        if (data.selectedPlanDetails.dates == null ||
            data.selectedPlanDetails.dates!.isEmpty) {
          return false;
        }
        // if (data.selectedPlanDetails.dates.toLowerCase() != 'pending') {
        //   return false;
        // }
        return data.selectedPlanDetails.dates!.any((dateItem) {
          if (dateItem is Map<String, dynamic> &&
              dateItem.containsKey('date')) {
            DateTime? parsedDate = DateTime.tryParse(dateItem['date']);
            if (parsedDate == null) return false;
            return parsedDate.year == today.year &&
                parsedDate.month == today.month &&
                parsedDate.day == today.day &&
                dateItem.containsValue('pending');
          }
          return false;
        });
      }).toList();

      pendingOrdersData.sort((a, b) =>
          a.customer.customerIndex.compareTo(b.customer.customerIndex));

      // Filter all orders (you might have a slightly different condition here)
      allOrdersData = ordersModel!.data!.where((data) {
        if (data.selectedPlanDetails.dates == null ||
            data.selectedPlanDetails.dates!.isEmpty) {
          return false;
        }

        return data.selectedPlanDetails.dates!.any((dateItem) {
          if (dateItem is Map<String, dynamic> &&
              dateItem.containsKey('date')) {
            DateTime? parsedDate = DateTime.tryParse(dateItem['date']);
            if (parsedDate == null) return false;
            return parsedDate.year == today.year &&
                parsedDate.month == today.month &&
                parsedDate.day == today.day &&
                dateItem.containsValue('delivered');
          }
          return false;
        });
      }).toList();

      allOrdersData.sort((a, b) =>
          a.customer.customerIndex.compareTo(b.customer.customerIndex));

      // Update the state for both
      state = state.copyWith(
        pendingOrderState: ViewState.idle,
        pendingOrders: pendingOrdersData,
        allOrderState: ViewState.idle,
        allOrders: allOrdersData,
      );
    } else {
      // Update state if no data available
      state = state.copyWith(
        pendingOrderState: ViewState.idle,
        pendingOrders: [],
        allOrderState: ViewState.idle,
        allOrders: [],
      );
    }
  }

  Future<MessageModel?> addCustomHome(String img, String csId) async {
    log(csId.toString());
    log(img);
    MessageModel? messageModel = await OrderService.addHomeImg(img, csId);
    return messageModel;
  }

  Future<MessageModel?> addPayment(Map<String, dynamic> payload) async {
    MessageModel? messageModel = await OrderService.addPayment(payload);
    return messageModel;
  }

  Future<MessageModel?> returnBottle(
      String userId, Map<String, dynamic> payload) async {
    MessageModel? messageModel =
        await OrderService.updateBottle(userId, payload);
    return messageModel;
  }

  Future<void> getUsers() async {
    state = state.copyWith(
      usersState: ViewState.loading,
    );
    CustomersModel? customersModel = await OrderService.getUsers();
    state = state.copyWith(
        usersState: ViewState.idle, customersModel: customersModel);
  }

  Future<void> getCustomerProfile(String userId) async {
    state = state.copyWith(
      usersState: ViewState.loading,
    );
    CustomerProfileModel? customerProfileModel =
        await ProfileService.getCustomerProfile(userId);
    state = state.copyWith(
        usersState: ViewState.idle, customerProfileModel: customerProfileModel);
  }

  // Future<void> getPaymentHistory(String csId) async {

  //   state = state.copyWith(
  //     paymentHistoryState: ViewState.loading,

  //   );
  //   PaymentHistoryModel? paymentHistoryModel =
  //       await OrderService.getPaymentHistory(csId);
  //        List<PaymentDetails> paymentDetails = [];
  //   if (paymentHistoryModel != null &&
  //       paymentHistoryModel.paidAmounts != [] &&
  //       paymentHistoryModel.paidAmounts.isNotEmpty) {
  //      paymentDetails = paymentHistoryModel.paidAmounts
  //       ..sort(
  //           (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
  //   }

  //   state = state.copyWith(
  //       paymentHistoryState: ViewState.idle, paymentDetails: paymentDetails);
  // }

  Future<void> getInvoice(String userID) async {
    state = state.copyWith(
      paymentHistoryState: ViewState.loading,
    );

    InvoiceModel? invoiceModel = await OrderService.getInvoice(userID);
    num total = 0;
    num pending = 0;
    if (invoiceModel != null && invoiceModel.invoice.isNotEmpty) {
      for (var data in invoiceModel.invoice) {
        total = data.invoiceData.total + total;

        pending = data.invoiceData.customer.paidAmounts
            .fold(0, (sum, item) => sum + (item.amount as num));
      }
    }

    state = state.copyWith(
        paymentHistoryState: ViewState.idle,
        invoiceModel: invoiceModel,
        pending: pending,
        total: total);
  }

  Future<void> getBottleInfo(String userId) async {
    state = state.copyWith(
      bottleState: ViewState.loading,
    );
    BottleInfoModel? bottleInfoModel = await OrderService.bottleInfo(userId);

    state = state.copyWith(
      bottleState: ViewState.idle,
      bottleInfoModel: bottleInfoModel,
    );
  }

  Future<void> getTodaysQuantity() async {
    state = state.copyWith(
      todayQuantityState: ViewState.loading,
    );
    QuantityModel? quantityModel = await OrderService.getTodaysQuantity();
    final routeId = await LocalStorage.getString('routeNo');
    if (quantityModel != null) {
      final data = quantityModel?.data[routeId];

      double totalLiters = 0.0;

      if (data!.products.isNotEmpty) {
        for (var product in data.products.values) {
          totalLiters += product.totalLiters;
        }
      }

      state = state.copyWith(
          todayQuantityState: ViewState.idle,
          todaysQuantity: data,
          todaysLtr: totalLiters);
    } else {
      state = state.copyWith(
          todayQuantityState: ViewState.idle,
          todaysQuantity: null,
          todaysLtr: 0);
    }
  }

  Future<void> getTommorowsQuantity() async {
    state = state.copyWith(
      tommorowQuantityState: ViewState.loading,
    );
    QuantityModel? quantityModel = await OrderService.getTommorowsQuantity();
    final routeId = await LocalStorage.getString('routeNo');
    if (quantityModel != null) {
      final data = quantityModel?.data?[routeId];
      double totalLiters = 0.0;

      if (data!.products.isNotEmpty) {
        for (var product in data.products.values) {
          totalLiters += product.totalLiters;
        }
      }

      state = state.copyWith(
          tommorowQuantityState: ViewState.idle,
          tommorowsQuantity: data,
          tommorowsLtr: totalLiters);
    }
    else {
        state = state.copyWith(
          tommorowQuantityState: ViewState.idle,
          tommorowsQuantity: null,
          tommorowsLtr: 0);
    }
  }

  Future<void> getOrdersWithSub(String userId) async {
    state = state.copyWith(orderWithSubState: ViewState.loading);
    // await Future.delayed(Duration(seconds: 1));

    OrdersModelWithSub? ordersModelWithSub =
        await OrderService.getOrdersWithSub(userId);
    log(ordersModelWithSub.toString());
    state = state.copyWith(
        ordersModelWithSub: ordersModelWithSub,
        orderWithSubState: ViewState.idle);
  }

  Future<MessageModel?> deliverProduct(
      String orderId, Map<String, dynamic> payload) async {
    log(payload.toString());
    MessageModel? messageModel =
        await OrderService.deliverProduct(orderId, payload);
    return messageModel;
  }

  Future<MessageModel?> stopPlan(String planId) async {
    MessageModel? model = await OrderService.stopPlan(planId);

    return model;
  }

  Future<void> selectPlan(Map<String, dynamic> payload) async {
    log(payload.toString());
    planId = await OrderService.selectPlan(payload);
  }

  Future<MessageModel?> changePlan(Map<String, dynamic> payload) async {
    MessageModel? messageModel = await OrderService.changePlan(payload);
    return messageModel;
  }
}

class OrderState {
  final ViewState pendingOrderState;
  final ViewState allOrderState;
  ViewState? orderState;
  ViewState? orderWithSubState;
  OrdersModelWithSub? ordersModelWithSub;

  final ViewState todayQuantityState;
  final ViewState tommorowQuantityState;
  final RouteData? todaysQuantity;
  final ViewState bottleState;
  final BottleInfoModel? bottleInfoModel;
  final RouteData? tommorowsQuantity;
  final List<OrdersData>? pendingOrders;
  final List<OrdersData>? allOrders;
  final num? pending;
  final num? total;
  final CustomersModel? customersModel;
  final ViewState paymentHistoryState;
  final InvoiceModel? invoiceModel;
  final ViewState usersState;
  final num? todaysLtr;
  final num? tommorowsLtr;
  final CustomerProfileModel? customerProfileModel;

  OrderState(
      {this.pendingOrderState = ViewState.idle,
      this.allOrderState = ViewState.idle,
      this.orderWithSubState = ViewState.idle,
      this.todayQuantityState = ViewState.idle,
      this.ordersModelWithSub,
      this.tommorowQuantityState = ViewState.idle,
      this.customerProfileModel,
      this.bottleState = ViewState.idle,
      this.bottleInfoModel,
      this.pending,
      this.total,
      this.todaysLtr,
      this.tommorowsLtr,
      this.todaysQuantity,
      this.tommorowsQuantity,
      this.paymentHistoryState = ViewState.idle,
      this.invoiceModel,
      this.pendingOrders,
      this.usersState = ViewState.idle,
      this.customersModel,
      this.allOrders});

  OrderState copyWith(
      {ViewState? allOrderState,
      BottleInfoModel? bottleInfoModel,
      ViewState? orderWithSubState,
      OrdersModelWithSub? ordersModelWithSub,
      ViewState? bottleState,
      ViewState? pendingOrderState,
      ViewState? usersState,
      num? pending,
      num? total,
      num? todaysLtr,
      num? tommorowsLtr,
      CustomersModel? customersModel,
      ViewState? todayQuantityState,
      ViewState? tommorowQuantityState,
      CustomerProfileModel? customerProfileModel,
      RouteData? todaysQuantity,
      RouteData? tommorowsQuantity,
      ViewState? paymentHistoryState,
      InvoiceModel? invoiceModel,
      List<OrdersData>? allOrders,
      List<OrdersData>? pendingOrders}) {
    return OrderState(
        pendingOrderState: pendingOrderState ?? this.pendingOrderState,
        allOrderState: allOrderState ?? this.allOrderState,
        customersModel: customersModel ?? this.customersModel,
        customerProfileModel: customerProfileModel ?? this.customerProfileModel,
        ordersModelWithSub: ordersModelWithSub ?? this.ordersModelWithSub,
        orderWithSubState: orderWithSubState ?? this.orderWithSubState,
        bottleInfoModel: bottleInfoModel ?? bottleInfoModel,
        bottleState: bottleState ?? this.bottleState,
        usersState: usersState ?? this.usersState,
        todaysLtr: todaysLtr ?? this.todaysLtr,
        tommorowsLtr: tommorowsLtr ?? this.tommorowsLtr,
        allOrders: allOrders ?? this.allOrders,
        todayQuantityState: todayQuantityState ?? this.todayQuantityState,
        tommorowQuantityState:
            tommorowQuantityState ?? this.tommorowQuantityState,
        pending: pending ?? this.pending,
        total: total ?? this.total,
        todaysQuantity: todaysQuantity ?? this.todaysQuantity,
        tommorowsQuantity: tommorowsQuantity ?? this.tommorowsQuantity,
        paymentHistoryState: paymentHistoryState ?? this.paymentHistoryState,
        invoiceModel: invoiceModel ?? this.invoiceModel,
        pendingOrders: pendingOrders ?? this.pendingOrders);
  }
}

final orderProvider = StateNotifierProvider<OrderViewModel, OrderState>(
    (ref) => OrderViewModel());
