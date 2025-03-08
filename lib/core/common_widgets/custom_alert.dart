import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_outlined_btn.dart';
import 'package:palkkaran/core/utils/colors.dart';

void showAnimatedDialog(BuildContext context, AnimationController controller,Animation<double> animation,String title,String body,String btnText1,String btnText2,{Function()? onBtnTap1,Function()? onBtnTap2}) {
    controller.forward(); 

    showDialog(
    
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return ScaleTransition(
          scale: animation,
          child: AlertDialog(
            backgroundColor: ColorUtils.white,
            
           content:  SizedBox(
            height: 170.h,
          
             child: Column(
             
               children: [
                Text(title,style: TextStyle(color: ColorUtils.kPrimary,fontSize: 19.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                SizedBox(height: 10.h,),
                Text(body,style: TextStyle(color: ColorUtils.grey,fontSize: 16.sp,fontWeight: FontWeight.w300)),
                    SizedBox(height: 20.h,),
                 Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(child: CustomBtn(color: ColorUtils.kPrimary, btnText: btnText1, padH: 10.w, padV: 10.h, height: 40.h, onTap: onBtnTap1!)),
                        SizedBox(width: 30.w,),
                         Flexible(child: CustomOutlinedBtn(color: ColorUtils.kPrimary, btnText: btnText2, padH: 10.w, padV: 10.h, height: 40.h, onTap: onBtnTap2!)),
                      ],
                    ),
                
               ],
             ),
           ),
          ),
        );
      },
    ).then((_) {
      controller.reverse(); // Ensure the animation resets after dialog closes
    });
  }