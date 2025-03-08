import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palkkaran/core/utils/colors.dart';

class CustomOutlinedBtn extends StatelessWidget {
  final Color color;
  final String btnText;
  final double? width;
  final double height;
  final bool? isLoading;
  final double? borderRadius;
  final double? fontsize;
  final String? fontfamily;
  final FontWeight? fontweight;
  final Color? btnTextColor;
  final IconData? icon;
  final Color? textColor;
   final double padH;
  final double padV;
  final EdgeInsets? margin;
  final Color? bgColor;
  final String? svgIcon;
  final VoidCallback onTap;
  final EdgeInsets? padding;

  const CustomOutlinedBtn({
    super.key,
    required this.color,
    this.bgColor,
    this.margin,
    this.isLoading,
    required this.btnText,
    this.width,
    required this.height,
    required this.onTap,
    this.padding,
    this.borderRadius,
    this.btnTextColor,
    this.fontsize,
    this.fontfamily,
    this.fontweight,
    this.icon,
    this.textColor,
    this.svgIcon, required this.padH, required this.padV,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 14),
      ),
      child: Material(
        color: bgColor ?? Colors.transparent, // Background color of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          side: BorderSide(color: color, width: 1),
        ),
        child: InkWell(
          onTap: isLoading == true ? null : onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
        
          child: Container(
                      padding: EdgeInsets.symmetric(horizontal: padH,vertical: padV),

            child: Center(
              child: isLoading == true
                  ? CircularProgressIndicator(
                      color: ColorUtils.kPrimary,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          btnText,
                          style: TextStyle(
                            color: textColor??ColorUtils.kPrimary,
                            fontSize: fontsize ?? 16.sp,
                            fontWeight: fontweight ?? FontWeight.w500,
                          ),
                        ),
                        if (icon != null) ...[
                          SizedBox(width: 10.w),
                          Icon(
                            icon,
                            color: btnTextColor ?? ColorUtils.kPrimary,
                            size: 24.h, // Adjust size as needed
                          ),
                        ],
                        if (svgIcon != null) ...[
                          SizedBox(width: 10.w),
                          SvgPicture.asset(
                            svgIcon!,
                            color: btnTextColor ?? ColorUtils.kPrimary,
                          ),
                        ],
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
