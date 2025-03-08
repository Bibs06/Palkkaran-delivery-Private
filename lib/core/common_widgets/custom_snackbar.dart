import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/global_variables.dart';



void customSnackBar(
    {required BuildContext context,
    int? duration,
    Color? bgColor,
    required String title,
    Color? titleColor}) {
  final snack = SnackBar(
    padding: const EdgeInsets.all(25),
    duration: Duration(seconds: duration ?? 2),
    backgroundColor: bgColor ?? Colors.black.withOpacity(0.8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    behavior: SnackBarBehavior.floating,
    content: Center(
      child: Text(
        title,
        style: TextStyle(
            color: titleColor ?? ColorUtils.white,
            fontSize: 12,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
   scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
  scaffoldMessengerKey.currentState!.showSnackBar(snack);
}

void customSnackBarSuccess(
    {required BuildContext context,
    int? duration,
    Color? bgColor,
    required String title,
    Color? titleColor}) {
  final snack = SnackBar(
    padding: EdgeInsets.symmetric(vertical: 12.h),
    duration: Duration(seconds: duration ?? 2),
    backgroundColor: bgColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    behavior: SnackBarBehavior.floating,
    content: Center(
      child: Text(
        title,
        style: TextStyle(
            color: titleColor ?? ColorUtils.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snack);
}
