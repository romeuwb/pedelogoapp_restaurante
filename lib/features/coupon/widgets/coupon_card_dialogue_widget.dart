import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/domain/models/coupon_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/screens/add_coupon_screen.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponCardDialogueWidget extends StatelessWidget {
  final CouponBodyModel couponBody;
  final int index;
  const CouponCardDialogueWidget({super.key, required this.couponBody, required this.index});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
      insetPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 500,
        child: Container(
          width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.52,
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.black : Colors.transparent,
            image: DecorationImage(image: const AssetImage(Images.couponDetails), fit: BoxFit.fill,
              colorFilter: Get.isDarkMode ? ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop) : null,
            ),
          ),
          child: Stack(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min, children: [
                Row(children: [

                  SizedBox(
                    height: 50, width: 50,
                    child: Stack(children: [
                      Image.asset(Images.couponVertical),
                      Positioned(
                        top: 15, left: 15,
                        child: Text(couponBody.couponType == 'free_delivery' ? '' : couponBody.discountType == 'percent' ? ' %' : ' \$',
                          style: robotoBold.copyWith(fontSize: 18, color: Theme.of(context).cardColor),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${'${couponBody.couponType == 'free_delivery' ? 'free_delivery'.tr : couponBody.discountType != 'percent' ?
                    PriceConverter.convertPrice(double.parse(couponBody.discount.toString())) :
                    couponBody.discount}'} ${couponBody.couponType == 'free_delivery' ? '' : couponBody.discountType == 'percent' ? ' %' : ''}'
                        '${couponBody.couponType == 'free_delivery' ? '' : 'off'.tr}',
                      style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textDirection: TextDirection.ltr,
                    ),
                    Text('${couponBody.code}', style: robotoMedium),
                  ]),
                  const Spacer(),

                  GetBuilder<CouponController>(builder: (couponController) {
                    return Switch(
                      activeColor: Theme.of(context).primaryColor,
                      value: couponController.couponList![index].status == 1 ? true : false,
                      onChanged: (bool status){
                        couponController.changeStatus(couponController.couponList![index].id, status).then((success) {
                          if(success){
                            couponController.getCouponList();
                          }
                        });
                      },
                    );
                  }),

                ]),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('-  ${'start_date'.tr} : ${couponBody.startDate!}',
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text('- ${'expire_date'.tr} : ${couponBody.expireDate!}',
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text('-  ${'total_user'.tr} : ${couponBody.totalUses.toString()}',
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text('- ${'min_purchase'.tr} : ${couponBody.minPurchase.toString()}',
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text('- ${'limit'.tr} : ${couponBody.limit.toString()}',
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text('- ${'coupon_type'.tr} : ${couponBody.couponType!.tr}',
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

              ]),

              Align(
                alignment: Alignment.bottomCenter,
                child: GetBuilder<CouponController>(builder: (couponController) {
                  return Row(mainAxisSize: MainAxisSize.min, children: [
                    OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          const BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                          style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      onPressed: (){
                        Get.back();
                        Get.to(()=> AddCouponScreen(coupon: couponController.couponList![index]));
                      },
                      child: const Icon(Icons.edit, color: Colors.blue),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                    OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(BorderSide(
                          color: Theme.of(context).colorScheme.error,
                          width: 1.0,
                          style: BorderStyle.solid)),
                      ),
                      onPressed: (){
                        Get.back();
                        Get.dialog(ConfirmationDialogWidget(
                          icon: Images.warning, title: 'are_you_sure_to_delete'.tr, description: 'you_want_to_delete_this_coupon'.tr,
                          onYesPressed: () {
                            couponController.deleteCoupon(couponBody.id!);
                          },
                        ), barrierDismissible: false);
                      },
                      child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                    ),
                  ]);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}