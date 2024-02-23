import 'dart:convert';
import 'package:stackfood_multivendor_restaurant/common/screens/payment_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/business/screens/payment_successful_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/screens/campaign_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/screens/campaign_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/category/screens/category_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/domain/models/campaign_model.dart';
import 'package:stackfood_multivendor_restaurant/features/category/domain/models/category_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/dashboard/screens/dashboard_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/domain/models/delivery_man_model.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/screens/add_delivery_man_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/screens/delivery_man_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/deliveryman/screens/delivery_man_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/screens/add_withdraw_method_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/screens/disbursement_menu_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/screens/disbursement_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/disbursement/screens/withdraw_method_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/expense/screens/expense_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/screens/forget_pass_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/screens/new_pass_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/screens/verification_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/html/screens/html_viewer_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/language/screens/language_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/notification/screens/notification_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/order_model.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/screens/bank_info_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/screens/payment_history_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/screens/wallet_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/screens/withdraw_request_history_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/order/screens/order_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/pos/screens/pos_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/screens/addon_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/screens/restaurant_registration_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/screens/sign_in_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/screens/chat_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/screens/conversation_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/coupon/screens/coupon_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/screens/profile_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/screens/update_profile_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/campaign/screens/campaign_report_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/food/screens/food_report_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/order/screens/order_report_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/reports_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/transaction/screens/transaction_report_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/add_name_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/add_product_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/announcement_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/product_details_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/restaurant_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/screens/restaurant_settings_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/screens/splash_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/screens/renew_subscription_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/screens/subscription_view_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/update/screens/update_screen.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String signIn = '/sign-in';
  static const String verification = '/verification';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String notification = '/notification';
  static const String bankInfo = '/bank-info';
  static const String wallet = '/wallet';
  static const String withdrawHistory = '/withdraw-history';
  static const String restaurant = '/restaurant';
  static const String campaign = '/campaign';
  static const String campaignDetails = '/campaign-details';
  static const String product = '/product';
  static const String addProduct = '/add-product';
  static const String categories = '/categories';
  static const String subCategories = '/sub-categories';
  static const String restaurantSettings = '/restaurant-settings';
  static const String addons = '/addons';
  static const String productDetails = '/product-details';
  static const String pos = '/pos';
  static const String deliveryMan = '/delivery-man';
  static const String addDeliveryMan = '/add-delivery-man';
  static const String deliveryManDetails = '/delivery-man-details';
  static const String terms = '/terms-and-condition';
  static const String privacy = '/privacy-policy';
  static const String update = '/update';
  static const String chatScreen = '/chat-screen';
  static const String conversationListScreen = '/chat-list-screen';
  static const String restaurantRegistration = '/restaurant-registration';
  static const String subscriptionView = '/subscriptionView';
  static const String renewSubscription = '/renew-subscription';
  static const String coupon = '/coupon';
  static const String expense = '/expense';
  static const String payment = '/payment';
  static const String success = '/success';
  static const String announcement = '/announcement';
  static const String transactionReport = '/transaction-report';
  static const String orderReport = '/order-report';
  static const String foodReport = '/food-report';
  static const String campaignReport = '/campaign-report';
  static const String disbursement = '/disbursement';
  static const String withdrawMethod = '/withdraw-method';
  static const String addWithdrawMethod = '/add-withdraw-method';
  static const String paymentHistory = '/payment-history';
  static const String reports = '/reports';
  static const String disbursementMenu = '/disbursement-menu';



  static String getInitialRoute() => initial;
  static String getSplashRoute(NotificationBodyModel? body) {
    String data = 'null';
    if(body != null) {
      List<int> encoded = utf8.encode(jsonEncode(body.toJson()));
      data = base64Encode(encoded);
    }
    return '$splash?data=$data';
  }
  static String getLanguageRoute(String page) => '$language?page=$page';
  static String getSignInRoute() => signIn;
  static String getVerificationRoute(String email) => '$verification?email=$email';
  static String getMainRoute(String page) => '$main?page=$page';
  static String getForgotPassRoute() => forgotPassword;
  static String getResetPasswordRoute(String? phone, String token, String page) => '$resetPassword?phone=$phone&token=$token&page=$page';
  static String getOrderDetailsRoute(int? orderID) => '$orderDetails?id=$orderID';
  static String getProfileRoute() => profile;
  static String getUpdateProfileRoute() => updateProfile;
  static String getNotificationRoute({bool fromNotification = false}) => '$notification?from_notification=${fromNotification.toString()}';
  static String getBankInfoRoute() => bankInfo;
  static String getWalletRoute() => wallet;
  static String getWithdrawHistoryRoute() => withdrawHistory;
  static String getRestaurantRoute() => restaurant;
  static String getCampaignRoute() => campaign;
  static String getCampaignDetailsRoute(int? id) => '$campaignDetails?id=$id';
  static String getUpdateRoute(bool willUpdate) => '$update?update=${willUpdate.toString()}';
  static String getProductRoute(Product? productModel) {
    if(productModel == null) {
      return '$product?data=null';
    }
    List<int> encoded = utf8.encode(jsonEncode(productModel.toJson()));
    String data = base64Encode(encoded);
    return '$product?data=$data';
  }
  static String getAddProductRoute(Product? productModel, List<Translation> translations) {
    String translations0 = base64Encode(utf8.encode(jsonEncode(translations)));
    if(productModel == null) {
      return '$addProduct?data=null&translations=$translations0';
    }
    String data = base64Encode(utf8.encode(jsonEncode(productModel.toJson())));
    return '$addProduct?data=$data&translations=$translations0';
  }
  static String getCategoriesRoute() => categories;
  static String getCouponRoute() => coupon;
  static String getSubCategoriesRoute(CategoryModel categoryModel) {
    List<int> encoded = utf8.encode(jsonEncode(categoryModel.toJson()));
    String data = base64Encode(encoded);
    return '$subCategories?data=$data';
  }
  static String getRestaurantSettingsRoute(Restaurant restaurant) {
    List<int> encoded = utf8.encode(jsonEncode(restaurant.toJson()));
    String data = base64Encode(encoded);
    return '$restaurantSettings?data=$data';
  }
  static String getAddonsRoute() => addons;
  static String getProductDetailsRoute(Product product) {
    List<int> encoded = utf8.encode(jsonEncode(product.toJson()));
    String data = base64Encode(encoded);
    return '$productDetails?data=$data';
  }
  static String getPosRoute() => pos;
  static String getDeliveryManRoute() => deliveryMan;
  static String getAddDeliveryManRoute(DeliveryManModel? deliveryMan) {
    if(deliveryMan == null) {
      return '$addDeliveryMan?data=null';
    }
    List<int> encoded = utf8.encode(jsonEncode(deliveryMan.toJson()));
    String data = base64Encode(encoded);
    return '$addDeliveryMan?data=$data';
  }
  static String getDeliveryManDetailsRoute(DeliveryManModel deliveryMan) {
    List<int> encoded = utf8.encode(jsonEncode(deliveryMan.toJson()));
    String data = base64Encode(encoded);
    return '$deliveryManDetails?data=$data';
  }
  static String getTermsRoute() => terms;
  static String getPrivacyRoute() => privacy;
  static String getChatRoute({required NotificationBodyModel? notificationBody, User? user, int? conversationId}) {
    
    String notificationBody0 = 'null';
    String user0 = 'null';
    
    if(notificationBody != null) {
      notificationBody0 = base64Encode(utf8.encode(jsonEncode(notificationBody)));
    }
    if(user != null) {
      user0 = base64Encode(utf8.encode(jsonEncode(user.toJson())));
    }
    return '$chatScreen?notification_body=$notificationBody0&user=$user0&conversation_id=$conversationId';
  }
  static String getConversationListRoute() => conversationListScreen;
  static String getRestaurantRegistrationRoute() => restaurantRegistration;
  static String getSubscriptionViewRoute() => subscriptionView;
  static String getRenewSubscriptionRoute() => renewSubscription;
  static String getExpenseRoute() => expense;
  static String getPaymentRoute(String? paymentMethod, String? redirectUrl) {
    return '$payment?payment-method=$paymentMethod&redirect-url=$redirectUrl';
  }
  static String getSuccessRoute(String status, {bool isWalletPayment = false}) => '$success?status=$status&is_wallet_payment=${isWalletPayment.toString()}';

  static String getAnnouncementRoute({required int announcementStatus, required announcementMessage}){
    return '$announcement?announcement_status=$announcementStatus&announcement_message=$announcementMessage';
  }
  static String getTransactionReportRoute() => transactionReport;
  static String getOrderReportRoute() => orderReport;
  static String getFoodReportRoute() => foodReport;
  static String getCampaignReportRoute() => campaignReport;
  static String getDisbursementRoute() => disbursement;
  static String getWithdrawMethodRoute({bool isFromDashBoard = false}) => '$withdrawMethod?from_dashboard=$isFromDashBoard';
  static String getAddWithdrawMethodRoute() => addWithdrawMethod;
  static String getPaymentHistoryRoute() => paymentHistory;
  static String getReportsRoute() => reports;
  static String getDisbursementMenuRoute() => disbursementMenu;


  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const DashboardScreen(pageIndex: 0)),
    GetPage(name: splash, page: () {
      NotificationBodyModel? data;
      if(Get.parameters['data'] != 'null') {
        List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
        data = NotificationBodyModel.fromJson(jsonDecode(utf8.decode(decode)));
      }
      return SplashScreen(body: data);
    }),
    GetPage(name: language, page: () => LanguageScreen(fromMenu: Get.parameters['page'] == 'menu')),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: verification, page: () => VerificationScreen(email: Get.parameters['email'])),
    GetPage(name: main, page: () => DashboardScreen(
      pageIndex: Get.parameters['page'] == 'home' ? 0 : Get.parameters['page'] == 'favourite' ? 1
          : Get.parameters['page'] == 'cart' ? 2 : Get.parameters['page'] == 'order' ? 3 : Get.parameters['page'] == 'menu' ? 4 : 0,
    )),
    GetPage(name: forgotPassword, page: () => const ForgetPassScreen()),
    GetPage(name: resetPassword, page: () => NewPassScreen(
      resetToken: Get.parameters['token'], email: Get.parameters['phone'], fromPasswordChange: Get.parameters['page'] == 'password-change',
    )),
    GetPage(name: orderDetails, page: () {
      return Get.arguments ?? OrderDetailsScreen(
        orderModel: OrderModel(id: int.parse(Get.parameters['id']!)), isRunningOrder: false,
      );
    }),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: updateProfile, page: () => UpdateProfileScreen()),
    GetPage(name: notification, page: () => NotificationScreen(fromNotification: Get.parameters['from_notification'] == 'true')),
    GetPage(name: bankInfo, page: () => const BankInfoScreen()),
    GetPage(name: wallet, page: () => const WalletScreen()),
    GetPage(name: withdrawHistory, page: () => const WithdrawRequestHistoryScreen()),
    GetPage(name: restaurant, page: () => const RestaurantScreen()),
    GetPage(name: campaign, page: () => const CampaignScreen()),
    GetPage(name: campaignDetails, page: () {
      return Get.arguments ?? CampaignDetailsScreen(
        campaignModel: CampaignModel(id: int.parse(Get.parameters['id']!)),
      );
    }),
    GetPage(name: product, page: () {
      if(Get.parameters['data'] == 'null') {
        return const AddNameScreen(product: null);
      }
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Product data = Product.fromJson(jsonDecode(utf8.decode(decode)));
      return AddNameScreen(product: data);
    }),
    GetPage(name: addProduct, page: () {
      List<Translation> translations = [];
      jsonDecode(utf8.decode(base64Decode(Get.parameters['translations']!.replaceAll(' ', '+')))).forEach((data) {
        translations.add(Translation.fromJson(data));
      });
      if(Get.parameters['data'] == 'null') {
        return AddProductScreen(product: null, translations: translations);
      }
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Product data = Product.fromJson(jsonDecode(utf8.decode(decode)));
      return AddProductScreen(product: data, translations: translations);
    }),
    GetPage(name: categories, page: () => const CategoryScreen(categoryModel: null)),
    GetPage(name: subCategories, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      CategoryModel data = CategoryModel.fromJson(jsonDecode(utf8.decode(decode)));
      return CategoryScreen(categoryModel: data);
    }),
    GetPage(name: restaurantSettings, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Restaurant data = Restaurant.fromJson(jsonDecode(utf8.decode(decode)));
      return RestaurantSettingsScreen(restaurant: data);
    }),
    GetPage(name: addons, page: () => const AddonScreen()),
    GetPage(name: productDetails, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      Product data = Product.fromJson(jsonDecode(utf8.decode(decode)));
      return ProductDetailsScreen(product: data);
    }),
    GetPage(name: pos, page: () => const PosScreen()),
    GetPage(name: deliveryMan, page: () => const DeliveryManScreen()),
    GetPage(name: addDeliveryMan, page: () {
      if(Get.parameters['data'] == 'null') {
        return const AddDeliveryManScreen(deliveryMan: null);
      }
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      DeliveryManModel data = DeliveryManModel.fromJson(jsonDecode(utf8.decode(decode)));
      return AddDeliveryManScreen(deliveryMan: data);
    }),
    GetPage(name: deliveryManDetails, page: () {
      List<int> decode = base64Decode(Get.parameters['data']!.replaceAll(' ', '+'));
      DeliveryManModel data = DeliveryManModel.fromJson(jsonDecode(utf8.decode(decode)));
      return DeliveryManDetailsScreen(deliveryMan: data);
    }),
    GetPage(name: terms, page: () => const HtmlViewerScreen(isPrivacyPolicy: false)),
    GetPage(name: privacy, page: () => const HtmlViewerScreen(isPrivacyPolicy: true)),
    GetPage(name: update, page: () => UpdateScreen(willUpdate: Get.parameters['update'] == 'true')),
    GetPage(name: chatScreen, page: () {
      
      NotificationBodyModel? notificationBody;
      if(Get.parameters['notification_body'] != 'null') {
        notificationBody = NotificationBodyModel.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['notification_body']!.replaceAll(' ', '+')))));
      }
      User? user;
      if(Get.parameters['user'] != 'null') {
        user = User.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['user']!.replaceAll(' ', '+')))));
      }
      return ChatScreen(
        notificationBody : notificationBody, user: user,
        conversationId: Get.parameters['conversation_id'] != null && Get.parameters['conversation_id'] != 'null' ? int.parse(Get.parameters['conversation_id']!) : null,
      );
    }),
    GetPage(name: conversationListScreen, page: () => const ConversationScreen()),
    GetPage(name: restaurantRegistration, page: () => const RestaurantRegistrationScreen()),
    GetPage(name: subscriptionView, page: () => const SubscriptionViewScreen()),
    GetPage(name: renewSubscription, page: () => const RenewSubscriptionScreen()),
    GetPage(name: coupon, page: () => const CouponScreen()),
    GetPage(name: expense, page: () => const ExpenseScreen()),
    GetPage(name: payment, page: () {
      String paymentMethod = Get.parameters['payment-method']!;
      String addFundUrl = Get.parameters['redirect-url']!;
      return PaymentScreen(paymentMethod: paymentMethod, redirectUrl: addFundUrl);
    }),
    GetPage(name: success, page: () => PaymentSuccessfulScreen(success: Get.parameters['status'] == 'success', isWalletPayment: Get.parameters['is_wallet_payment'] == 'true')),
    GetPage(name: announcement, page: () => AnnouncementScreen(
      announcementStatus: int.parse(Get.parameters['announcement_status']!), announcementMessage: Get.parameters['announcement_message']!,
    )),
    GetPage(name: transactionReport, page: () => const TransactionReportScreen()),
    GetPage(name: orderReport, page: () => const OrderReportScreen()),
    GetPage(name: foodReport, page: () => const FoodReportScreen()),
    GetPage(name: campaignReport, page: () => const CampaignReportScreen()),
    GetPage(name: disbursement, page: () => const DisbursementScreen()),
    GetPage(name: withdrawMethod, page: () => WithdrawMethodScreen(isFromDashboard: Get.parameters['from_dashboard'] == 'true')),
    GetPage(name: addWithdrawMethod, page: () => const AddWithDrawMethodScreen()),
    GetPage(name: paymentHistory, page: () => const PaymentHistoryScreen()),
    GetPage(name: reports, page: () => const ReportsScreen()),
    GetPage(name: disbursementMenu, page: () => const DisbursementMenuScreen()),
  ];
}