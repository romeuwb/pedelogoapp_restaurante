import 'package:card_swiper/card_swiper.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/widgets/refund_payment_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/widgets/subscription_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/widgets/subscription_payment_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/color_coverter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_print_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RenewSubscriptionScreen extends StatefulWidget {
  const RenewSubscriptionScreen({super.key});

  @override
  State<RenewSubscriptionScreen> createState() => _RenewSubscriptionScreenState();
}

class _RenewSubscriptionScreenState extends State<RenewSubscriptionScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<SubscriptionController>().getPackageList();
    Get.find<SubscriptionController>().initializeRenew();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(
        title: 'change_subscription_plan'.tr,
        onBackPressed: () {
          if(Get.find<SubscriptionController>().renewStatus != 'packages') {
            Get.find<SubscriptionController>().renewChangePackage('packages');
          }else{
            Get.back();
          }
        }
      ),

      body: GetBuilder<SubscriptionController>(builder: (subscriptionController) {

        int activePackageIndex = -1;

        if(subscriptionController.packageModel != null){
          for (var element in subscriptionController.packageModel!.packages!) {
            if(subscriptionController.profileModel!.subscription!.package!.id == element.id){
              activePackageIndex = subscriptionController.packageModel!.packages!.indexOf(element);
              customPrint('active package : $activePackageIndex');
            }
          }
        }

        return subscriptionController.packageModel != null ? Column(children: [

          Expanded(
            child: SingleChildScrollView(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                subscriptionController.renewStatus == 'packages' ? SizedBox(
                  height: 600,
                  child: (subscriptionController.packageModel!.packages!.isNotEmpty && subscriptionController.packageModel!.packages!.isNotEmpty) ? Swiper(
                    itemCount: subscriptionController.packageModel!.packages!.length,
                    itemWidth: context.width * 0.8,
                    itemHeight: 600.0,
                    index: activePackageIndex,
                    layout: SwiperLayout.STACK,
                    onIndexChanged: (index){
                      subscriptionController.selectSubscriptionCard(index);
                      subscriptionController.activePackage(activePackageIndex == index);
                    },
                    itemBuilder: (BuildContext context, int index){
                      Packages package = subscriptionController.packageModel!.packages![index];

                      Color color = ColorConverterHelper.stringToColor(package.color);

                      return GetBuilder<SubscriptionController>(builder: (subscriptionController) {
                        return Stack(clipBehavior: Clip.none, children: [

                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 10)],
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeExtraSmall),
                            child: SubscriptionCardWidget(index: index, subscriptionController: subscriptionController, package: package, color: color),
                          ),

                          subscriptionController.activeSubscriptionIndex == index ? Positioned(
                            top: 5, right: -10,
                            child: Container(
                              height: 40, width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: color, border: Border.all(color: Theme.of(context).cardColor, width: 2),
                              ),
                              child: Icon(Icons.check, color: Theme.of(context).cardColor),
                            ),
                          ) : const SizedBox(),

                        ]);
                      });
                    },
                  ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                    Image.asset(Images.emptyBox, height: 150),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Text('no_package_available'.tr),

                  ])),
                ) : Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Column(children: [

                    RefundPaymentCardWidget(
                      title: 'pay_from_restaurant_wallet'.tr,
                      subTitle: '${PriceConverter.convertPrice(subscriptionController.profileModel!.balance)} ${'payable_amount_in_your_wallet'.tr}',
                      index: 0,
                      onTap: (){
                        subscriptionController.setPaymentIndex(0);
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    RefundPaymentCardWidget(
                      title: 'pay_online'.tr,
                      subTitle: subscriptionController.digitalPaymentName != null ? subscriptionController.digitalPaymentName!.toString().replaceAll('_', ' ') : '',
                      index: 1,
                      onTap: (){
                        subscriptionController.setPaymentIndex(1);
                        showModalBottomSheet(
                          isScrollControlled: true, useRootNavigator: true, context: Get.context!,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radiusExtraLarge),
                              topRight: Radius.circular(Dimensions.radiusExtraLarge),
                            ),
                          ),
                          builder: (context) {
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                              child: const SubscriptionPaymentBottomSheetWidget(),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  ]),
                ),
              ]),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: (subscriptionController.packageModel!.packages!.isNotEmpty && subscriptionController.packageModel!.packages!.isNotEmpty)
                ? !subscriptionController.isLoading ? CustomButtonWidget(
              buttonText: (subscriptionController.isActivePackage! && activePackageIndex != -1) ? 'renew'.tr : 'shift_this_plan'.tr,
              onPressed: (){
                if(subscriptionController.renewStatus == 'packages') {
                  subscriptionController.renewChangePackage('payment');
                }else{
                  subscriptionController.renewBusinessPlan(subscriptionController.profileModel!.restaurants![0].id.toString());
                }
              },
            ) : const Center(child: CircularProgressIndicator()) : const SizedBox(),
          )

        ]) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}