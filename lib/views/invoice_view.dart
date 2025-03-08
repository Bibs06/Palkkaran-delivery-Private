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
import 'package:palkkaran/core/view_models/order_view_model.dart';
import 'package:palkkaran/views/bottle_view.dart';

class InvoiceView extends ConsumerStatefulWidget {
  final String userId;
  final String csId;
  const InvoiceView(
      {super.key, required this.userId, required this.csId});

  @override
  ConsumerState<InvoiceView> createState() =>
      _InvoiceViewState();
}

class _InvoiceViewState extends ConsumerState<InvoiceView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).getInvoice(widget.userId);
    });
  }

  void showAmountDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Amount"),
          backgroundColor: ColorUtils.white,
          content: CustomTxtField(
            label: 'Enter amount',
            controller: amountController,
            borderRadius: 12.sp,
            borderColor: ColorUtils.kPrimary,
            backgroundColor: Colors.transparent,
            textInputType: TextInputType.number,
          ),
          actions: [
            CustomBtn(
                color: ColorUtils.kPrimary,
                btnText: 'Submit',
                padH: 3.w,
                padV: 4.h,
                width: 80.w,
                height: 40.h,
                onTap: () {
                  ref.read(orderProvider.notifier).addPayment({
                    "customerId": widget.csId,
                    "amount": amountController.text
                  }).then((response) {
                    ref.read(orderProvider.notifier).getInvoice(widget.userId);
                    Navigator.pop(context);
                    customToast(response!.message);
                  });
                }),
            CustomBtn(
                color: ColorUtils.white,
                borderColor: ColorUtils.kPrimary,
                btnTextColor: ColorUtils.kPrimary,
                btnText: 'Cancel',
                padH: 3.w,
                padV: 4.h,
                width: 80.w,
                height: 40.h,
                onTap: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
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
        title: Text('Invoice',
            style: TextStyle(
                color: ColorUtils.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold)),
      ),
     
      body: Consumer(
        builder: (context, ref, child) {
          final model = ref.watch(orderProvider);
          if (model.paymentHistoryState == ViewState.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorUtils.kPrimary,
              ),
            );
          } else if (model.invoiceModel == null ||
              model.invoiceModel!.data.isEmpty) {
            return Center(
              child: Text(
                'No payment history',
                style: TextStyle(
                    color: ColorUtils.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: model.invoiceModel?.data.length,
              itemBuilder: (context, index) {
                // model.invoiceModel!.data!.reversed;
                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                      color: ColorUtils.lightBlue,
                      borderRadius: BorderRadius.circular(12.sp),
                      border: Border.all(color: ColorUtils.kPrimary)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                          Text(
                            model.invoiceModel!.data[index].month,
                            style: TextStyle(
                                color: ColorUtils.black,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold),
                          ),
                             detailRow(title: 'Paid', value: model.invoiceModel!.data[index].paid.toString()),

                            detailRow(title: 'Balance', value: model.invoiceModel!.data[index].balance.toString()),

                            detailRow(title: 'Total Amount', value: model.invoiceModel!.data[index].totalAmount.toString())
                    ],
                  ),
                );
              },
            );
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
          flex: 2,
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
        Spacer(),
        Expanded(
         flex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rs ${value}',
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
