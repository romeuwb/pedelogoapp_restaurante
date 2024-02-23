import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/business/widgets/show_modal_bottom_sheet_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/business_plan_model.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/services/business_service_interface.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';

class BusinessController extends GetxController implements GetxService {
  final BusinessServiceInterface businessServiceInterface;
  BusinessController({required this.businessServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  PackageModel? _packageModel;
  PackageModel? get packageModel => _packageModel;

  String _businessPlanStatus = 'business';
  String get businessPlanStatus => _businessPlanStatus;

  int _activeSubscriptionIndex = 0;
  int get activeSubscriptionIndex => _activeSubscriptionIndex;

  int _businessIndex = Get.find<SplashController>().configModel!.businessPlan != null && Get.find<SplashController>().configModel!.businessPlan!.commission == 0 ? 1 : 0;
  int get businessIndex => _businessIndex;

  bool isFirstTime = true;

  int _paymentIndex = 0;
  int get paymentIndex => _paymentIndex;

  String? _digitalPaymentName;
  String? get digitalPaymentName => _digitalPaymentName;

  String? _subscribedType;


  Future<void> getPackageList() async {
    PackageModel? packageModel = await businessServiceInterface.getPackageList();
    if(packageModel != null) {
      _packageModel = null;
      _packageModel = packageModel;
    }
    update();
  }

  void setBusinessStatus(String status, {bool canUpdate = true}){
    _businessPlanStatus = status;
    if(canUpdate) {
      update();
    }
  }

  void setBusiness(int business, {bool canUpdate = true}){
    _activeSubscriptionIndex = 0;
    _businessIndex = business;
    if(canUpdate) {
      update();
    }
  }

  void resetBusiness(){
    _businessIndex = (Get.find<SplashController>().configModel!.businessPlan != null && Get.find<SplashController>().configModel!.businessPlan!.commission == 0) ? 1 : 0;
    _activeSubscriptionIndex = 0;
    _businessPlanStatus = 'business';
    isFirstTime = true;
    _paymentIndex = Get.find<SplashController>().configModel!.freeTrialPeriodStatus == 0 ? 1 : 0;
  }

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

  void setPaymentIndex(int index, {bool willUpdate = true}){
    _paymentIndex = index;
    if(willUpdate) {
      update();
    }
  }

  Future<void> submitBusinessPlan(int? restaurantId, String? paymentId) async {
    String businessPlan;
    if(businessIndex == 0){
      businessPlan = 'commission';
      if(restaurantId != null) {
        setUpBusinessPlan(BusinessPlanModel(businessPlan: businessPlan, restaurantId: restaurantId.toString(), type: _subscribedType));
      }else{
        showCustomSnackBar('restaurant_id_not_provided'.tr);
      }
    } else if(paymentId != null) {
      if(_paymentIndex == 1 && digitalPaymentName == null) {
        customShowModalBottomSheet();
      } else {
        _subscriptionPayment(paymentId);
      }
    } else{
      _businessPlanStatus = 'payment';
      if(!isFirstTime) {
        if (_businessPlanStatus == 'payment') {
          businessPlan = 'subscription';
          int? packageId = _packageModel!.packages![_activeSubscriptionIndex].id;
          String payment = _paymentIndex == 0 ? 'free_trial' : 'paying_now';
          if(restaurantId != null) {
            if(_paymentIndex == 1 && digitalPaymentName == null) {
              customShowModalBottomSheet();
            } else {
              setUpBusinessPlan(BusinessPlanModel(
                businessPlan: businessPlan,
                packageId: packageId.toString(),
                restaurantId: restaurantId.toString(),
                payment: payment, type: _subscribedType,
              ));
            }

          }else{
            showCustomSnackBar('Restaurant id not provider');
          }
        } else {
          showCustomSnackBar('please_select_any_process'.tr);
        }
      }else{
        isFirstTime = false;
      }
    }
    update();
  }

  Future<ResponseModel> setUpBusinessPlan(BusinessPlanModel businessPlanBody) async {
    _isLoading = true;
    update();
    Response response = await businessServiceInterface.setUpBusinessPlan(businessPlanBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if(response.body['id'] != null) {
        _subscriptionPayment(response.body['id']);
      } else {
        _businessPlanStatus = 'complete';
        showCustomSnackBar(response.body['message'], isError: false);
        Future.delayed(const Duration(seconds: 2),()=> Get.offAllNamed(RouteHelper.getSignInRoute()));
      }
      responseModel = ResponseModel(true, response.body.toString());
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> _subscriptionPayment(String id) async {
    _isLoading = true;
    update();
    Response response = await businessServiceInterface.subscriptionPayment(id, digitalPaymentName!);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      String redirectUrl = response.body['redirect_link'];
      Get.back();
      if(GetPlatform.isWeb) {
        // html.window.open(redirectUrl,"_self");
      } else{
        Get.toNamed(RouteHelper.getPaymentRoute(digitalPaymentName, redirectUrl));
      }
      responseModel = ResponseModel(true, response.body.toString());
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }


}