import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:palkkaran/core/common_widgets/custom_alert.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/models/orders_model.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/constants.dart';
import 'package:palkkaran/core/utils/image_assets.dart';
import 'package:palkkaran/core/view_models/add_image_view_model.dart';
import 'package:palkkaran/core/view_models/order_view_model.dart';
import 'package:palkkaran/views/customer_details_view.dart';
import 'package:palkkaran/views/view_image.dart';

class OrderDetailsView extends ConsumerStatefulWidget {
  final List<ProductItem> products;
  final String userId;
  final String orderId;
  final String date;
  final String homeImg;
  final String csId;
  final bool homeImgAvailable;
  const OrderDetailsView(
      {super.key,
      required this.products,
      required this.orderId,
      required this.userId,
      required this.homeImg,
      required this.homeImgAvailable,
      required this.csId,
      required this.date});

  @override
  ConsumerState<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends ConsumerState<OrderDetailsView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.homeImgAvailable) {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) => Container(
            padding: EdgeInsets.all(16),
            child: Wrap(
              children: [
                Text('Add customer home',
                    style: TextStyle(
                        color: ColorUtils.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold)),
                ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Take Photo',
                        style: TextStyle(
                          color: ColorUtils.black,
                          fontSize: 16.sp,
                        )),
                    onTap: () async {
                      Navigator.pop(context);
                      ref
                          .read(addImageProvider.notifier)
                          .pickImage(ImageSource.camera, context)
                          .then(
                        (_) {
                          final img = ref.watch(addImageProvider);
                          if (img != null && mounted) {
                            Go.to(
                                context,
                                ViewImage(
                                  img: img,
                                  csId: widget.csId,
                                ));
                          }
                        },
                      );
                    }),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Choose from Gallery',
                      style: TextStyle(
                        color: ColorUtils.black,
                        fontSize: 16.sp,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                    ref
                        .read(addImageProvider.notifier)
                        .pickImage(ImageSource.gallery, context);
                  },
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20.sp,
                )),
            SizedBox(
              width: 10.w,
            ),
            GestureDetector(
              onTap: () {
                Go.to(
                    context,
                    CustomerDetailsView(
                        userId: widget.userId, csId: widget.csId));
              },
              child: CircleAvatar(
                backgroundColor: ColorUtils.white,
                radius: 18.sp,
                backgroundImage: AssetImage(ImageAssets.avatar),
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Text(
              'Order Details',
              style: TextStyle(
                  color: ColorUtils.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600),
            ),
          ]),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: CustomBtn(
            color: ColorUtils.kPrimary,
            btnText: 'Confirm delivery',
            padH: 5.w,
            padV: 5.h,
            height: 60.h,
            onTap: () {
              DateTime now = DateTime.now();
              String formattedDate = DateFormat('yyyy-MM-dd').format(now);
              ref.read(orderProvider.notifier).deliverProduct(widget.orderId, {
                'date': formattedDate,
                'status': 'delivered'
              }).then((response) {
                customToast(response!.message);
                if (response!.success) {
                  ref.read(orderProvider.notifier).getOrders();
                  Navigator.pop(context);
                }
              });
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.homeImgAvailable == false)
                CachedNetworkImage(
                  imageUrl: '$imgBaseUrl/${widget.homeImg.toString()}',
                  height: 300.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 15.h),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.products[index].product.title,
                            style: TextStyle(
                              color: ColorUtils.black,
                              fontSize: 20.sp,
                            ),
                          ),
                          Text(
                            widget.products[index].product.category,
                            style: TextStyle(
                              color: ColorUtils.black,
                              fontSize: 18.sp,
                            ),
                          ),
                          Text(
                            'Quantity ${widget.products[index].quantity.toString()}',
                            style: TextStyle(
                              color: ColorUtils.black,
                              fontSize: 18.sp,
                            ),
                          ),
                          Text(
                            'Rs ${widget.products[index].routePrice.toString()}',
                            style: TextStyle(
                                color: ColorUtils.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ));
  }
}
