import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/withdraw_widget.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawRequestHistoryScreen extends StatelessWidget {
  const WithdrawRequestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'withdraw_request_history'.tr, menuWidget: PopupMenuButton(
        itemBuilder: (context) {
          return <PopupMenuEntry>[
            getMenuItem(Get.find<PaymentController>().statusList[0], context),
            const PopupMenuDivider(),
            getMenuItem(Get.find<PaymentController>().statusList[1], context),
            const PopupMenuDivider(),
            getMenuItem(Get.find<PaymentController>().statusList[2], context),
            const PopupMenuDivider(),
            getMenuItem(Get.find<PaymentController>().statusList[3], context),
          ];
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
        offset: const Offset(-25, 25),
        child: Container(
          width: 40, height: 40,
          margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).disabledColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          child: const Icon(Icons.arrow_drop_down, size: 30),
        ),
        onSelected: (dynamic value) {
          int index = Get.find<PaymentController>().statusList.indexOf(value);
          Get.find<PaymentController>().filterWithdrawList(index);
        },
      ),
      onBackPressed: () {
        Get.find<PaymentController>().filterWithdrawList(0);
        Get.back();
      }),

      body: GetBuilder<PaymentController>(builder: (paymentController) {
        return paymentController.withdrawList!.isNotEmpty ? ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: paymentController.withdrawList!.length,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          itemBuilder: (context, index) {
            return WithdrawWidget(
              withdrawModel: paymentController.withdrawList![index],
              showDivider: index != paymentController.withdrawList!.length - 1,
            );
          },
        ) : Center(child: Text('no_transaction_found'.tr));
      }),
    );
  }

  PopupMenuItem getMenuItem(String status, BuildContext context) {
    return PopupMenuItem(
      value: status,
      height: 30,
      child: Text(status.toLowerCase().tr, style: robotoRegular.copyWith(
        color: status == 'Pending' ? Theme.of(context).primaryColor : status == 'Approved' ? Colors.green : status == 'Denied' ? Theme.of(context).colorScheme.error : null,
      )),
    );
  }

}