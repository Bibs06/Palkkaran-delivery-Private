import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palkkaran/core/enums/view_state.dart';
import 'package:palkkaran/core/navigate.dart';
import 'package:palkkaran/core/utils/colors.dart';
import 'package:palkkaran/core/utils/image_assets.dart';
import 'package:palkkaran/core/view_models/order_view_model.dart';
import 'package:palkkaran/views/customer_details_view.dart';

class CustomersView extends ConsumerStatefulWidget {
  const CustomersView({super.key});

  @override
  ConsumerState<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends ConsumerState<CustomersView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers',
            style: TextStyle(
                color: ColorUtils.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold)),
      ),
      body: Consumer(builder: (context, ref, child) {
        final model = ref.watch(orderProvider);
        if (model.usersState == ViewState.loading) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorUtils.kPrimary,
            ),
          );
        } else if (model.customersModel == null ||
            model.customersModel!.customers.isEmpty) {
          return Center(
            child: Text('No customers found',
                style: TextStyle(
                    color: ColorUtils.black,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold)),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
              itemCount: model.customersModel!.customers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: ListTile(
                   
                    tileColor: ColorUtils.white,
                    onTap: () {
                      Go.to(context, CustomerDetailsView(userId:model.customersModel!.customers[index].id,csId: model.customersModel!.customers[index].customerId,));
                    },
                    leading: CircleAvatar(
                      backgroundColor: ColorUtils.white,
                      backgroundImage: AssetImage(ImageAssets.avatar),
                    ),
                    title: Text(model.customersModel!.customers[index].name,
                        style: TextStyle(
                            color: ColorUtils.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              });
        }
      }),
    );
  }
}
