import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/common_widgets/custom_btn.dart';
import 'package:palkkaran/core/common_widgets/custom_toast.dart';
import 'package:palkkaran/core/common_widgets/custom_txt_field.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/view_models/order_view_model.dart';

class UpdateBottleView extends ConsumerWidget {
  final String userId;
  const UpdateBottleView({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Bottle',
            style: TextStyle(
                color: ColorUtils.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            CustomTxtField(
              label: 'No',
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              fontSize: 55.sp,
              hintColor: ColorUtils.grey,
              controller: amountController,
              borderRadius: 12.sp,
              borderColor: ColorUtils.kPrimary,
              backgroundColor: Colors.transparent,
              textInputType: TextInputType.number,
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomBtn(
                color: ColorUtils.kPrimary,
                btnText: 'Update',
                padH: 5.w,
                padV: 10.h,
                height: 60.h,
                onTap: () {
                  ref.read(orderProvider.notifier).returnBottle(userId, {
                    "returnedBottles": amountController.text
                  }).then((response) {
                    Navigator.pop(context);
                    customToast(response!.message);
                  });
                })
          ],
        ),
      ),
    );
  }
}
