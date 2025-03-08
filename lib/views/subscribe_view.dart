import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/view_models/order_view_model.dart';
import 'package:palkkaran/views/custom_calender.dart';
import 'package:palkkaran/views/subscription_card.dart';

class SubscribeView extends ConsumerStatefulWidget {
  final bool? showAddress;
  const SubscribeView({
    super.key,
    this.showAddress,
  });

  @override
  ConsumerState<SubscribeView> createState() => _SubscribeViewState();
}

class _SubscribeViewState extends ConsumerState<SubscribeView> {
  int selectedIndex = 0;

  List titles = [
    'Daily Plan',
    'Alternate Days',
    'Weekly Plan',
    'Custom Plan',
    'Monthly Plan'
  ];

  List subTitles = [
    'on next page you can select Dates',
    'on next page you can select Dates',
    'on next page you can select Dates ',
    'on next page you can select Dates ',
    'on next page you can select Dates '
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(ColorUtils.lightBlue)),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 18.sp,
              )),
          centerTitle: true,
          title: Text(
            'Available Plans',
            style: TextStyle(
                color: ColorUtils.black,
                fontWeight: FontWeight.bold,
                fontSize: 17.sp),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: CustomBtn(
              color: ColorUtils.kPrimary,
              btnText: 'Subscribe',
              padH: 5.w,
              padV: 5.h,
              height: 62.h,
              onTap: () {
                Go.to(
                    context,
                    CustomCalendar(
                        selectionType: selectedIndex == 0
                            ? 'daily'
                            : selectedIndex == 1
                                ? 'alternative'
                                : selectedIndex == 2
                                    ? 'weekly'
                                    : selectedIndex == 3
                                        ? 'custom'
                                        : 'monthly'));
              }),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: ListView.builder(
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return  SubscriptionCard(
                  title: titles[index],
                  subTitle: subTitles[index],
                  borderColor: selectedIndex == index
                      ? ColorUtils.kPrimary
                      : ColorUtils.grey,
                  backgroundColor: selectedIndex == index
                      ? ColorUtils.lightBlue
                      : ColorUtils.secondaryGrey,
                  onTap: () {
                    // ref.read(orderProvider.notifier).selectPlan({
                    //   'planType': index == 0
                    //       ? 'daily'
                    //       : index == 1
                    //           ? 'alternative'
                    //           : index == 2
                    //               ? 'weekly'
                    //               : index == 3
                    //                   ? 'custom'
                    //                   :index == 3?'custom': 'monthly',
                    // });
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                );
              }),
        ));
  }
}
