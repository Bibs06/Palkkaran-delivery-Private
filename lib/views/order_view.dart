import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/enums/view_state.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/view_models/order_view_model.dart';
import 'package:palkkaran/views/order_details_view.dart';

class OrdersView extends ConsumerStatefulWidget {
  const OrdersView({super.key});

  @override
  ConsumerState<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends ConsumerState<OrdersView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Orders',
            style: TextStyle(
              color: ColorUtils.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              color: ColorUtils.white,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          'Pending',
                          style: TextStyle(
                            color: ColorUtils.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Delivered',
                          style: TextStyle(
                            color: ColorUtils.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: RefreshIndicator(
                  elevation: 0,
                  color: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  onRefresh: () async {
                    ref.read(orderProvider.notifier).getOrders();
                  },
                  child: TabBarView(
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      RefreshIndicator(
                        elevation: 0,
                        color: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        onRefresh: () async {
                          await ref.read(orderProvider.notifier).getOrders();
                        },
                        child: ListView(
                          children: [
                            Consumer(builder: (context, ref, child) {
                              final model = ref.watch(orderProvider);
                              if (model.pendingOrderState ==
                                  ViewState.loading) {
                                return Center(
                                  heightFactor: 15.h,
                                  child: CircularProgressIndicator(
                                    color: ColorUtils.kPrimary,
                                  ),
                                );
                              } else if (model.pendingOrders == null ||
                                  model.pendingOrders!.isEmpty) {
                                return Center(
                                  heightFactor: 20.h,
                                  child: Text('No orders found',
                                      style: TextStyle(
                                          color: ColorUtils.black,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold)),
                                );
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: model.pendingOrders?.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Go.to(
                                              context,
                                              OrderDetailsView(
                                                userId: model
                                                    .pendingOrders![index]
                                                    .customer
                                                    .id,
                                                homeImg: model
                                                    .pendingOrders![index]
                                                    .customer
                                                    .image
                                                    .toString(),
                                                homeImgAvailable: model
                                                            .pendingOrders![
                                                                index]
                                                            .customer
                                                            .image ==
                                                        null
                                                    ? true
                                                    : false,
                                                csId: model
                                                    .pendingOrders![index]
                                                    .customer
                                                    .customerId,
                                                orderId: model
                                                    .pendingOrders![index].id,
                                                products: model
                                                    .pendingOrders![index]
                                                    .productItems,
                                                date: model
                                                    .pendingOrders![index]
                                                    .selectedPlanDetails
                                                    .dates[0]['date'],
                                              ));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 15.h),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 16.h),
                                          decoration: BoxDecoration(
                                              color: ColorUtils.white,
                                              borderRadius:
                                                  BorderRadius.circular(22.sp),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: ColorUtils.grey,
                                                ),
                                              ]),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      model
                                                          .pendingOrders![index]
                                                          .customer
                                                          .name,
                                                      style: TextStyle(
                                                          color:
                                                              ColorUtils.black,
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      model
                                                          .pendingOrders![index]
                                                          .address
                                                          .streetAddress,
                                                      style: TextStyle(
                                                        color: ColorUtils.black,
                                                        fontSize: 18.sp,
                                                      )),
                                                  Text(
                                                      'Total Products : ${model.pendingOrders![index].productItems.length.toString()}',
                                                      style: TextStyle(
                                                        color: ColorUtils.black,
                                                        fontSize: 18.sp,
                                                      )),
                                                ],
                                              ),
                                              Spacer(),
                                              CustomBtn(
                                                color: Colors.transparent,
                                                btnText: 'Done',
                                                borderColor:
                                                    ColorUtils.kPrimary,
                                                padH: 5.w,
                                                padV: 5.h,
                                                height: 40.h,
                                                width: 80.w,
                                                borderRadius: 12.sp,
                                                btnTextColor: ColorUtils.black,
                                                onTap: () {
                                                  DateTime now = DateTime.now();
                                                  String formattedDate =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(now);
                                                  ref
                                                      .read(orderProvider
                                                          .notifier)
                                                      .deliverProduct(
                                                          model
                                                              .pendingOrders![
                                                                  index]
                                                              .id,
                                                          {
                                                        'date': formattedDate,
                                                        'status': 'delivered'
                                                      }).then((response) {
                                                    customToast(
                                                        response!.message);
                                                    if (response!.success) {
                                                      ref
                                                          .read(orderProvider
                                                              .notifier)
                                                          .getOrders();
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                            }),
                          ],
                        ),
                      ),
                      RefreshIndicator(
                        elevation: 0,
                        color: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        onRefresh: () async {
                          await ref.read(orderProvider.notifier).getOrders();
                        },
                        child: ListView(
                          children: [
                            Consumer(builder: (context, ref2, child) {
                              final model = ref2.watch(orderProvider);
                              if (model.allOrderState == ViewState.loading) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: ColorUtils.kPrimary,
                                  ),
                                );
                              } else if (model.allOrders == null ||
                                  model.allOrders!.isEmpty) {
                                return Center(
                                  heightFactor: 20.h,
                                  child: Text('No orders found',
                                      style: TextStyle(
                                          color: ColorUtils.black,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold)),
                                );
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: model.allOrders!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 15.h),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 16.h),
                                        decoration: BoxDecoration(
                                            color: ColorUtils.white,
                                            borderRadius:
                                                BorderRadius.circular(22.sp),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ColorUtils.grey,
                                              ),
                                            ]),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    model.allOrders![index]
                                                        .customer.name,
                                                    style: TextStyle(
                                                        color: ColorUtils.black,
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    model.allOrders![index]
                                                        .address.streetAddress,
                                                    style: TextStyle(
                                                      color: ColorUtils.black,
                                                      fontSize: 18.sp,
                                                    )),
                                                Text(
                                                    'Total Products : ${model.allOrders![index].productItems.length.toString()}',
                                                    style: TextStyle(
                                                      color: ColorUtils.black,
                                                      fontSize: 18.sp,
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              }
                            }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
