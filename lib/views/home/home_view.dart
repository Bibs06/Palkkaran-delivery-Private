import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/enums/view_state.dart';
import 'package:palkkaran/core/models/quantity_model.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/constants.dart';
import 'package:palkkaran/core/utils/global_variables.dart';
import 'package:palkkaran/core/utils/image_assets.dart';
import 'package:palkkaran/core/utils/local_storage.dart';
import 'package:palkkaran/core/view_models/order_view_model.dart';
import 'package:palkkaran/core/view_models/profile_view_model.dart';
import 'package:palkkaran/views/order_details_view.dart';

final routeProvider = StateProvider((ref) => '');

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    getRoute();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).getOrders();
      ref.read(orderProvider.notifier).getTodaysQuantity();
      ref.read(orderProvider.notifier).getTommorowsQuantity();
      final model = ref.watch(profileProvider);
      if (model.profileModel == null) {
        ref.read(profileProvider.notifier).getProfile();
      }
    });
  }

  getRoute() async {
    final routeName = await LocalStorage.getString('routeNo');
    ref.read(routeProvider.notifier).state = routeName.toString();
  }

  void showQuantityModal(
      BuildContext context, Map<String, ProductType> quantities) {
    showModalBottomSheet(
      backgroundColor: ColorUtils.white,
      context: context,
      showDragHandle: true,
      isScrollControlled: true, // Allows full-height scrolling
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5, // Half of the screen height initially
          minChildSize: 0.3, // Minimum height when dragged down
          maxChildSize: 0.9, // Maximum height when dragged up
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Milk Quantities",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      controller: scrollController,
                      itemCount: quantities.length,
                      itemBuilder: (context, index) {
                        String key = quantities.keys.elementAt(index);
                        final value = quantities[key]!;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Text(
                              "$key \n${value.quantities.toString().replaceAll('{', '').replaceAll('}', '')}",
                              style: TextStyle(
                                  color: ColorUtils.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route',
              style: TextStyle(
                  color: ColorUtils.kPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
            ),
            Consumer(builder: (context, ref, child) {
              final route = ref.watch(routeProvider);
              return Text(
                route,
                style: TextStyle(
                  color: ColorUtils.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
              );
            }),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Consumer(builder: (context, ref, child) {
              final model = ref.watch(profileProvider);
              if (model.profileState == ViewState.loading) {
                return CircleAvatar(
                    backgroundColor: ColorUtils.white,
                    backgroundImage: AssetImage(ImageAssets.avatar));
              } else if (model.profileModel == null ||
                  model.profileModel!.image.isEmpty) {
                return CircleAvatar(
                    backgroundColor: ColorUtils.white,
                    backgroundImage: AssetImage(ImageAssets.avatar));
              } else {
                return CircleAvatar(
                    backgroundColor: ColorUtils.white,
                    backgroundImage: CachedNetworkImageProvider(
                        '$imgBaseUrl/${model.profileModel!.image}'));
              }
            }),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: RefreshIndicator(
          elevation: 0,
          color: Colors.transparent,
          backgroundColor: Colors.transparent,
          onRefresh: () async {
            await ref.read(orderProvider.notifier).getOrders();
          },
          child: ListView(
            children: [
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 20.w, vertical: 18.h),
                    decoration: BoxDecoration(
                        color: ColorUtils.white,
                        borderRadius: BorderRadius.circular(22.sp),
                        boxShadow: [
                          BoxShadow(
                            color: ColorUtils.grey,
                          ),
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer(builder: (context, ref, child) {
                          final model = ref.watch(orderProvider);
                          if (model.pendingOrderState == ViewState.loading) {
                            return Center(
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: ColorUtils.black,
                                    fontSize: 52.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else if (model.pendingOrders == null ||
                              model.pendingOrders!.isEmpty) {
                            return Center(
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: ColorUtils.black,
                                    fontSize: 52.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return Text(
                              model.pendingOrders!.length.toString(),
                              style: TextStyle(
                                  color: ColorUtils.black,
                                  fontSize: 52.sp,
                                  fontWeight: FontWeight.bold),
                            );
                          }
                        }),
                        Text(
                          'RUNNING ORDERS',
                          style: TextStyle(
                              color: ColorUtils.grey,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 20.w, vertical: 18.h),
                    decoration: BoxDecoration(
                        color: ColorUtils.white,
                        borderRadius: BorderRadius.circular(22.sp),
                        boxShadow: [
                          BoxShadow(
                            color: ColorUtils.grey,
                          ),
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer(builder: (context, ref2, child) {
                          final model = ref2.watch(orderProvider);
                          if (model.allOrderState == ViewState.loading) {
                            return Center(
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: ColorUtils.black,
                                    fontSize: 52.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else if (model.allOrders == null ||
                              model.allOrders!.isEmpty) {
                            return Center(
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: ColorUtils.black,
                                    fontSize: 52.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return Text(
                              model.allOrders!.length.toString(),
                              style: TextStyle(
                                  color: ColorUtils.black,
                                  fontSize: 52.sp,
                                  fontWeight: FontWeight.bold),
                            );
                          }
                        }),
                        Text(
                          'ORDER DELIVERED',
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 20.w, vertical: 18.h),
                    decoration: BoxDecoration(
                        color: ColorUtils.white,
                        borderRadius: BorderRadius.circular(22.sp),
                        boxShadow: [
                          BoxShadow(
                            color: ColorUtils.grey,
                          ),
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer(builder: (context, ref, child) {
                          final model = ref.watch(orderProvider);
                          if (model.todayQuantityState == ViewState.loading) {
                            return Center(
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: ColorUtils.black,
                                    fontSize: 52.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else if (model.todaysQuantity == null ||
                              model.todaysQuantity!.products.isEmpty) {
                            return Center(
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: ColorUtils.black,
                                    fontSize: 52.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                showQuantityModal(
                                    context, model.todaysQuantity!.products);
                              },
                              child: Text(
                                '${model.todaysLtr!.toStringAsFixed(2)} Ltr',
                                style: TextStyle(
                                    color: ColorUtils.black,
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                        }),
                        Text(
                          'TODAYS QTY',
                          style: TextStyle(
                              color: ColorUtils.grey,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 20.w, vertical: 18.h),
                    decoration: BoxDecoration(
                        color: ColorUtils.white,
                        borderRadius: BorderRadius.circular(22.sp),
                        boxShadow: [
                          BoxShadow(
                            color: ColorUtils.grey,
                          ),
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer(builder: (context, ref2, child) {
                          final model = ref2.watch(orderProvider);
                          if (model.tommorowQuantityState ==
                              ViewState.loading) {
                            return Center(
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: ColorUtils.black,
                                    fontSize: 52.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else if (model.tommorowsQuantity == null ||
                              model.tommorowsQuantity!.products!.isEmpty) {
                            return Center(
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: ColorUtils.black,
                                    fontSize: 52.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                showQuantityModal(
                                    context, model.todaysQuantity!.products);
                              },
                              child: Text(
                                '${model.tommorowsLtr!.toStringAsFixed(2)} Ltr',
                                style: TextStyle(
                                    color: ColorUtils.black,
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                        }),
                        Text(
                          "TOMMOROW'S QTY",
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Consumer(builder: (context, ref, child) {
                final model = ref.watch(orderProvider);
                if (model.pendingOrderState == ViewState.loading) {
                  return Center(
                    heightFactor: 8.h,
                    child: CircularProgressIndicator(
                      color: ColorUtils.kPrimary,
                    ),
                  );
                } else if (model.pendingOrders == null ||
                    model.pendingOrders!.isEmpty) {
                  return Center(
                    heightFactor: 10.h,
                    child: Text(
                      'No orders found',
                      style: TextStyle(
                          color: ColorUtils.black,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                    ),
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
                                    userId:
                                        model.pendingOrders![index].customer.id,
                                    orderId: model.pendingOrders![index].id,
                                    csId: model.pendingOrders![index].customer
                                        .customerId,
                                    homeImg: model
                                        .pendingOrders![index].customer.image
                                        .toString(),
                                    homeImgAvailable: model
                                                .pendingOrders![index]
                                                .customer
                                                .image ==
                                            null
                                        ? true
                                        : false,
                                    date: model.pendingOrders![index]
                                        .selectedPlanDetails.dates[0]['date'],
                                    products: model
                                        .pendingOrders![index].productItems));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            decoration: BoxDecoration(
                                color: ColorUtils.white,
                                borderRadius: BorderRadius.circular(22.sp),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorUtils.grey,
                                  ),
                                ]),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        model.pendingOrders![index].customer
                                            .name,
                                        style: TextStyle(
                                            color: ColorUtils.black,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        model.pendingOrders![index].address
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
                                  borderColor: ColorUtils.kPrimary,
                                  padH: 5.w,
                                  padV: 5.h,
                                  height: 40.h,
                                  width: 80.w,
                                  borderRadius: 12.sp,
                                  btnTextColor: ColorUtils.black,
                                  onTap: () {
                                    DateTime now = DateTime.now();
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd').format(now);
                                    ref
                                        .read(orderProvider.notifier)
                                        .deliverProduct(
                                            model.pendingOrders![index].id, {
                                      'date': formattedDate,
                                      'status': 'delivered'
                                    }).then((response) {
                                      customToast(response!.message);
                                      if (response!.success) {
                                        ref
                                            .read(orderProvider.notifier)
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
      ),
    );
  }
}
