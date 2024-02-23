import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/business/controllers/business_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/business/widgets/base_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/business/widgets/payment_cart_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/business/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/business/widgets/registration_stepper_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/business/widgets/business_subscription_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/business/widgets/success_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/color_coverter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';

class BusinessPlanScreen extends StatefulWidget {
  final int? restaurantId;
  final String? paymentId;
  const BusinessPlanScreen({super.key, required this.restaurantId, this.paymentId});

  @override
  State<BusinessPlanScreen> createState() => _BusinessPlanScreenState();
}

class _BusinessPlanScreenState extends State<BusinessPlanScreen> {

  final bool _canBack = false;

  @override
  void initState() {
    super.initState();

    if(widget.paymentId != null) {
      Get.find<BusinessController>().setBusinessStatus('payment', canUpdate: false);
      Get.find<BusinessController>().setBusiness(1, canUpdate: false);
      Get.find<BusinessController>().setPaymentIndex(1, willUpdate: false);
    } else {
      Get.find<BusinessController>().resetBusiness();
      Get.find<BusinessController>().getPackageList();
    }
    Get.find<BusinessController>().changeDigitalPaymentName(null, canUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusinessController>(builder: (businessController) {
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async{
          if(_canBack) {
            return;
          }else {
            _showBackPressedDialogue('your_business_plan_not_setup_yet'.tr);
          }
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(title: 'business_plan'.tr, isBackButtonExist: widget.paymentId != null),
          body: Scrollbar(
            child: Center(
              child: Container(
                width: context.width > 700 ? 700 : context.width,
                padding: context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                child: businessController.businessPlanStatus == 'complete' ?  const SuccessWidget() : Column(children: [

                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  RegistrationStepperWidget(status: businessController.businessPlanStatus),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [

                        businessController.businessPlanStatus != 'payment' ? Column(children: [

                          Center(child: Text('choose_your_business_plan'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault))),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                            child: Row(children: [
                              Get.find<SplashController>().configModel!.businessPlan!.commission != 0 ? Expanded(
                                child: BaseCardWidget(
                                  businessController: businessController,
                                  title: 'commission_base'.tr,
                                  index: 0,
                                  onTap: ()=> businessController.setBusiness(0),
                                ),
                              ) : const SizedBox(),
                              const SizedBox(width: Dimensions.paddingSizeDefault),

                              Get.find<SplashController>().configModel!.businessPlan!.subscription != 0 ? Expanded(
                                child: BaseCardWidget(
                                  businessController: businessController,
                                  title: 'subscription_base'.tr,
                                  index: 1,
                                  onTap: ()=> businessController.setBusiness(1),
                                ),
                              ) : const SizedBox(),

                            ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          businessController.businessIndex == 0 ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                            child: Text(
                              "${'restaurant_will_pay'.tr} ${Get.find<SplashController>().configModel!.adminCommission}% ${'commission_to'.tr} ${Get.find<SplashController>().configModel!.businessName} ${'from_each_order_You_will_get_access_of_all'.tr}",
                              style: robotoRegular, textAlign: TextAlign.start, textScaler: const TextScaler.linear(1.1),
                            ),
                          ) : Column(children: [

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                              child: Text(
                                'run_restaurant_by_purchasing_subscription_packages'.tr,
                                style: robotoRegular, textAlign: TextAlign.start, textScaler: const TextScaler.linear(1.1),
                              ),
                            ),

                            businessController.packageModel != null ? SizedBox(
                              height: 600,
                              child: (businessController.packageModel!.packages!.isNotEmpty && businessController.packageModel!.packages!.isNotEmpty) ? Swiper(
                                itemCount: businessController.packageModel!.packages!.length,
                                itemWidth: context.width * 0.8,
                                itemHeight: 600.0,
                                layout: SwiperLayout.STACK,
                                onIndexChanged: (index){
                                  businessController.selectSubscriptionCard(index);
                                },
                                itemBuilder: (BuildContext context, int index){

                                  Packages package = businessController.packageModel!.packages![index];
                                  Color color = ColorConverterHelper.stringToColor(package.color);

                                  return GetBuilder<BusinessController>(builder: (businessController) {
                                    return Stack(clipBehavior: Clip.none, children: [

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                                          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 10)],
                                        ),
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                        margin: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeExtraSmall),
                                        child: BusinessSubscriptionCardWidget(index: index, businessController: businessController, package: package, color: color),
                                      ),

                                      businessController.activeSubscriptionIndex == index ? Positioned(
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

                              ]),
                              ),
                            ) : const CircularProgressIndicator(),
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                          ]),
                        ]) : Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          child: Column(children: [

                            Get.find<SplashController>().configModel!.freeTrialPeriodStatus == 1 && widget.paymentId == null ? PaymentCartWidget(
                              title: '${'continue_with'.tr} ${Get.find<SplashController>().configModel!.freeTrialPeriodDay} ${'days_free_trial'.tr}',
                              index: 0,
                              onTap: () {
                                businessController.setPaymentIndex(0);
                              },
                            ) : const SizedBox(),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                            PaymentCartWidget(
                              title: businessController.digitalPaymentName != null ? businessController.digitalPaymentName!.toString().replaceAll('_', ' ') : 'pay_online'.tr,
                              index: 1,
                              onTap: () {
                                businessController.setPaymentIndex(1);
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
                                      child: const PaymentMethodBottomSheetWidget(),
                                    );
                                  },
                                );
                              },
                            ),

                          ]),
                        ),

                      ]),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                    child: Row(children: [

                      (businessController.businessPlanStatus == 'payment' && widget.paymentId == null) ? Expanded(
                        child: InkWell(
                          onTap: () {
                            if(businessController.businessPlanStatus != 'payment'){
                              _showBackPressedDialogue('your_business_plan_not_setup_yet'.tr);
                            }else{
                              businessController.setBusinessStatus('business');
                              businessController.changeDigitalPaymentName(null);
                              if(businessController.isFirstTime == false){
                                businessController.isFirstTime = true;
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              const Icon(Icons.keyboard_double_arrow_left),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Text("back".tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
                            ]),
                          ),
                        ),
                      ) : const SizedBox(),
                      SizedBox(width: (businessController.businessPlanStatus == 'payment') ? Dimensions.paddingSizeExtraSmall : 0),

                      (widget.paymentId != null) || (businessController.businessIndex == 0 || (businessController.businessIndex == 1 && businessController.packageModel != null && businessController.packageModel!.packages!.isNotEmpty))
                          ? Expanded(child: CustomButtonWidget(
                        buttonText: 'next'.tr,
                        onPressed: () => businessController.submitBusinessPlan(widget.restaurantId, widget.paymentId),
                      )) : const SizedBox(),

                    ]),
                  ),

                ]),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showBackPressedDialogue(String title){
    Get.dialog(ConfirmationDialogWidget(icon: Images.support,
      title: title,
      description: 'are_you_sure_to_go_back'.tr, isLogOut: true,
      onYesPressed: () => Get.offAllNamed(RouteHelper.getSignInRoute()),
    ), useSafeArea: false);
  }

}