import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/product_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/widgets/review_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> with TickerProviderStateMixin {

  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  final bool? _review = Get.find<ProfileController>().profileModel!.restaurants![0].reviewsSection;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _review! ? 2 : 1, initialIndex: 0, vsync: this);
    _tabController!.addListener(() {
      Get.find<RestaurantController>().setTabIndex(_tabController!.index);
    });
    Get.find<RestaurantController>().getProductList('1', 'all');
    Get.find<RestaurantController>().getRestaurantReviewList(Get.find<ProfileController>().profileModel!.restaurants![0].id);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return GetBuilder<ProfileController>(builder: (profileController) {

        bool haveSubscription;

        if(profileController.profileModel!.restaurants![0].restaurantModel == 'subscription'){
          haveSubscription = profileController.profileModel!.subscription!.review == 1;
        }else{
          haveSubscription = true;
        }

        Restaurant? restaurant = profileController.profileModel != null ? profileController.profileModel!.restaurants![0] : null;

        return Scaffold(
          backgroundColor: Theme.of(context).cardColor,

          floatingActionButton: restController.tabIndex == 0 ? FloatingActionButton(
            heroTag: 'nothing',
            onPressed: () {
              if(Get.find<ProfileController>().profileModel!.restaurants![0].foodSection!) {
                if(Get.find<ProfileController>().profileModel!.subscriptionOtherData != null && Get.find<ProfileController>().profileModel!.subscriptionOtherData!.maxProductUpload == 0
                    && Get.find<ProfileController>().profileModel!.restaurants![0].restaurantModel == 'subscription'){
                  showCustomSnackBar('your_food_add_limit_is_over'.tr);
                }else {
                  if (restaurant != null) {
                    Get.toNamed(RouteHelper.getProductRoute(null));
                  }
                }
              }else {
                showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
              }
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add_circle_outline, color: Theme.of(context).cardColor, size: 30),
          ) : null,

          body: restaurant != null ? CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [

              SliverAppBar(
                expandedHeight: 230, toolbarHeight: 50,
                pinned: true, floating: false,
                backgroundColor: Theme.of(context).primaryColor,
                actions: [IconButton(
                  icon: Container(
                    height: 50, width: 50, alignment: Alignment.center,
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                    child: Image.asset(Images.edit),
                  ),
                  onPressed: () => Get.toNamed(RouteHelper.getRestaurantSettingsRoute(restaurant)),
                )],
                flexibleSpace: FlexibleSpaceBar(
                  background: CustomImageWidget(
                    fit: BoxFit.cover, placeholder: Images.restaurantCover,
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}/${restaurant.coverPhoto}',
                  ),
                ),
              ),

              SliverToBoxAdapter(child: Center(child: Container(
                width: 1170,
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                color: Theme.of(context).cardColor,
                child: Column(children: [

                  Row(children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImageWidget(
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl}/${restaurant.logo}',
                        height: 40, width: 50, fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text(
                        restaurant.name!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        restaurant.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      ),

                    ])),

                    InkWell(
                      onTap: () => Get.toNamed(RouteHelper.getAnnouncementRoute(announcementStatus: restaurant.isAnnouncementActive!, announcementMessage: restaurant.announcementMessage ?? '')),
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                          border: Border.all(color: Theme.of(context).cardColor, width: 2),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 1))],
                        ),
                        child: Image.asset(Images.announcementIcon, height: 20, width: 20, color: Theme.of(context).cardColor),
                      ),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Row(children: [

                    Icon(Icons.star, color: Theme.of(context).primaryColor, size: 18),

                    Text(
                      restaurant.avgRating!.toStringAsFixed(1),
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text(
                      '${restaurant.ratingCount ?? 0} ${'ratings'.tr}',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  restaurant.discount != null ? Container(
                    width: context.width,
                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                      Text(
                        '${restaurant.discount!.discount}% ${'off'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ),

                      Text(
                        '${'enjoy'.tr} ${restaurant.discount!.discount}% ${'off_on_all_categories'.tr}',
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ),
                      SizedBox(height: (restaurant.discount!.minPurchase != 0 || restaurant.discount!.maxDiscount != 0) ? 5 : 0),

                      restaurant.discount!.minPurchase != 0 ? Text(
                        '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.minPurchase)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ) : const SizedBox(),

                      restaurant.discount!.maxDiscount != 0 ? Text(
                        '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.maxDiscount)} ]',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                        textDirection: TextDirection.ltr,
                      ) : const SizedBox(),

                    ]),
                  ) : const SizedBox(),

                  (restaurant.delivery! && restaurant.freeDelivery!) ? Text(
                    'free_delivery'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                  ) : const SizedBox(),

                ]),
              ))),

              SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(child: Center(child: Container(
                  width: 1170,
                  decoration: BoxDecoration(color: Theme.of(context).cardColor),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 3,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).disabledColor,
                    unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                    labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                    tabs: _review! ? [
                      Tab(text: 'all_foods'.tr),
                      Tab(text: 'reviews'.tr),
                    ] : [
                      Tab(text: 'all_foods'.tr),
                    ],
                  ),
                ))),
              ),

              SliverToBoxAdapter(child: AnimatedBuilder(
                animation: _tabController!.animation!,
                builder: (context, child) {
                  if (_tabController!.index == 0) {
                    return ProductViewWidget(scrollController: _scrollController, type: restController.type, onVegFilterTap: (String type) {
                      Get.find<RestaurantController>().getProductList('1', type);
                    });
                  } else {
                    return haveSubscription ? restController.restaurantReviewList != null ? restController.restaurantReviewList!.isNotEmpty ? ListView.builder(
                      itemCount: restController.restaurantReviewList!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      itemBuilder: (context, index) {
                        return ReviewWidget(
                          review: restController.restaurantReviewList![index], fromRestaurant: true,
                          hasDivider: index != restController.restaurantReviewList!.length-1,
                        );
                      },
                    ) : Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                      child: Center(child: Text('no_review_found'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor))),
                    ) : const Padding(
                      padding: EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                      child: Center(child: CircularProgressIndicator()),
                    ) : Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Center(child: Text('you_have_no_available_subscription'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor))),
                    );
                  }
                },
              )),
            ],
          ) : const Center(child: CircularProgressIndicator()),
        );
      });
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}