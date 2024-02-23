import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/widgets/sub_menu_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'reports'.tr),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(children: [

            SubMenuCardWidget(title: 'expense_report'.tr, image: Images.expenseIcon, route: () => Get.toNamed(RouteHelper.getExpenseRoute())),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            SubMenuCardWidget(title: 'transaction_report'.tr, image: Images.transactionIcon, route: () => Get.toNamed(RouteHelper.getTransactionReportRoute())),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            SubMenuCardWidget(title: 'order_report'.tr, image: Images.orderIcon, route: () => Get.toNamed(RouteHelper.getOrderReportRoute())),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            SubMenuCardWidget(title: 'food_report'.tr, image: Images.foodIcon, route: () => Get.toNamed(RouteHelper.getFoodReportRoute())),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            SubMenuCardWidget(title: 'campaign_report'.tr, image: Images.campaignIcon, route: () => Get.toNamed(RouteHelper.getCampaignReportRoute())),

          ]),
        ),
      )
    );
  }
}