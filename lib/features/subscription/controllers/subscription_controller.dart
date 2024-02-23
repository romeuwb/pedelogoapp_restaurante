import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/business/controllers/business_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/domain/services/subscription_service_interface.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';

class SubscriptionController extends GetxController implements GetxService {
  final SubscriptionServiceInterface subscriptionServiceInterface;
  SubscriptionController({required this.subscriptionServiceInterface});

  int _activeSubscriptionIndex = 0;
  int get activeSubscriptionIndex => _activeSubscriptionIndex;

  String _renewStatus = 'packages';
  String get renewStatus => _renewStatus;

  bool? _isActivePackage;
  bool? get isActivePackage => _isActivePackage;

  String? _expiredToken;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PackageModel? _packageModel;
  PackageModel? get packageModel => _packageModel;

  bool _showSubscriptionAlertDialog = true;
  bool get showSubscriptionAlertDialog => _showSubscriptionAlertDialog;

  int _paymentIndex = 0;
  int get paymentIndex => _paymentIndex;

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  String? _digitalPaymentName;
  String? get digitalPaymentName => _digitalPaymentName;

  void changeDigitalPaymentName(String? name, {bool canUpdate = true}){
    _digitalPaymentName = name;
    if(canUpdate) {
      update();
    }
  }

  void selectSubscriptionCard(int index){
    _activeSubscriptionIndex = index;
    update();
  }

  void renewChangePackage(String statusPackage){
    _renewStatus = statusPackage;
    update();
  }

  void initializeRenew(){
    _renewStatus = 'packages';
    _isActivePackage = true;
    _paymentIndex = 0;
  }

  void activePackage(bool status){
    _isActivePackage = status;
    update();
  }

  void setPaymentIndex(int index){
    _paymentIndex = index;
    update();
  }

  void showAlert({bool willUpdate = false}){
    _showSubscriptionAlertDialog = !_showSubscriptionAlertDialog;
    if(willUpdate){
      update();
    }
  }

  void closeAlertDialog(){
    if(_showSubscriptionAlertDialog) {
      _showSubscriptionAlertDialog = !_showSubscriptionAlertDialog;
      update();
    }
  }

  Future<ResponseModel?> renewBusinessPlan(String restaurantId) async {
    _isLoading = true;
    update();
    int? packageId = _packageModel!.packages![_activeSubscriptionIndex].id;
    Map<String, String> body = {
      'package_id' : packageId.toString(),
      'restaurant_id': restaurantId,
      'type': _isActivePackage! ? 'renew' : 'null',
      'payment_type': _paymentIndex == 0 ? 'wallet' : 'pay_now',
      'payment_method': _digitalPaymentName??'',
      'payment_gateway': _digitalPaymentName??'',
      // 'callback': RouteHelper.signIn,
    };
    Map<String, String>? header;
    if(_expiredToken != null){
      header = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_expiredToken'
      };
    }
    Response response = await subscriptionServiceInterface.renewBusinessPlan(body, header);
    ResponseModel? responseModel;
    if (response.statusCode == 200) {
      if(response.body['redirect_link'] != null) {
        String redirectUrl = response.body['redirect_link'];
        Get.back();
        if(GetPlatform.isWeb) {
          // html.window.open(redirectUrl,"_self");
        } else{
          Get.toNamed(RouteHelper.getPaymentRoute(digitalPaymentName, redirectUrl));
        }
      } else {
        _renewStatus = 'packages';
        await Get.find<ProfileController>().getProfile();
        getProfile(Get.find<ProfileController>().profileModel);
        Get.back();
        showCustomSnackBar(response.body['message'], isError: false);
      }
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> getPackageList() async {
    if(Get.find<BusinessController>().packageModel == null || Get.find<BusinessController>().packageModel!.packages!.isEmpty) {
      await Get.find<BusinessController>().getPackageList();
    }
    _packageModel = Get.find<BusinessController>().packageModel;
    update();
  }

  Future<void> getProfile(ProfileModel? proModel) async {
    _profileModel = proModel;
  }

}