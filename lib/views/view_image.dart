import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/view_models/add_image_view_model.dart';
import 'package:palkkaran/core/view_models/order_view_model.dart';

class ViewImage extends ConsumerWidget {
  final String img;
  final String csId;
  const ViewImage({super.key, required this.img,required this.csId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final fileImg = ref.watch(addImageProvider);
        return Image.file(File(fileImg ?? img));
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Flexible(
                child: CustomBtn(
                  color: ColorUtils.kPrimary,
                  btnText: 'Upload',
                  padH: 5.w,
                  padV: 5.h,
                  height: 50.h,
                  onTap: () {
                    ref
                        .read(orderProvider.notifier)
                        .addCustomHome(
                          img,csId
                        )
                        .then((response) {
                      customToast(response!.message);
                      if (response!.success) {
                        ref.read(orderProvider.notifier).getOrders();
                        Navigator.pop(context);
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Flexible(
                child: CustomBtn(
                  color: ColorUtils.kPrimary,
                  btnText: 'Retake',
                  padH: 5.w,
                  padV: 5.h,
                  height: 50.h,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
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
                                      .pickImage(ImageSource.camera, context);
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
