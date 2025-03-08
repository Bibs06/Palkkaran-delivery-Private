import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/local_storage.dart';
import 'package:palkkaran/core/utils/svg_assets.dart';
import 'package:palkkaran/views/account/change_password.dart';
import 'package:palkkaran/views/account/widgets/prof_section.dart';
import 'package:palkkaran/views/account/widgets/profile_card.dart';

final nameProvider = StateProvider<String?>((ref) => 'zsdf');

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  void initState() {
    
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    ref.read(nameProvider.notifier).state =
        await LocalStorage.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.white,
      appBar: AppBar(
        leading:  IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20.sp,
                  )),
        title: Text(
          'Settings',
          style: TextStyle(color: ColorUtils.black, fontSize: 17.sp),
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
                    icon: SvgAssets.pass,
                    title: 'Change password',
                    onTap: () {
                      Go.to(context, ChangePasswordView());
                    },
                  ),
                  
                 
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
