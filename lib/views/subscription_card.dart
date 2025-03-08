import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/utils/colors.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function()? onTap;
  final Color borderColor;
 

  final Color backgroundColor;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.subTitle,
    this.onTap,
    required this.borderColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(22.sp),
            border: Border.all(color: borderColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp),
            ),
            Text(
              subTitle,
              style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp),
            ),
            SizedBox(height: 45.h,),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                      color: ColorUtils.black,
                      borderRadius: BorderRadius.circular(22.sp)),
                  child: Row(
                    children: [
                      Text(
                        'Select',
                        style: TextStyle(
                            color: ColorUtils.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15.sp),
                      ),
                      SizedBox(width: 5.w,),
                      Icon(
                        Icons.arrow_forward,
                        size: 17.sp,
                        color: ColorUtils.white,
                      ),
                     
                    ],
                
                  ),
                ),
              
               
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
