import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_outlined_btn.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderWidget extends StatelessWidget {
  final String orderId;
  final String type;
  final String tag;
  final String prodImg;
  final Function? onDone;
  final Function? onCancel;

  const OrderWidget({
    super.key, required this.orderId, required this.type, required this.tag, required this.prodImg, this.onDone, this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
               color:  ColorUtils.kPrimaryBg,
                
                image: DecorationImage(image: CachedNetworkImageProvider(prodImg) ),
                borderRadius: BorderRadius.circular(22.sp),),
          ),
          SizedBox(width: 12.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tag,style: TextStyle(color: ColorUtils.kPrimary,fontSize: 14.sp),),
              Text(type,style: TextStyle(color: ColorUtils.black,fontSize: 14.sp,fontWeight: FontWeight.bold)),
              Text(orderId,style: TextStyle(color: ColorUtils.grey,fontSize: 14.sp)),
                 SizedBox(height: 10.h,),
                 Row(
                   children: [
                     CustomBtn(borderRadius: 12.sp,color: ColorUtils.kPrimary,  padH: 10.w, padV: 5.h,btnText: 'Done',onTap: (){},height: 40.h,width: 70.w,),
                     SizedBox(width: 10.w,),
                               CustomOutlinedBtn(borderRadius: 12.sp,color: ColorUtils.kPrimary,  padH: 10.w, padV: 5.h,btnText: 'Cancel',onTap: (){},height: 40.h,width: 90.w,),
                   ],
                 )
            ],
          ),
       


        ],
      ),
    );
  }
}
