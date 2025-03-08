class ApiEndpoints {
  static const String baseUrl = 'https://api.palkkaran.in';
  static const String loginUrl = '$baseUrl/admin/login';
  static const String orderUrl = '$baseUrl/orderdetails/orders/{routeId}';
  static const String deliverProdUrl = '$baseUrl/orderdetails/{orderId}';
  static const String profileUrl = '$baseUrl/admin/{userId}';
  static const String changePassUrl = '$baseUrl/admin/change-password/{userId}';
  static const String uploadCustomerHomeUrl =
      '$baseUrl/customer/update-image/{customerId}';
  static const String usersUrl =
      '$baseUrl/customer/routeno-based-customer/{routeId}';
  static const String paymentHistoryUrl =
      '$baseUrl/customer/paid-amounts/{csId}';
  static const String invoiceUrl = '$baseUrl/orderdetails/invoices/{userId}';
  static const String addPaymentUrl =
      '$baseUrl/customer/add-paid-amount/customer';
  static const String tommorowQuantityUrl =
      '$baseUrl/orderdetails/tomorrow-orders/routes';
  static const String todaysQuantityUrl =
      '$baseUrl/orderdetails/today-orders/routes';
  static const String bottleStockUrl =
      '$baseUrl/orderdetails/orders/customer/{userId}';

  static const String returnBottleUrl =
      '$baseUrl/orderdetails/orders/{userId}/returned-bottles';
  static const String ordersWithSubUrl = '$baseUrl/orderdetails/{userId}';
  static const String stopPlan = '$baseUrl/orderdetails/stop-plan/{planId}';

  static const String changePlan = '$baseUrl/orderdetails/changeplan';

  static const String selectPlanUrl = '$baseUrl/plan';

  static const String customerProfileUrl = '$baseUrl/customer/{userId}';

  static const String requestOtpUrl = '$baseUrl/admin/forgot-password';
  static const String resetPassUrl = '$baseUrl/admin/reset-password';
}
