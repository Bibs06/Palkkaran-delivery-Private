import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/svg_assets.dart';
import 'package:palkkaran/views/bottom_nav/widgets/nav_btn.dart';
import 'package:palkkaran/views/customers.dart';
import 'package:palkkaran/views/home/home_view.dart';
import 'package:palkkaran/views/notification/notification_view.dart';
import 'package:palkkaran/views/account/accounts_view.dart';
import 'package:palkkaran/views/order_view.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List screens = [HomeView(), OrdersView(),CustomersView(), AccountsView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(
          milliseconds: 400,
        ),
        child: screens[selectedIndex],
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: ColorUtils.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22.sp),
            topRight: Radius.circular(22.sp),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavBtn(
              icon: SvgAssets.homeIcon,
              iconColor: selectedIndex == 0 ? ColorUtils.kPrimary : null,
              labelColor:
                  selectedIndex == 0 ? ColorUtils.kPrimary : ColorUtils.grey,
              label: 'Home',
              onTap: () {
                onItemTapped(0);
              },
            ),
            NavBtn(
              icon: SvgAssets.orderIcon,
              iconColor:
                  selectedIndex == 1 ? ColorUtils.kPrimary : ColorUtils.grey,
              label: 'Orders',
              labelColor:
                  selectedIndex == 1 ? ColorUtils.kPrimary : ColorUtils.grey,
              onTap: () {
                onItemTapped(1);
              },
            ),
            NavBtn(
              icon: SvgAssets.usersIcon,
              iconColor: selectedIndex == 2 ? ColorUtils.kPrimary : null,
              labelColor:
                  selectedIndex == 2 ? ColorUtils.kPrimary : ColorUtils.grey,
              label: 'Users',
              onTap: () {
                onItemTapped(2);
              },
            ),
            NavBtn(
              icon: SvgAssets.profileIcon,
              iconColor: selectedIndex == 3 ? ColorUtils.kPrimary : null,
              labelColor:
                  selectedIndex == 3 ? ColorUtils.kPrimary : ColorUtils.grey,
              label: 'Profile',
              onTap: () {
                onItemTapped(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
