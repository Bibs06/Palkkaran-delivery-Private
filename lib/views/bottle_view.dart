import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/enums/view_state.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/view_models/order_view_model.dart';

class BottleView extends ConsumerStatefulWidget {
  final String userId;
  const BottleView({super.key, required this.userId});

  @override
  ConsumerState<BottleView> createState() => _BottleViewState();
}

class _BottleViewState extends ConsumerState<BottleView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).getBottleInfo(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottle history',
            style: TextStyle(
                color: ColorUtils.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold)),
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
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final model = ref.watch(orderProvider);
          if (model.bottleState == ViewState.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorUtils.kPrimary,
              ),
            );
          } else if (model.bottleInfoModel == null ||
              model.bottleInfoModel!.data!.isEmpty) {
            return Center(
              child: Text(
                'No bottles found for this customer',
                style: TextStyle(
                    color: ColorUtils.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return ListView.builder(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16.w, vertical: 16.h),
                itemCount: model.bottleInfoModel?.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 20.w, vertical: 18.h),
                    decoration: BoxDecoration(
                        color: ColorUtils.white,
                        borderRadius: BorderRadius.circular(22.sp),
                        boxShadow: [
                          BoxShadow(
                            color: ColorUtils.grey,
                          ),
                        ]),
                    child: Column(
                      children: [
                        detailRow(
                            title: 'Plan',
                            value: model
                                .bottleInfoModel!.data![index].plan.planType),
                        detailRow(
                            title: 'Total bottles',
                            value: model.bottleInfoModel!.data![index].bottles
                                .toString()),
                        detailRow(
                            title: 'Pending bottles',
                            value: model
                                .bottleInfoModel!.data![index].pendingBottles
                                .toString()),
                        detailRow(
                            title: 'Returned bottles',
                            value: model
                                .bottleInfoModel!.data![index].returnedBottles
                                .toString())
                      ],
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  Row detailRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorUtils.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: ColorUtils.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
