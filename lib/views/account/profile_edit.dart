import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/common_widgets/custom_txt_field.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/constants.dart';
import 'package:palkkaran/core/view_models/add_image_view_model.dart';
import 'package:palkkaran/core/view_models/profile_view_model.dart';

class EditProfile extends ConsumerWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(profileProvider);

    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController mobileController = TextEditingController();

    nameController.text = model.profileModel!.name;
    emailController.text = model.profileModel!.email ?? '';
    mobileController.text = model.profileModel!.phone.toString();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(ColorUtils.lightBlue)),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
            )),
        title: Text(
          'Personal info',
          style: TextStyle(
              color: ColorUtils.black,
              fontWeight: FontWeight.normal,
              fontSize: 15.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
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
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text('Take Photo'),
                          onTap: () {
                            Navigator.pop(context);
                            ref
                                .read(addImageProvider.notifier)
                                .pickImage(ImageSource.camera, context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text('Choose from Gallery'),
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
              child: Consumer(builder: (context, ref, child) {
                final img = ref.watch(addImageProvider);
                return CircleAvatar(
                  radius: 50.sp,
                  backgroundImage: img != null
                      ? FileImage(File(img))
                      : CachedNetworkImageProvider(
                          '$imgBaseUrl/${model.profileModel?.image}'),
                );
              }),
            ),
            SizedBox(
              width: 30.h,
            ),
            Text(
              'FULL NAME',
              style: TextStyle(
                  color: ColorUtils.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp),
            ),
            CustomTxtField(
              label: 'name',
              controller: nameController,
              backgroundColor: ColorUtils.lightBlue,
              borderRadius: 10.sp,
              borderColor: Colors.transparent,
            ),
            SizedBox(
              height: 24.h,
            ),
            Text(
              'Email',
              style: TextStyle(
                  color: ColorUtils.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp),
            ),
            CustomTxtField(
              label: 'example@gmail.com',
              controller: emailController,
              backgroundColor: ColorUtils.lightBlue,
              borderRadius: 10.sp,
              borderColor: Colors.transparent,
            ),
            Text(
              'Mobile',
              style: TextStyle(
                  color: ColorUtils.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp),
            ),
            CustomTxtField(
              label: '+91 xxxxxxxx',
              controller: mobileController,
              backgroundColor: ColorUtils.lightBlue,
              borderRadius: 10.sp,
              borderColor: Colors.transparent,
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomBtn(
                color: ColorUtils.kPrimary,
                btnText: 'update',
                padH: 12.w,
                padV: 12.h,
                height: 50,
                onTap: () {
                  final image = ref.watch(addImageProvider);
                  ref.read(profileProvider.notifier).updateProfile({
                    'name': nameController.text,
                    'phone': int.parse(mobileController.text),
                    'email': emailController.text,
                    'image': image ?? model.profileModel?.image,
                    'role': 'Delivery Boy',
                  }).then((response) {
                    if (response!.success == true) {
                      ref.read(profileProvider.notifier).getProfile();
                      Navigator.pop(context);
                    }
                    customToast(response.message);
                  });
                })
          ],
        ),
      ),
    );
  }
}
