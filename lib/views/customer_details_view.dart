import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/common_widgets/custom_txt_field.dart';
import 'package:palkkaran/core/enums/view_state.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/constants.dart';
import 'package:palkkaran/core/utils/svg_assets.dart';
import 'package:palkkaran/core/view_models/order_view_model.dart';
import 'package:palkkaran/core/view_models/profile_view_model.dart';
import 'package:palkkaran/views/account/widgets/prof_section.dart';
import 'package:palkkaran/views/account/widgets/profile_card.dart';
import 'package:palkkaran/views/add_payment.dart';
import 'package:palkkaran/views/bottle_view.dart';
import 'package:palkkaran/views/invoice_view.dart';
import 'package:palkkaran/views/show_subscriptions.dart';
import 'package:palkkaran/views/update_bottle_view.dart';

class CustomerDetailsView extends ConsumerStatefulWidget {

  final String userId;
  final String csId;

  const CustomerDetailsView(
      {super.key,
    
      required this.userId,
      required this.csId});

  @override
  ConsumerState<CustomerDetailsView> createState() =>
      _CustomerDetailsViewState();
}

class _CustomerDetailsViewState extends ConsumerState<CustomerDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    
      ref.read(orderProvider.notifier).getCustomerProfile(widget.userId);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20.sp,
                )),
        title: Text('Customer details',
            style: TextStyle(
                color: ColorUtils.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold)),
      ),
      backgroundColor: ColorUtils.white,
      body: Consumer(builder: (context, ref, child) {
        final model = ref.watch(orderProvider);
        if (model.usersState == ViewState.loading) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorUtils.kPrimary,
            ),
          );
        } else if (model.customerProfileModel == null) {
          return Center(
            child: Text('No data found'),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 16.h),
            child: Column(
              children: [
                ProfSection(children: [
                  ProfileCard(
                    icon: SvgAssets.personIcon,
                    title: 'FULL NAME',
                    data:  model.customerProfileModel?.name,
                  ),
                  ProfileCard(
                    icon: SvgAssets.emailIcon,
                    title: 'EMAIL',
                    data:
                        model.customerProfileModel?.email ??
                            'NA',
                  ),
                  ProfileCard(
                      icon: SvgAssets.phoneIcon,
                      title: 'MOBILE NUMBER',
                      data:
                         model.customerProfileModel?.phone),
                          ProfileCard(
                      icon: SvgAssets.homeIcon2,
                      title: 'ADDRESS',
                      data:
                         model.customerProfileModel?.address[0].streetAddress.toString()),
                ]),
                SizedBox(
                  height: 20.h,
                ),
                ProfSection(children: [
                  ProfileCard(
                    icon: SvgAssets.historyIcon,
                    title: 'Invoice',
                    onTap: () {
                      Go.to(
                          context,
                          InvoiceView(
                              userId: model.customerProfileModel!.id,
                              csId: model.customerProfileModel!.customerId));
                    },
                  ),
                  ProfileCard(
                    icon: SvgAssets.bottleIcon,
                    title: 'Bottle History',
                    onTap: () {
                      Go.to(
                          context,
                          BottleView(
                              userId: model.customerProfileModel!.id));
                    },
                  ),
                ]),
                SizedBox(
                  height: 20.h,
                ),
                ProfSection(children: [
                  ProfileCard(
                    icon: SvgAssets.reviewIcon,
                    title: 'Change plan',
                    onTap: () {
                      Go.to(
                          context,
                          ViewPlan(
                              userId: model.customerProfileModel!.id));
                    },
                  ),
                  ProfileCard(
                    icon: SvgAssets.bottleIcon,
                    title: 'Update Bottle',
                    onTap: () {
                      Go.to(
                          context,
                          UpdateBottleView(
                              userId: model.customerProfileModel!.id));
                    },
                  ),
                  ProfileCard(
                    icon: SvgAssets.moneyIcon,
                    title: 'Add Pay',
                    onTap: () {
                      Go.to(
                          context,
                          AddPayment(
                              csId: model.customerProfileModel!.customerId));
                    },
                  ),
                ]),
              ],
            ),
          );
        }
      }),
    );
  }
}
