import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/menu/domain/models/menu_model.dart';
import 'package:stackfood_multivendor_restaurant/features/menu/widgets/menu_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MenuModel> menuList = [

      MenuModel(icon: '', title: 'profile'.tr, route: RouteHelper.getProfileRoute()),

      MenuModel(
        icon: Images.addFood, title: 'add_food'.tr, route: RouteHelper.getProductRoute(null),
        isBlocked: !Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!,
      ),

      MenuModel(icon: Images.campaign, title: 'campaign'.tr, route: RouteHelper.getCampaignRoute()),

      MenuModel(icon: Images.addon, title: 'addons'.tr, route: RouteHelper.getAddonsRoute()),

      MenuModel(icon: Images.categories, title: 'categories'.tr, route: RouteHelper.getCategoriesRoute()),

      MenuModel(icon: Images.coupon, title: 'coupon'.tr, route: RouteHelper.getCouponRoute()),

      MenuModel(icon: Images.reportsIcon, title: 'reports'.tr, route: RouteHelper.getReportsRoute()),

      if(Get.find<SplashController>().configModel!.disbursementType == 'automated')
      MenuModel(icon: Images.disbursementIcon, title: 'disbursement'.tr, route: RouteHelper.getDisbursementMenuRoute()),

      MenuModel(icon: Images.language, title: 'language'.tr, route: RouteHelper.getLanguageRoute('menu')),

      MenuModel(
        icon: Images.chat, title: 'conversation'.tr, route: RouteHelper.getConversationListRoute(),
        isNotSubscribe: (Get.find<ProfileController>().profileModel!.restaurants![0].restaurantModel == 'subscription'
            && Get.find<ProfileController>().profileModel!.subscription != null && Get.find<ProfileController>().profileModel!.subscription!.chat == 0) ,
      ),

      MenuModel(icon: Images.policy, title: 'privacy_policy'.tr, route: RouteHelper.getPrivacyRoute()),

      MenuModel(icon: Images.terms, title: 'terms_condition'.tr, route: RouteHelper.getTermsRoute()),

      MenuModel(icon: Images.logOut, title: 'logout'.tr, route: ''),

    ];

    if(Get.find<ProfileController>().profileModel!.subscription != null) {
      menuList.insert(10, MenuModel(
        icon: Images.subscription, title: 'my_subscription'.tr, route: RouteHelper.getSubscriptionViewRoute(),
      ));
    }

    if(Get.find<ProfileController>().profileModel!.restaurants![0].selfDeliverySystem == 1) {
      menuList.insert(5, MenuModel(
        icon: Images.deliveryMan, title: 'delivery_man'.tr, route: RouteHelper.getDeliveryManRoute(),
      ));
    }

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
        color: Theme.of(context).cardColor,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: (1/1.2),
            crossAxisSpacing: Dimensions.paddingSizeExtraSmall, mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
          ),
          itemCount: menuList.length,
          itemBuilder: (context, index) {
            return MenuButtonWidget(menu: menuList[index], isProfile: index == 0, isLogout: index == menuList.length-1);
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

      ]),
    );
  }
}