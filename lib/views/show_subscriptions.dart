import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/enums/view_state.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/view_models/order_view_model.dart';
import 'package:palkkaran/views/subscribe_view.dart';

final orderIdProvider = StateProvider((ref) => '');
final changePlanProvider = StateProvider((ref) => false);

class ViewPlan extends ConsumerStatefulWidget {
  final String userId;
  const ViewPlan({super.key, required this.userId});

  @override
  ConsumerState<ViewPlan> createState() => _ViewPlanState();
}

class _ViewPlanState extends ConsumerState<ViewPlan> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).getOrdersWithSub(widget.userId);
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
        title: Text(
          'Customer Plan',
          style: TextStyle(
              color: ColorUtils.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Consumer(builder: (context, ref2, child) {
          final model = ref2.watch(orderProvider);

          if (model.orderWithSubState == ViewState.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorUtils.kPrimary,
              ),
            );
          } else if (model.ordersModelWithSub == null ||
              model.ordersModelWithSub!.data!.isEmpty) {
            return Container(
                height: 150.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                    color: ColorUtils.lightBlue,
                    borderRadius: BorderRadius.circular(22.sp),
                    border: Border.all(color: ColorUtils.kPrimary)),
                child: Center(
                    child: Text(
                  'You have no subscription',
                  style: TextStyle(
                      color: ColorUtils.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                )));
          } else {
            return ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: model.ordersModelWithSub?.data?.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    margin: EdgeInsets.only(bottom: 8.h),
                    decoration: BoxDecoration(
                        color: ColorUtils.lightBlue,
                        borderRadius: BorderRadius.circular(22.sp),
                        border: Border.all(color: ColorUtils.kPrimary)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.ordersModelWithSub!.data![index]
                              .selectedPlanDetails.planType,
                          style: TextStyle(
                              color: ColorUtils.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.sp),
                        ),
                        SizedBox(
                          height: 45.h,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap:model.ordersModelWithSub!.data![index].planIsActive? () {
                                ref
                                    .read(orderProvider.notifier)
                                    .stopPlan(model
                                        .ordersModelWithSub!.data![index].id)
                                    .then((response) {
                                  customToast(response!.message);
                                });
                              }:null,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                    color: ColorUtils.black,
                                    borderRadius: BorderRadius.circular(22.sp)),
                                child: Row(
                                  children: [
                                    Text(
                                    model.ordersModelWithSub!.data![index].planIsActive?  'Stop plan':'Plan stopped',
                                      style: TextStyle(
                                          color: ColorUtils.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.sp),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 17.sp,
                                      color: ColorUtils.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                           model.ordersModelWithSub!.data![index].planIsActive? GestureDetector(
                              onTap: () {
                                ref.read(orderIdProvider.notifier).state =
                                    model.ordersModelWithSub!.data![index].id;
                                ref.read(changePlanProvider.notifier).state =
                                    true;
                                Go.to(context, SubscribeView());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                    color: ColorUtils.kPrimary,
                                    borderRadius: BorderRadius.circular(22.sp)),
                                child: Row(
                                  children: [
                                    Text(
                                      'Change Plan',
                                      style: TextStyle(
                                          color: ColorUtils.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15.sp),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 17.sp,
                                      color: ColorUtils.white,
                                    ),
                                  ],
                                ),
                              ),
                            ):SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          }
        }),
      ),
    );
  }
}
