import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/utils/colors.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String img;
  final String subTitle;
  const NotificationCard({super.key, required this.title, required this.img, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: ColorUtils.kPrimaryBg,
          backgroundImage: CachedNetworkImageProvider(img),
          radius: 30.sp,
        ),
        SizedBox(width: 10.w,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                style: TextStyle(
                    color: ColorUtils.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp),
              ),
              SizedBox(height: 10.h,),
              Text(
                subTitle,
                style: TextStyle(
                    color: ColorUtils.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 15.sp),
              ),
              SizedBox(height: 10.h,),
              Divider(color: ColorUtils.grey,)
            ],
          ),
        ),
      ],
    );
  }
}
