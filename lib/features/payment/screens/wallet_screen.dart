import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/business/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/wallet_attention_alert_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/wallet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/withdraw_request_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/widgets/withdraw_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  @override
  void initState() {
    Get.find<PaymentController>().getWithdrawList();
    Get.find<PaymentController>().getWithdrawMethodList();
    Get.find<PaymentController>().getWalletPaymentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(Get.find<ProfileController>().profileModel == null) {
      Get.find<ProfileController>().getProfile();
    }
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'wallet'.tr, isBackButtonExist: false),
      body: GetBuilder<ProfileController>(builder: (profileController) {
        return GetBuilder<PaymentController>(builder: (paymentController) {
          return (profileController.profileModel != null && paymentController.withdrawList != null) ? RefreshIndicator(
            onRefresh: () async {
              await Get.find<ProfileController>().getProfile();
              await Get.find<PaymentController>().getWithdrawList();
            },
            child: Column(children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  physics: const BouncingScrollPhysics(),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeLarge,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        color: Theme.of(context).primaryColor,
                      ),
                      alignment: Alignment.center,
                      child: Row(children: [

                        Image.asset(Images.wallet, width: 60, height: 60),
                        const SizedBox(width: Dimensions.paddingSizeLarge),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text(profileController.profileModel!.dynamicBalanceType!, style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor,
                          )),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Text(
                            PriceConverter.convertPrice(profileController.profileModel!.dynamicBalance!),
                            style: robotoBold.copyWith(fontSize: 22, color: Theme.of(context).cardColor),
                            textDirection: TextDirection.ltr,
                          ),

                        ])),

                        Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                          profileController.profileModel!.adjustable! ? InkWell(
                            onTap: () {
                              showDialog(context: context, builder: (BuildContext context) {
                                return GetBuilder<PaymentController>(builder: (controller) {
                                  return AlertDialog(
                                    title: Center(child: Text('cash_adjustment'.tr)),
                                    content: Text('cash_adjustment_description'.tr, textAlign: TextAlign.center),
                                    actions: [

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(children: [

                                          Expanded(
                                            child: CustomButtonWidget(
                                              onPressed: () => Get.back(),
                                              color: Theme.of(context).disabledColor.withOpacity(0.5),
                                              buttonText: 'cancel'.tr,
                                            ),
                                          ),
                                          const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                paymentController.makeWalletAdjustment();
                                              },
                                              child: Container(
                                                height: 45,
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                                child: !controller.adjustmentLoading ? Text('ok'.tr, style: robotoBold.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeLarge),)
                                                    : const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)),
                                              ),
                                            ),
                                          ),

                                        ]),
                                      ),

                                    ],
                                  );
                                });
                              });
                            },
                            child: Container(
                              width: 115,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Text('adjust_payments'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            ),
                          ) : const SizedBox(),
                          SizedBox(height: profileController.profileModel!.adjustable! ? Dimensions.paddingSizeLarge : 0),

                          ((profileController.profileModel!.balance! > 0) && (profileController.profileModel!.balance! > profileController.profileModel!.cashInHands!) && (Get.find<SplashController>().configModel!.disbursementType == 'manual')) ? InkWell(
                            onTap: () {
                              if(paymentController.widthDrawMethods != null && paymentController.widthDrawMethods!.isNotEmpty) {
                                Get.bottomSheet(const WithdrawRequestBottomSheetWidget(), isScrollControlled: true);
                              }else {
                                showCustomSnackBar('currently_no_bank_account_added'.tr);
                              }
                            },
                            child: Container(
                              width: profileController.profileModel!.adjustable! ? 115 : null,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Text('withdraw'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            ),
                          ) : const SizedBox(),
                          SizedBox(height: (profileController.profileModel!.balance! > 0 && profileController.profileModel!.balance! > profileController.profileModel!.cashInHands! && Get.find<SplashController>().configModel!.disbursementType == 'manual') ? Dimensions.paddingSizeSmall : 0),

                          (profileController.profileModel!.cashInHands != 0 && profileController.profileModel!.balance! < profileController.profileModel!.cashInHands!) ? InkWell(
                            onTap: () {
                              if(profileController.profileModel!.showPayNowButton!){
                                showModalBottomSheet(
                                  isScrollControlled: true, useRootNavigator: true, context: context,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusExtraLarge), topRight: Radius.circular(Dimensions.radiusExtraLarge)),
                                  ),
                                  builder: (context) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                                      child: const PaymentMethodBottomSheetWidget(isWalletPayment: true),
                                    );
                                  },
                                );
                              }else {
                                if(Get.find<SplashController>().configModel!.activePaymentMethodList!.isEmpty || !Get.find<SplashController>().configModel!.digitalPayment!){
                                  showCustomSnackBar('currently_there_are_no_payment_options_available_please_contact_admin_regarding_any_payment_process_or_queries'.tr);
                                }else if(Get.find<SplashController>().configModel!.minAmountToPayRestaurant! > profileController.profileModel!.cashInHands!){
                                  showCustomSnackBar('${'you_do_not_have_sufficient_balance_to_pay_the_minimum_payable_balance_is'.tr} ${PriceConverter.convertPrice(Get.find<SplashController>().configModel!.minAmountToPayRestaurant)}');
                                }
                              }
                            },
                            child: Container(
                              width: profileController.profileModel!.adjustable! ? 115 : null,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: profileController.profileModel!.showPayNowButton! ? Theme.of(context).cardColor : Theme.of(context).disabledColor.withOpacity(0.8),
                              ),
                              child: Text('pay_now'.tr, textAlign: TextAlign.center, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            ),
                          ) : const SizedBox(),

                        ]),

                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Row(children: [
                      Expanded(child: WalletWidget(title: 'cash_in_hand'.tr, value: profileController.profileModel!.cashInHands)),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(child: WalletWidget(title: 'withdraw_able_balance'.tr, value: profileController.profileModel!.balance)),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    WalletWidget(title: 'pending_withdraw'.tr, value: profileController.profileModel!.pendingWithdraw, isAmountAndTextInRow: true),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    WalletWidget(title: 'already_withdrawn'.tr, value: profileController.profileModel!.alreadyWithdrawn, isAmountAndTextInRow: true),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    WalletWidget(title: 'total_earning'.tr, value: profileController.profileModel!.totalEarning , isAmountAndTextInRow: true),

                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                      child: Row(children: [

                        InkWell(
                          onTap: () {
                            if(paymentController.selectedIndex != 0) {
                              paymentController.setIndex(0);
                            }
                          },
                          hoverColor: Colors.transparent,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Text('withdraw_request'.tr, style: robotoMedium.copyWith(
                              color: paymentController.selectedIndex == 0 ? Colors.blue : Theme.of(context).disabledColor,
                            )),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Container(
                              height: 3, width: 120,
                              margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: paymentController.selectedIndex == 0 ? Colors.blue : null,
                              ),
                            ),

                          ]),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        InkWell(
                          onTap: () {
                            if(paymentController.selectedIndex != 1) {
                              paymentController.setIndex(1);
                            }
                          },
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Text('payment_history'.tr, style: robotoMedium.copyWith(
                              color: paymentController.selectedIndex == 1 ? Colors.blue : Theme.of(context).disabledColor,
                            )),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Container(
                              height: 3, width: 120,
                              margin: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: paymentController.selectedIndex == 1 ? Colors.blue : null,
                              ),
                            ),

                          ]),
                        ),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      Text("transaction_history".tr, style: robotoMedium),

                      InkWell(
                        onTap: () {
                          if(paymentController.selectedIndex == 0) {
                            Get.toNamed(RouteHelper.getWithdrawHistoryRoute());
                          }
                          if(paymentController.selectedIndex == 1) {
                            Get.toNamed(RouteHelper.getPaymentHistoryRoute());
                          }

                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          child: Text('view_all'.tr, style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,
                          )),
                        ),
                      ),

                    ]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                    if(paymentController.selectedIndex == 0)
                      paymentController.withdrawList != null ? paymentController.withdrawList!.isNotEmpty ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: paymentController.withdrawList!.length > 10 ? 10 : paymentController.withdrawList!.length,
                        itemBuilder: (context, index) {
                          return WithdrawWidget(
                            withdrawModel: paymentController.withdrawList![index],
                            showDivider: index != (paymentController.withdrawList!.length > 25 ? 25 : paymentController.withdrawList!.length-1),
                          );
                        },
                      ) : Center(child: Padding(padding: const EdgeInsets.only(top: 100), child: Text('no_transaction_found'.tr)))
                          : const Center(child: Padding(padding: EdgeInsets.only(top: 100), child: CircularProgressIndicator())),

                    if (paymentController.selectedIndex == 1)
                      paymentController.transactions != null ? paymentController.transactions!.isNotEmpty ? ListView.builder(
                        itemCount: paymentController.transactions!.length > 25 ? 25 : paymentController.transactions!.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(children: [

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                              child: Row(children: [
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(PriceConverter.convertPrice(paymentController.transactions![index].amount), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                    Text('${'paid_via'.tr} ${paymentController.transactions![index].method?.replaceAll('_', ' ').capitalize??''}', style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                                    )),
                                  ]),
                                ),
                                Text(paymentController.transactions![index].paymentTime.toString(),
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                ),
                              ]),
                            ),

                            const Divider(height: 1),
                          ]);
                        },
                      ) : Center(child: Padding(padding: const EdgeInsets.only(top: 100), child: Text('no_transaction_found'.tr)))
                          : const Center(child: Padding(padding: EdgeInsets.only(top: 100), child: CircularProgressIndicator())),

                  ]),
                ),
              ),

              (profileController.profileModel!.overFlowWarning! || profileController.profileModel!.overFlowBlockWarning!)
                  ? WalletAttentionAlertWidget(isOverFlowBlockWarning: profileController.profileModel!.overFlowBlockWarning!) : const SizedBox(),

            ]),
          ) : const Center(child: CircularProgressIndicator());
        });
      }),
    );
  }
}