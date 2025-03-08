import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palkkaran/core/utils/colors.dart';

class CustomBtn extends StatelessWidget {
  final Color color;
  final String btnText;
  final Color? btnTextColor;
  final double? width;
  final double height;
  final double? borderRadius;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final IconData? iconData;
  final Color? iconColor;
  final double? iconSize;
  final String? svgIcon;
  final bool? isLoading;
  final double padH;
  final double padV;
  final VoidCallback onTap;
  const CustomBtn(
      {super.key,
      required this.color,
      required this.btnText,
      this.borderColor,
      this.btnTextColor,
      this.width,
      required this.padH,
      required this.padV,
      required this.height,
      required this.onTap,
      this.borderRadius,
      this.fontSize,
      this.fontWeight,
      this.fontFamily,
      this.iconData,
      this.iconColor,
      this.iconSize,
      this.svgIcon,
      this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor ?? Colors.transparent),
        borderRadius: BorderRadius.circular(borderRadius ?? 14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          onTap: isLoading == true ? null : onTap,
          child: Container(
            width: width ?? double.infinity,
            height: height,
            padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
            decoration: BoxDecoration(),
            child: isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      color: ColorUtils.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          btnText,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          style: TextStyle(
                            color: btnTextColor?? ColorUtils.white,
                            fontSize: fontSize ?? 16.h,
                            fontWeight: fontWeight ?? FontWeight.w500,
                          ),
                        ),
                      ),
                      if (iconData != null || svgIcon != null)
                        SizedBox(width: 10.w),
                      if (iconData != null) ...[
                        // SizedBox(width: 10.w),
                        Icon(
                          iconData,
                          color: iconColor,
                          size: iconSize ?? 24.h, // Adjust size as needed
                        ),
                      ],
                      if (svgIcon != null) ...[
                        // SizedBox(width: 10.w),
                        SvgPicture.asset(
                          svgIcon!,
                          color: iconColor ?? ColorUtils.white,
                          // Adjust size as needed
                        ),
                      ]
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
