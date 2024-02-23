import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBodyModel? body;
  const SplashScreen({super.key, required this.body});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    _route();

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if(isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          double? minimumVersion = 0;
          if(GetPlatform.isAndroid) {
            minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionAndroid;
          }else if(GetPlatform.isIOS) {
            minimumVersion = Get.find<SplashController>().configModel!.appMinimumVersionIos;
          }
          if(AppConstants.appVersion < minimumVersion! || Get.find<SplashController>().configModel!.maintenanceMode!) {
            Get.offNamed(RouteHelper.getUpdateRoute(AppConstants.appVersion < minimumVersion));
          }else {
            if(widget.body != null) {
              if (widget.body!.notificationType == NotificationType.order) {
                await Get.find<ProfileController>().getProfile();
                Get.offNamed(RouteHelper.getOrderDetailsRoute(widget.body!.orderId));
              }else if(widget.body!.notificationType == NotificationType.general){
                Get.offNamed(RouteHelper.getNotificationRoute(fromNotification: true));
              } else {
                Get.offNamed(RouteHelper.getChatRoute(notificationBody: widget.body, conversationId: widget.body!.conversationId));
              }
            }else{
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.find<AuthController>().updateToken();
                await Get.find<ProfileController>().getProfile();
                Get.offNamed(RouteHelper.getInitialRoute());
              } else {
                if(AppConstants.languages.length > 1 && Get.find<SplashController>().showIntro()) {
                  Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                }else {
                  Get.offNamed(RouteHelper.getSignInRoute());
                }
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Image.asset(Images.logo, width: 100),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Image.asset(Images.logoName, width: 150),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Text('suffix_name'.tr, style: robotoMedium, textAlign: TextAlign.center),

          ]),
        ),
      ),
    );
  }
}