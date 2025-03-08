import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/common_widgets/custom_txt_field.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/view_models/auth_view_model.dart';
import 'package:palkkaran/core/view_models/otp_timer.dart';
import 'package:palkkaran/views/auth/login_view.dart';
import 'package:palkkaran/views/auth/widgets/otp_field.dart';
import 'package:palkkaran/views/bottom_nav/bottom_nav.dart';

final otpProvider = StateProvider((ref) => List.filled(6, '', growable: false));

class OtpView extends ConsumerStatefulWidget {
  final String email;
  const OtpView({super.key, required this.email});

  @override
  ConsumerState<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends ConsumerState<OtpView> {
  FocusNode focusNode = FocusNode();
  final TextEditingController pass1Controller = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
      ref.read(otpTimerProvider.notifier).startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    'We have sent a code to your email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorUtils.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500),
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
                      CustomTxtField(
                        label: 'New Password',
                        textInputType: TextInputType.emailAddress,
                        controller: pass1Controller,
                        backgroundColor: ColorUtils.lightBlue,
                        borderRadius: 10.sp,
                        borderColor: Colors.transparent,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTxtField(
                        label: 'Confirm Password',
                        textInputType: TextInputType.emailAddress,
                        controller: pass2Controller,
                        backgroundColor: ColorUtils.lightBlue,
                        borderRadius: 10.sp,
                        borderColor: Colors.transparent,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Code',
                        style: TextStyle(
                            color: ColorUtils.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return OtpField(
                                focusNode: index == 0 ? focusNode : null,
                                onChanged: (value) {
                                  final otpList = ref
                                      .read(otpProvider.notifier)
                                      .state
                                      .toList();
                                  otpList[index] = value;
                                  ref.read(otpProvider.notifier).state =
                                      otpList;

                                  if (value.isNotEmpty && index < 5) {
                                    FocusScope.of(context).nextFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                });
                          })),
                      SizedBox(
                        height: 20.h,
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final timer = ref.watch(otpTimerProvider);
                          if (timer != 0) {
                            return Text('Expires in ${timer.toString()}',
                                style: TextStyle(
                                    color: ColorUtils.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold));
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomBtn(
                          color: ColorUtils.kPrimary,
                          btnText: 'Verify',
                          padH: 10.w,
                          padV: 10.h,
                          height: 50.h,
                          borderRadius: 12.sp,
                          onTap: () {
                            if (pass1Controller.text.isEmpty ||
                                pass2Controller.text.isEmpty) {
                              customToast('Please fill the password');
                            } else if (pass1Controller.text !=
                                pass2Controller.text) {
                              customToast('Both passwords must be same');
                            } else {
                              ref.read(authProvider.notifier).resetPassword({
                                'email': widget.email,
                                'newPassword': pass1Controller.text,
                                'confirmPassword': pass2Controller.text,
                                'otp':
                                    ref.read(otpProvider.notifier).state.join()
                              }).then((response) async {
                                customToast(response!.message);
                                if (response!.success == true) {
                                  Go.toWithPopUntil(
                                    context,
                                    LoginView(),
                                  );
                                }
                              });
                            }
                          }),
                      SizedBox(
                        height: 20.h,
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorUtils.black,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Didn’t receive the code? ',
                            ),
                            TextSpan(
                              text: 'Resend OTP',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp,
                                  color: ColorUtils.black),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  ref.read(authProvider.notifier).requestOtp(
                                      {'email': widget.email}).then((response) {
                                    ref
                                        .read(otpTimerProvider.notifier)
                                        .startTimer();
                                    customToast(response!.message);
                                  });
                                },
                            ),
                          ],
                        ),
                      ),
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
