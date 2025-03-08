import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/utils/colors.dart';

class OtpField extends StatelessWidget {
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  const OtpField({super.key, this.onChanged,this.focusNode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.w,
      height: 48.h,
      child: TextField(
        focusNode: focusNode ,
       
        textAlign: TextAlign.center,
         style: TextStyle(color: ColorUtils.black,fontWeight: FontWeight.bold,fontSize: 18.sp),
        cursorColor: ColorUtils.kPrimary,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: ColorUtils.lightBlue,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.sp),
            borderSide: BorderSide.none
          )
        
        ),
        keyboardType: TextInputType.number,
        
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
