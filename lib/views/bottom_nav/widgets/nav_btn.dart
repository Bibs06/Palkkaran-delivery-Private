import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palkkaran/core/utils/colors.dart';

class NavBtn extends StatelessWidget {
  final String icon;
  final Color? iconColor;
  final String label;
  final Color labelColor;
  final Function()? onTap;
  const NavBtn(
      {super.key,
      required this.icon,
      this.iconColor,
      required this.label,
      this.onTap, required this.labelColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            icon,
            color: iconColor,
          ),
          Text(
            label,
            style: TextStyle(color: labelColor,fontSize: 18.sp),
          ),
        ],
      ),
    );
  }
}
