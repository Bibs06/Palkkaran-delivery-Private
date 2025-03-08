import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/utils/colors.dart';

class CustomTxtField extends StatelessWidget {
  final String label;
  final bool? isObscure;
  final double? borderRadius;
  final Color? backgroundColor;
  final TextInputType? textInputType;
  final Widget? suffixIcon;
  final TextAlign? textAlign;
  final Color? borderColor;
  final double? fontSize;
  final Color? hintColor;
  final FontWeight? fontWeight;
  final TextEditingController controller;
  const CustomTxtField(
      {super.key,
      required this.label,
      this.isObscure,
      this.suffixIcon,
      this.textAlign,
      this.hintColor,
      this.fontSize,
      this.fontWeight,
      required this.controller,
      this.borderRadius,
      this.backgroundColor,
      this.borderColor,
      this.textInputType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: ColorUtils.black,
      controller: controller,
      textAlign: textAlign ?? TextAlign.left,
      style: TextStyle(
          color: ColorUtils.black, fontSize: fontSize, fontWeight: fontWeight),
      obscureText: isObscure ?? false,
      keyboardType: textInputType ?? TextInputType.text,
      decoration: InputDecoration(
          fillColor: backgroundColor,
          filled: true,
          hintText: label,
          hintStyle: TextStyle(color: hintColor ?? ColorUtils.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? ColorUtils.black,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 22.sp),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? ColorUtils.black,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 22.sp),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor ?? ColorUtils.black,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 22.sp),
          ),
          suffixIcon: suffixIcon),
    );
  }
}
