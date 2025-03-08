import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_snackbar.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/common_widgets/custom_txt_field.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/view_models/auth_view_model.dart';
import 'package:palkkaran/views/auth/login_view.dart';
import 'package:palkkaran/views/home/home_view.dart';



final showPass1Provider = StateProvider<bool>((ref) => true);

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  TextEditingController passController1 = TextEditingController();
  TextEditingController passController2 = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  bool showPassword = true;

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
                    'SignUp',
                    style: TextStyle(
                        color: ColorUtils.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Please signup to get started',
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
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22.sp),
                topRight: Radius.circular(22.sp),
              ),
              child: SingleChildScrollView(
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
                              'Name',
                              style: TextStyle(
                                  color: ColorUtils.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomTxtField(
                              label: 'Name',
                              controller: nameController,
                              backgroundColor: ColorUtils.lightBlue,
                              borderRadius: 10.sp,
                              borderColor: Colors.transparent,
                            ),
                             SizedBox(
                              height: 10.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title Text for Address
                                Text(
                                  'Address',
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 10.h),

                                // Address TextField
                                CustomTxtField(
                                  label: 'Address',
                                  controller: addressController,
                                  backgroundColor: ColorUtils.lightBlue,
                                  borderColor: Colors.transparent,
                                  borderRadius: 10.sp,
                                ),

                                SizedBox(height: 20.h),

                                Row(
                                  children: [
                                    // STREET Field
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 8.0.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Apartment No',
                                              style: TextStyle(
                                                color: ColorUtils.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            CustomTxtField(
                                              label: 'Optional',
                                              controller: apartmentController,
                                              backgroundColor:
                                                  ColorUtils.lightBlue,
                                              borderColor: Colors.transparent,
                                              borderRadius: 10.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // POST CODE Field
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8.0.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Post Code',
                                              style: TextStyle(
                                                color: ColorUtils.black,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            CustomTxtField(
                                              label: 'Post Code',
                                              textInputType:
                                                  TextInputType.number,
                                              controller: pinController,
                                              backgroundColor:
                                                  ColorUtils.lightBlue,
                                              borderColor: Colors.transparent,
                                              borderRadius: 10.sp,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  'Phone',
                                  style: TextStyle(
                                      color: ColorUtils.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 5.h,
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
                                  height: 5.h,
                                ),
                                Consumer(builder: (context, ref, child) {
                                  final showPass = ref.watch(showPassProvider);
                                  return CustomTxtField(
                                    label: 'Password',
                                    controller: passController1,
                                    backgroundColor: ColorUtils.lightBlue,
                                    isObscure: showPass,
                                    borderRadius: 10.sp,
                                    borderColor: Colors.transparent,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        ref
                                                .watch(showPassProvider.notifier)
                                                .state =
                                            !ref
                                                .watch(
                                                    showPassProvider.notifier)
                                                .state;
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
                                Text(
                                  'Confirm Password',
                                  style: TextStyle(
                                      color: ColorUtils.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                CustomTxtField(
                                  label: 'confirm Password',
                                  controller: passController2,
                                  backgroundColor: ColorUtils.lightBlue,
                                  isObscure: true,
                                  borderRadius: 10.sp,
                                  borderColor: Colors.transparent,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                CustomBtn(
                                  color: ColorUtils.kPrimary,
                                  btnText: 'SignUp',
                                  padH: 10.w,
                                  padV: 10.h,
                                  height: 50.h,
                                  borderRadius: 12.sp,
                                  onTap: () {
                                    if (phoneController.text.isEmpty ||
                                        passController1.text.isEmpty) {
                                      customSnackBar(
                                          context: context,
                                          title: 'Phone or password is empty');
                                    } else if (phoneController.text.length !=
                                        10) {
                                      customSnackBar(
                                          context: context,
                                          title:
                                              'Please check your phone number');
                                    } else if (passController1.text
                                            .toString()
                                            .toLowerCase() !=
                                        passController2.text
                                            .toString()
                                            .toLowerCase()) {
                                      customSnackBar(
                                          context: context,
                                          title: 'Passwords are not same');
                                    } else {
                                      ref.read(authProvider.notifier).signUp({
                                        'address': [
                                          {
                                            'postcode': pinController.text,
                                            'streetAddress':
                                                addressController.text,
                                            if (apartmentController
                                                .text.isNotEmpty)
                                              'apartment':
                                                  apartmentController.text,
                                          }
                                        ],
                                        'name': nameController.text,
                                        'password': passController1.text,
                                        'phone': phoneController.text,
                                      }).then((response) {
                                        if (response!.success == true) {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeView(),
                                              ),
                                              (route) => false);
                                        }
                                        customToast(response.message);
                                      });
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: ColorUtils
                                            .black, // Use a suitable color for UIColor.shade
                                        fontWeight: FontWeight.w400,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Already have an account? ',
                                        ),
                                        TextSpan(
                                          text: 'Login',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: ColorUtils
                                                .kPrimary, // Use a suitable color for UIColor.secondaryColor
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginView(),
                                                ),
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
