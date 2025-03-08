import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_snackbar.dart';
import 'package:palkkaran/core/common_widgets/custom_txt_field.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/views/auth/otp_view.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    return Scaffold(
      backgroundColor: ColorUtils.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: ColorUtils.black,
              child: Column(
                children: [
                  SizedBox(
                    height: 140.h,
                  ),
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                        color: ColorUtils.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Please sign in to your existing account',
                    style: TextStyle(
                        color: ColorUtils.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 300,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                color: ColorUtils.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.sp),
                  topRight: Radius.circular(22.sp),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Phone',
                        style: TextStyle(
                            color: ColorUtils.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTxtField(
                        label: 'Phone',
                        textInputType: TextInputType.number,
                        controller: phoneController,
                        backgroundColor: ColorUtils.lightBlue,
                        borderRadius: 10.sp,
                        borderColor: Colors.transparent,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomBtn(
                          color: ColorUtils.kPrimary,
                          btnText: 'Request Otp',
                          padH: 10.w,
                          padV: 10.h,
                          height: 50.h,
                          borderRadius: 12.sp,
                          onTap: () {
                            if (phoneController.text.isEmpty) {
                              customSnackBar(
                                  context: context,
                                  title: 'Phone number is empty');
                            } else if (phoneController.text.length != 10) {
                              customSnackBar(
                                  context: context,
                                  title: 'Check your phone number');
                            } else {
                              Go.to(context, OtpView());
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            left: 16.w,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.arrow_back_ios,
                color: ColorUtils.grey,
                size: 22.sp,
                
              ),
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(ColorUtils.kPrimaryBg),
                  shape: WidgetStatePropertyAll(CircleBorder())),
            ),
          )
        ],
      ),
    );
  }
}
