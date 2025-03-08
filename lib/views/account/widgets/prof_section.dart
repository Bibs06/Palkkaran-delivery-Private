import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/utils/colors.dart';

class ProfSection extends StatelessWidget {
  final List<Widget> children;
  const ProfSection({
    super.key, required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.secondaryGrey,
        borderRadius: BorderRadius.circular(22.sp),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.sp),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
