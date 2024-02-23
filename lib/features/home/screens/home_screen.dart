import 'package:stackfood_multivendor_restaurant/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/order_shimmer_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/order_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/controllers/notification_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/controllers/order_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/home/widgets/order_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _loadData() async {
    await Get.find<ProfileController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();
    await Get.find<NotificationController>().getNotificationList();
  }

  final MaterialStateProperty<Icon?> thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
     (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Icon(Icons.circle, color: Get.find<ThemeController>().darkTheme ? Colors.black : Colors.white);
      }
      return Icon(Icons.circle, color: Get.find<ThemeController>().darkTheme ? Colors.white: Colors.black);
    },
  );

  @override
  Widget build(BuildContext context) {

    _loadData();

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Image.asset(Images.logo, height: 30, width: 30),
        ),
        titleSpacing: 0, elevation: 0,
        title: Image.asset(Images.logoName, width: 120),
        actions: [IconButton(
          icon: GetBuilder<NotificationController>(builder: (notificationController) {

            bool hasNewNotification = false;

            if(notificationController.notificationList != null) {
              hasNewNotification = notificationController.notificationList!.length != notificationController.getSeenNotificationCount();
            }

            return Stack(children: [

              Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),

              hasNewNotification ? Positioned(top: 0, right: 0, child: Container(
                height: 10, width: 10, decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                border: Border.all(width: 1, color: Theme.of(context).cardColor),
              ),
              )) : const SizedBox(),

            ]);
          }),
          onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
        )],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await _loadData();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [

            GetBuilder<ProfileController>(builder: (profileController) {
              return Column(children: [

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).cardColor,
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 200]!, spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: Row(children: [

                    Expanded(child: Text(
                      'restaurant_temporarily_closed'.tr, style: robotoMedium,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    )),

                    profileController.profileModel != null ? Switch(
                      thumbIcon: thumbIcon,
                      value: !profileController.profileModel!.restaurants![0].active!,
                      activeColor: Theme.of(context).primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (bool isActive) {
                        Get.dialog(ConfirmationDialogWidget(
                          icon: Images.warning,
                          description: isActive ? 'are_you_sure_to_close_restaurant'.tr : 'are_you_sure_to_open_restaurant'.tr,
                          onYesPressed: () {
                            Get.back();
                            Get.find<AuthController>().toggleRestaurantClosedStatus();
                          },
                        ));
                      },
                    ) : Shimmer(duration: const Duration(seconds: 2), child: Container(height: 30, width: 50, color: Colors.grey[300])),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(children: [

                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                      Image.asset(Images.wallet, width: 60, height: 60),
                      const SizedBox(width: Dimensions.paddingSizeLarge),

                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Text(
                          'today'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text(
                          profileController.profileModel != null ? PriceConverter.convertPrice(profileController.profileModel!.todaysEarning) : '0',
                          style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                        ),

                      ]),

                    ]),
                    const SizedBox(height: 30),

                    Row(children: [

                      Expanded(child: Column(children: [

                        Text(
                          'this_week'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text(
                          profileController.profileModel != null ? PriceConverter.convertPrice(profileController.profileModel!.thisWeekEarning) : '0',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor), textDirection: TextDirection.ltr,
                        ),

                      ])),

                      Container(height: 30, width: 1, color: Theme.of(context).cardColor),

                      Expanded(child: Column(children: [

                        Text(
                          'this_month'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text(
                          profileController.profileModel != null ? PriceConverter.convertPrice(profileController.profileModel!.thisMonthEarning) : '0',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),textDirection: TextDirection.ltr,
                        ),

                      ])),

                    ]),

                  ]),
                ),
              ]);
            }),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            GetBuilder<OrderController>(builder: (orderController) {

              List<OrderModel> orderList = [];

              if(orderController.runningOrders != null) {
                orderList = orderController.runningOrders![orderController.orderIndex].orderList;
              }

              return Column(children: [

                orderController.runningOrders != null ? Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: orderController.runningOrders!.length,
                    itemBuilder: (context, index) {
                      return OrderButtonWidget(
                        title: orderController.runningOrders![index].status.tr, index: index,
                        orderController: orderController, fromHistory: false,
                      );
                    },
                  ),
                ) : const SizedBox(),

                Row(children: [

                  orderController.runningOrders != null ? InkWell(
                    onTap: () => orderController.toggleCampaignOnly(),
                    child: Row(children: [
                      Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        value: orderController.campaignOnly,
                        onChanged: (isActive) => orderController.toggleCampaignOnly(),
                      ),
                      Text(
                        'campaign_order'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      ),
                    ]),
                  ) : const SizedBox(),

                  orderController.runningOrders != null ? InkWell(
                    onTap: () => orderController.toggleSubscriptionOnly(),
                    child: Row(children: [
                      Checkbox(
                        activeColor: Theme.of(context).primaryColor,
                        value: orderController.subscriptionOnly,
                        onChanged: (isActive) => orderController.toggleSubscriptionOnly(),
                      ),
                      Text(
                        'subscription_order'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      ),
                    ]),
                  ) : const SizedBox(),

                ]),

                orderController.runningOrders != null ? orderList.isNotEmpty ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    return OrderWidget(orderModel: orderList[index], hasDivider: index != orderList.length-1, isRunning: true);
                  },
                ) : Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(child: Text('no_order_found'.tr)),
                ) : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return OrderShimmerWidget(isEnabled: orderController.runningOrders == null);
                  },
                ),

              ]);
            }),

          ]),
        ),
      ),
    );
  }
}