import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_snackbar.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/common_widgets/custom_txt_field.dart';
import 'package:palkkaran/core/enums/view_state.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/view_models/auth_view_model.dart';

import 'package:palkkaran/views/auth/forgot_pass_view.dart';
import 'package:palkkaran/views/auth/sign_up_view.dart';
import 'package:palkkaran/views/bottom_nav/bottom_nav.dart';

final showPassProvider = StateProvider<bool>((ref) => true);

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


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
                    'Login',
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
                        'Email',
                        style: TextStyle(
                            color: ColorUtils.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTxtField(
                        label: 'Email',
                        textInputType: TextInputType.emailAddress,
                        controller: phoneController,
                        backgroundColor: ColorUtils.lightBlue,
                        borderRadius: 10.sp,
                        borderColor: Colors.transparent,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Password',
                        style: TextStyle(
                            color: ColorUtils.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Consumer(builder: (context, ref, child) {
                        final showPass = ref.watch(showPassProvider);

                        return CustomTxtField(
                          label: 'Password',
                          controller: passwordController,
                          backgroundColor: ColorUtils.lightBlue,
                          isObscure: showPass,
                          borderRadius: 10.sp,
                          borderColor: Colors.transparent,
                          suffixIcon: IconButton(
                            onPressed: () {
                              ref.read(showPassProvider.notifier).state =
                                  !ref.read(showPassProvider.notifier).state;
                            },
                            icon: Icon(
                              showPass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: ColorUtils.grey,
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 10.h,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Go.to(
                              context,
                              ForgotPasswordView(),
                            );
                          },
                          child: Text(
                            'Forgort Password',
                            style: TextStyle(
                                color: ColorUtils.kPrimary,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Consumer(builder: (context, ref3, child) {
                       final auth =  ref3.watch(authProvider);
                        return CustomBtn(
                          color: ColorUtils.kPrimary,
                          btnText: 'Login',
                          padH: 10.w,
                          padV: 10.h,
                          height: 50.h,
                          isLoading: auth == ViewState.loading,
                          borderRadius: 12.sp,
                          onTap: () {
                            if (phoneController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              customSnackBar(
                                  context: context,
                                  title: 'Email or password is empty');
                            }  else {
                              ref3.read(authProvider.notifier).login({
                                'email': phoneController.text,
                                'password': passwordController.text
                              }).then((response) async{
                                if (response!.success == true) {
                               
                                  ref.read(showPassProvider.notifier).state =
                                      true;
                                  Go.toWithAnimationAndPopUntil(
                                      context, BottomNav(), 1, 0);
                                
                                } 
                                  customToast(response.message);
                              });
                            }
                          },
                        );
                      }),
                      SizedBox(
                        height: 30.h,
                      ),
                      // Center(
                      //   child: RichText(
                      //     textAlign: TextAlign.center,
                      //     text: TextSpan(
                      //       style: const TextStyle(
                      //         fontSize: 16,
                      //         color: ColorUtils
                      //             .black, // Use a suitable color for UIColor.shade
                      //         fontWeight: FontWeight.w400,
                      //       ),
                      //       children: [
                      //         const TextSpan(
                      //           text: 'Don’t have an account? ',
                      //         ),
                      //         TextSpan(
                      //           text: 'Sign up',
                      //           style: const TextStyle(
                      //             fontWeight: FontWeight.w600,
                      //             fontSize: 16,
                      //             color: ColorUtils
                      //                 .kPrimary, // Use a suitable color for UIColor.secondaryColor
                      //           ),
                      //           recognizer: TapGestureRecognizer()
                      //             ..onTap = () async {
                      //               Navigator.pushReplacement(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       const SignUpView(),
                      //                 ),
                      //               );
                      //             },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
