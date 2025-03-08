import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/image_assets.dart';
import 'package:palkkaran/core/utils/local_storage.dart';
import 'package:palkkaran/views/auth/login_view.dart';
import 'package:palkkaran/views/bottom_nav/bottom_nav.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () {
        checkState();
      },
    );
  }

  void checkState() async {
    final accessToken = await LocalStorage.getString('accessToken');
 if(accessToken!=null){
       Go.toWithAnimationAndPopUntil(context, BottomNav(), 1, 0);

    }
    else {
      Go.toWithAnimationAndPopUntil(context, LoginView(), 1, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kPrimary,
      body:Center(child: Image.asset(ImageAssets.brandLogo,width: 400.w,height: 400.h,)),
    );
  }
}
