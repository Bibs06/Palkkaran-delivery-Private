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
      bottomSheet: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.sp),
          color: ColorUtils.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        height: 140.h,
        width: double.infinity,
        child: Consumer(builder: (
          context,
          ref2,
          child,
        ) {
          final model = ref2.watch(orderProvider);
          if (model.invoiceModel == null ||
              model.invoiceModel!.invoice.isEmpty) {
            return SizedBox.shrink();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Amount ${model.total}',
                  style: TextStyle(
                      color: ColorUtils.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Amount Paid ${model.pending}',
                  style: TextStyle(
                      color: ColorUtils.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Pending ${model.total! - model.pending!}',
                  style: TextStyle(
                      color: ColorUtils.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ],
            );
          }
        }),
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
              model.invoiceModel!.invoice.isEmpty) {
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
              itemCount: model.invoiceModel!.invoice.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    model.invoiceModel!.invoice[index].invoiceData
                        .invoiceDetails.invoiceNo,
                    style: TextStyle(
                        color: ColorUtils.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rs ${model.invoiceModel!.invoice[index].invoiceData.total.toString()}',
                        style: TextStyle(
                          color: ColorUtils.black,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    model.invoiceModel!.invoice[index].invoiceData
                                .invoiceDetails.paymentStatus ==
                            'unpaid'
                        ? 'unPaid'
                        : 'paid',
                    style: TextStyle(
                      color: model.invoiceModel!.invoice[index].invoiceData
                                  .invoiceDetails.paymentStatus ==
                              'unpaid'
                          ? Colors.red
                          : Colors.green,
                      fontSize: 15.sp,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
