import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/svg_assets.dart';

class ProfileCard extends StatelessWidget {
  final String icon;
  final Function()? onTap;
  final String title;
  final String? data;

  const ProfileCard({super.key, required this.icon, this.onTap, this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.secondaryGrey,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorUtils.white,
                  child: SvgPicture.asset(icon,width: 18.sp,height: 18.h,)),
                  SizedBox(width: 10.w,),
                Text(title,style: TextStyle(color: ColorUtils.black,fontWeight: FontWeight.normal,fontSize: 15.sp),),
                Spacer(),
                data==null?
                Icon(Icons.arrow_forward_ios,size: 18.sp,color: ColorUtils.grey,):SizedBox(
                  width: 150.w,
                  child: Text(data.toString(),style: TextStyle(color: ColorUtils.black,fontWeight: FontWeight.normal,fontSize: 15.sp),)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
