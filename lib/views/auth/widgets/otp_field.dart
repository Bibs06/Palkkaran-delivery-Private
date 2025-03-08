import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/utils/colors.dart';

class OtpField extends StatelessWidget {
  final Function(String)? onChanged;
  const OtpField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64.w,
      height: 68.h,
      child: TextField(
        textAlign: TextAlign.center,
         style: TextStyle(color: ColorUtils.black,fontWeight: FontWeight.bold,fontSize: 22.sp),
        cursorColor: ColorUtils.kPrimary,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: ColorUtils.lightBlue,
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
