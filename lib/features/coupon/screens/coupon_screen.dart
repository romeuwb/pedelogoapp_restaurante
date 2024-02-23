import 'dart:math';
import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_loader_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/controllers/coupon_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/screens/add_coupon_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/widgets/coupon_card_dialogue_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<CouponController>().getCouponList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'coupon'.tr),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddCouponScreen()),
        child: Icon(Icons.add_circle_outline, size: 30, color: Theme.of(context).cardColor),
      ),

      body: RefreshIndicator(
        onRefresh: ()async{
          await Get.find<CouponController>().getCouponList();
        },
        child: GetBuilder<CouponController>(builder: (couponController) {
          return couponController.couponList != null ? couponController.couponList!.isNotEmpty ? ListView.builder(
            shrinkWrap: true,
            itemCount: couponController.couponList!.length,
            itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                Get.dialog(CouponCardDialogueWidget(couponBody: couponController.couponList![index], index: index), barrierDismissible: true, useSafeArea: true);
              },
              child: SizedBox(
                height: 150,
                child: Stack(children: [

                  Transform.rotate(
                    angle: Get.find<LocalizationController>().isLtr ? 0 : pi,
                    child: SizedBox(
                      height: 150,
                      child: Image.asset(Images.couponBgDark, fit: BoxFit.fill),
                    ),
                  ),

                  Row(children: [

                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 50, width: 50, alignment: Alignment.center,
                        padding: EdgeInsets.only(left: Get.find<LocalizationController>().isLtr ? 50.0 : 0, bottom: Get.find<LocalizationController>().isLtr ? 10 : 0, right: 0),
                        child: Stack(children: [

                          Center(child: Image.asset(Images.couponVertical)),

                          Center(
                            child: Text(couponController.couponList![index].discountType == 'percent' ? '%' : '\$',
                              style: robotoBold.copyWith(fontSize: 18, color: Theme.of(context).cardColor),
                            ),
                          ),

                        ]),
                      ),
                    ),
                    const SizedBox(width: 20),

                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeLarge),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                            Text('${'${couponController.couponList![index].couponType == 'free_delivery' ? 'free_delivery'.tr : couponController.couponList![index].discountType != 'percent' ?
                            PriceConverter.convertPrice(double.parse(couponController.couponList![index].discount.toString())) :
                            couponController.couponList![index].discount}'} ${couponController.couponList![index].couponType == 'free_delivery' ? '' : couponController.couponList![index].discountType == 'percent' ? ' %' : ''}'
                                '${couponController.couponList![index].couponType == 'free_delivery' ? '' : 'off'.tr}',
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textDirection: TextDirection.ltr,
                            ),

                            Row(children: [
                              Switch(
                                activeColor: Theme.of(context).primaryColor,
                                value: couponController.couponList![index].status == 1 ? true : false,
                                onChanged: (bool status){
                                  couponController.changeStatus(couponController.couponList![index].id, status).then((success) {
                                    if(success){
                                      Get.find<CouponController>().getCouponList();
                                    }
                                  });
                                },
                              ),

                              PopupMenuButton(
                                itemBuilder: (context) {
                                  return <PopupMenuEntry>[
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('edit'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('delete'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.red)),
                                    ),
                                  ];
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                offset: const Offset(-20, 20),
                                child: const Padding(
                                  padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                  child: Icon(Icons.more_vert, size: 25),
                                ),
                                onSelected: (dynamic value) {
                                  if (value == 'delete') {
                                    Get.dialog(ConfirmationDialogWidget(
                                      icon: Images.warning, title: 'are_you_sure_to_delete'.tr, description: 'you_want_to_delete_this_coupon'.tr,
                                      onYesPressed: () {
                                        couponController.deleteCoupon(couponController.couponList![index].id!).then((success) {
                                          if(success){
                                            Get.find<CouponController>().getCouponList();
                                          }
                                        });
                                      },
                                    ), barrierDismissible: false);

                                  }else{
                                    Get.dialog(const CustomLoaderWidget());
                                    couponController.getCouponDetails(couponController.couponList![index].id!).then((couponDetails) {
                                      Get.back();
                                      if(couponDetails != null) {
                                        Get.to(() => AddCouponScreen(coupon: couponDetails));
                                      }
                                    });
                                  }
                                }
                              ),

                            ]),
                          ]),

                          Text('${'code'.tr}: ${couponController.couponList![index].code!}', style: robotoMedium),
                          const SizedBox(height: 5),

                          Text('${'total_users'.tr}: ${couponController.couponList![index].totalUses}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                          const SizedBox(height: 5),

                          Text('${'valid_until'.tr} ${couponController.couponList![index].startDate!}  ${'to'.tr} ${couponController.couponList![index].expireDate!}',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                          ),

                        ]),
                      ),
                    ),

                  ]),

                ]),
              ),
            );
          }) : Center(child: Text('no_coupon_found'.tr)) : const Center(child: CircularProgressIndicator());
        }),
      ),

    );
  }
}
