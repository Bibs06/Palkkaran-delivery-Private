import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_snackbar.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/common_widgets/custom_txt_field.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/view_models/profile_view_model.dart';

class ChangePasswordView extends ConsumerWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController oldPassController = TextEditingController();
    final TextEditingController newPassController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change password',
          style: TextStyle(color: ColorUtils.black, fontSize: 17.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            CustomTxtField(
              label: 'Old password',
              controller: oldPassController,
              isObscure: true,
              backgroundColor: ColorUtils.lightBlue,
              borderColor: Colors.transparent,
              borderRadius: 10.sp,
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomTxtField(
              label: 'New password',
              isObscure: true,
              controller: newPassController,
              backgroundColor: ColorUtils.lightBlue,
              borderColor: Colors.transparent,
              borderRadius: 10.sp,
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomBtn(
                color: ColorUtils.kPrimary,
                btnText: 'Update',
                padH: 10.w,
                padV: 10.h,
                height: 50.h,
                onTap: () {
                  if (oldPassController.text.isEmpty ||
                      newPassController.text.isEmpty) {
                    customSnackBar(
                        context: context, title: 'Please fill both fields');
                  }  else {
                    ref.read(profileProvider.notifier).updatePassword({
                      'currentPassword': oldPassController.text,
                      'newPassword': newPassController.text
                    }).then((response) {
                      if (response!.success == true) {
                        Navigator.pop(context);
                      }
                      customToast(response.message);
                    });
                  }
                })
          ],
        ),
      ),
    );
  }
}
