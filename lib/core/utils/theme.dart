import 'package:flutter/material.dart';
import 'package:palkkaran/core/utils/colors.dart';

class CustomTheme {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: ColorUtils.kPrimaryBg,
      appBarTheme: AppBarTheme(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: ColorUtils.white
      ),
       tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 3,
                  color: ColorUtils.kPrimary,
                ),
                insets: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              dividerHeight: 3,
              splashFactory: NoSplash.splashFactory,
              
              dividerColor: Colors.transparent,
  
              indicatorSize: TabBarIndicatorSize.tab,
      ),
      
    );
  }
}
