import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/widgets/billing_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/widgets/plan_tile_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionViewScreen extends StatefulWidget {
  const SubscriptionViewScreen({super.key});

  @override
  State<SubscriptionViewScreen> createState() => _SubscriptionViewScreenState();
}

class _SubscriptionViewScreenState extends State<SubscriptionViewScreen> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    if(!Get.find<SubscriptionController>().showSubscriptionAlertDialog){
      Get.find<SubscriptionController>().showAlert();
    }
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<SubscriptionController>().getProfile(Get.find<ProfileController>().profileModel);
    } else {
      Get.find<SubscriptionController>().getProfile(Get.find<AuthController>().profileModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,

      appBar: CustomAppBarWidget(title: 'my_subscription'.tr, isBackButtonExist: Get.find<SubscriptionController>().profileModel!.id != null),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
        child: GetBuilder<SubscriptionController>(builder: (subscriptionController) {
          return subscriptionController.profileModel != null ? SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Stack(children: [

                Column(children: [

                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                    Text('billing_details'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),

                    (DateConverter.expireDifferanceInDays(DateTime.parse(subscriptionController.profileModel!.subscription!.expiryDate!)) <= 10
                    && subscriptionController.profileModel!.id != null && Get.find<SplashController>().configModel!.businessPlan!.subscription != 0) ? IconButton(
                      onPressed: () => subscriptionController.showAlert(willUpdate: true),
                      icon:  Icon(Icons.error, color: Theme.of(context).primaryColor),
                    ) : const SizedBox(),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).disabledColor, width: 0.2),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).disabledColor.withOpacity(0.05),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
                    child: Column(children: [

                      subscriptionController.profileModel!.subscription!.status == 1 ? BillingCardWidget(
                        logo: Images.billTime, title: 'next_billing_date'.tr,
                        subTitle: DateConverter.localDateToIsoStringAMPM(DateTime.parse(subscriptionController.profileModel!.subscription!.expiryDate!)),
                      ) : BillingCardWidget(
                        logo: Images.billTime, title: 'package_expired'.tr, titleBig: true, subtitleSmall: true,
                        subTitle: DateConverter.localDateToIsoStringAMPM(DateTime.parse(subscriptionController.profileModel!.subscription!.expiryDate!)),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      BillingCardWidget(
                        logo: Images.bill, title: 'total_bill'.tr,
                        subTitle: (subscriptionController.profileModel!.subscriptionOtherData != null && subscriptionController.profileModel!.subscriptionOtherData!.totalBill != null)
                            ? PriceConverter.convertPrice(subscriptionController.profileModel!.subscriptionOtherData!.totalBill) : '0',
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      BillingCardWidget(logo: Images.subscriptionLogo, title: 'number_of_uses'.tr, subTitle: '${subscriptionController.profileModel!.subscription!.totalPackageRenewed! + 1}'),

                    ]),
                  ),
                ]),

                (DateConverter.expireDifferanceInDays(DateTime.parse(subscriptionController.profileModel!.subscription!.expiryDate!)) <= 10
                && subscriptionController.showSubscriptionAlertDialog && subscriptionController.profileModel!.id != null
                && Get.find<SplashController>().configModel!.businessPlan!.subscription != 0) ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(children: [

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      Text('attention'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor)),

                      IconButton(
                        onPressed: () => subscriptionController.closeAlertDialog(),
                        icon: Icon(Icons.clear, color: Theme.of(context).cardColor),
                      ),

                    ]),

                    Text(
                      '${'attention_text_1'.tr} ${DateConverter.localDateToIsoStringAMPM(DateTime.parse(subscriptionController.profileModel!.subscription!.expiryDate!))} ${'attention_text_2'.tr}',
                      style: robotoRegular.copyWith(color: Theme.of(context).cardColor),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                  ]),
                ) : const SizedBox(),
              ]),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('subscription_plan'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),

                DateConverter.expireDifferanceInDays(DateTime.parse(subscriptionController.profileModel!.subscription!.expiryDate!)) <= 10
                && Get.find<SplashController>().configModel!.businessPlan!.subscription != 0 ? ElevatedButton(
                  child: Text('renew_subscription'.tr),
                  onPressed: ()=> Get.toNamed(RouteHelper.getRenewSubscriptionRoute()),
                ) : const SizedBox(),

              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Column(children: [

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                    Text(subscriptionController.profileModel!.subscription!.package!.packageName!, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.blue)),

                    Row(crossAxisAlignment: CrossAxisAlignment.end,children: [

                      Text(
                        '${PriceConverter.convertPrice(subscriptionController.profileModel!.subscription!.package!.price)}/',
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge),
                        textDirection: TextDirection.ltr,
                      ),

                      Text(
                        '${subscriptionController.profileModel!.subscription!.package!.validity} ${'days'.tr}',
                        style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5), fontSize: Dimensions.fontSizeDefault),
                      ),

                    ]),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  PlanTileWidget(
                    title1: 'max_order'.tr,
                    title2: ' ${subscriptionController.profileModel!.subscription!.maxOrder == 'unlimited' ? '(${subscriptionController.profileModel!.subscription!.maxOrder.toString().tr})' : '(${subscriptionController.profileModel!.subscription!.maxOrder} ${'left'.tr})'}',
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  PlanTileWidget(
                    title1: 'max_product'.tr,
                    title2: ' ${subscriptionController.profileModel!.subscription!.maxOrder == 'unlimited' ? '(${subscriptionController.profileModel!.subscription!.maxProduct.toString().tr})'
                        : '(${subscriptionController.profileModel!.subscriptionOtherData != null ? subscriptionController.profileModel!.subscriptionOtherData!.maxProductUpload : 0} ${'left'.tr})'}',
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  subscriptionController.profileModel!.subscription!.pos == 1 ? PlanTileWidget(title1: 'pos_access'.tr, title2: '') : const SizedBox(),
                  SizedBox(height: subscriptionController.profileModel!.subscription!.pos == 1 ? Dimensions.paddingSizeSmall : 0),

                  subscriptionController.profileModel!.subscription!.mobileApp == 1 ? PlanTileWidget(title1: 'mobile_app_access'.tr, title2: '') : const SizedBox(),
                  SizedBox(height: subscriptionController.profileModel!.subscription!.mobileApp == 1 ? Dimensions.paddingSizeSmall : 0),

                  subscriptionController.profileModel!.subscription!.chat == 1 ? PlanTileWidget(title1: 'chat'.tr, title2: '') : const SizedBox(),
                  SizedBox(height: subscriptionController.profileModel!.subscription!.chat == 1 ? Dimensions.paddingSizeSmall : 0),

                  subscriptionController.profileModel!.subscription!.review == 1 ? PlanTileWidget(title1: 'review'.tr, title2: '') : const SizedBox(),
                  SizedBox(height: subscriptionController.profileModel!.subscription!.review == 1 ? Dimensions.paddingSizeSmall : 0),

                  subscriptionController.profileModel!.subscription!.selfDelivery == 1 ? PlanTileWidget(title1: 'self_delivery'.tr, title2: '') : const SizedBox(),
                  SizedBox(height: subscriptionController.profileModel!.subscription!.selfDelivery == 1 ? Dimensions.paddingSizeSmall : 0),

                ]),
              ),

            ]),
          ) : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}