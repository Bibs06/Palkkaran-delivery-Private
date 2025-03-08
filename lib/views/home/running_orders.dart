  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/utils/colors.dart';

void showRunningOrders(BuildContext context,List<Widget> orders) {
    showModalBottomSheet(
      showDragHandle: true,
      constraints: BoxConstraints(
        maxHeight:  600.h,
      ),
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: ColorUtils.kPrimaryBg,
      context: context,
      builder: (context) {
        return ListView(
          children: orders
        );
      },
    );
  }
