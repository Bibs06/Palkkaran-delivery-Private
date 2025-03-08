import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palkkaran/core/enums/view_state.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/constants.dart';
import 'package:palkkaran/core/utils/local_storage.dart';
import 'package:palkkaran/core/utils/svg_assets.dart';
import 'package:palkkaran/core/view_models/add_image_view_model.dart';
import 'package:palkkaran/core/view_models/profile_view_model.dart';
import 'package:palkkaran/views/account/profile_edit.dart';
import 'package:palkkaran/views/account/widgets/prof_section.dart';
import 'package:palkkaran/views/account/widgets/profile_card.dart';

final nameProvider = StateProvider<String?>((ref) => 'zsdf');

class PersonInfo extends ConsumerStatefulWidget {
  const PersonInfo({super.key});

  @override
  ConsumerState<PersonInfo> createState() => _PersonInfoState();
}

class _PersonInfoState extends ConsumerState<PersonInfo> {
  @override
  void initState() {
    super.initState();

    getUserInfo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getProfile();
    });
  }

  getUserInfo() async {
    ref.read(nameProvider.notifier).state =
        await LocalStorage.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Go.to(context, EditProfile());
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Text(
                'EDIT',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: ColorUtils.kPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp),
              ),
            ),
          ),
        ],
        leading: IconButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(ColorUtils.lightBlue)),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
            )),
        title: Text(
          'Personal info',
          style: TextStyle(
              color: ColorUtils.black,
              fontWeight: FontWeight.normal,
              fontSize: 15.sp),
        ),
      ),
      body: Consumer(builder: (context, ref, child) {
        final model = ref.watch(profileProvider);
        if (model.profileState == ViewState.loading) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorUtils.kPrimary,
            ),
          );
        } else if (model.profileModel == null) {
          return Center(
            child: Text('No data'),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              children: [
                Consumer(builder: (context, ref, child) {
                  final name = ref.watch(nameProvider);
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 50.sp,
                        backgroundImage: CachedNetworkImageProvider(
                            '$imgBaseUrl/${model.profileModel?.image}'),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        name.toString(),
                        style: TextStyle(
                            color: ColorUtils.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp),
                      ),
                    ],
                  );
                }),
                SizedBox(
                  height: 32.h,
                ),
                ProfSection(children: [
                  ProfileCard(
                    icon: SvgAssets.personIcon,
                    title: 'FULL NAME',
                    data: model.profileModel!.name,
                  ),
                  ProfileCard(
                    icon: SvgAssets.emailIcon,
                    title: 'EMAIL',
                    data: model.profileModel!.email ?? 'NA',
                  ),
                  ProfileCard(
                    icon: SvgAssets.phoneIcon,
                    title: 'MOBILE NUMBER',
                    data: model.profileModel!.phone.toString(),
                  ),
                ])
              ],
            ),
          );
        }
      }),
    );
  }
}
