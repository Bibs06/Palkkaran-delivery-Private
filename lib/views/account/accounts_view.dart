import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_alert.dart';
import 'package:palkkaran/core/common_widgets/custom_outlined_btn.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/local_storage.dart';
import 'package:palkkaran/core/utils/svg_assets.dart';
import 'package:palkkaran/views/account/profile_info.dart';
import 'package:palkkaran/views/account/setting_view.dart';
import 'package:palkkaran/views/account/widgets/prof_section.dart';
import 'package:palkkaran/views/account/widgets/profile_card.dart';
import 'package:palkkaran/views/auth/login_view.dart';

class AccountsView extends StatefulWidget {
  const AccountsView({super.key});

  @override
  State<AccountsView> createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView>  with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

   @override
     void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 300), // Adjust duration for animation
    );
    animation = CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.white,
       appBar: AppBar(
          title: Text(
            'My Account',
            style: TextStyle(
              color: ColorUtils.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              ProfSection(
                children: [
                  ProfileCard(
                    icon: SvgAssets.personIcon,
                    title: 'Person Info',
                    onTap: () {
                      Go.toWithAnimation(context, PersonInfo(), 1, 0);
                    },
                  ),
                  ProfileCard(
                    icon: SvgAssets.settingsIcon,
                    title: 'Settings',
                    onTap: () {
                       Go.toWithAnimation(context, SettingsView(), 1, 0);

                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
             
             
              ProfSection(
                children: [
                  ProfileCard(
                    icon: SvgAssets.logoutIcon,
                    title: 'Logout',
                    onTap: () {
                       LocalStorage.remove(['userId','userName','routeNo', 'accessToken'])
                          .then((_) {
                        showAnimatedDialog(
                            context,
                            animationController!,
                            animation!,
                            'Ready to Log Out?',
                            'Are you sure you want to log out? You can sign back in anytime',
                            'Logout',
                            'Cancel', onBtnTap1: () {

                          Go.toWithPopUntil(context, LoginView());
                        }, onBtnTap2: () {
                          Navigator.pop(context);
                        });
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
