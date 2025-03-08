import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/utils/constants.dart';
import 'package:palkkaran/core/utils/global_variables.dart';
import 'package:palkkaran/core/utils/theme.dart';
import 'package:palkkaran/views/splash_view.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(414, 896),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Palkkaran',
        theme: CustomTheme.theme,
        scaffoldMessengerKey: scaffoldMessengerKey,
        home: SplashView(),
      ),
    );
  }
}
