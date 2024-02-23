import 'package:file_picker/file_picker.dart';
import 'package:stackfood_multivendor_restaurant/common/models/config_model.dart';
import 'package:stackfood_multivendor_restaurant/common/models/response_model.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/domain/services/auth_service_interface.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/features/business/screens/business_plan_screen.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepoInterface;
  AuthService({required this.authRepoInterface});

  @override
  Future<Response> login(String? email, String password) async {
    return await authRepoInterface.login(email, password);
  }

  @override
  Future<bool> saveUserToken(String token, String zoneTopic) async {
    return await authRepoInterface.saveUserToken(token, zoneTopic);
  }

  @override
  Future<Response> updateToken({String notificationDeviceToken = ''}) async {
    return await authRepoInterface.updateToken(notificationDeviceToken: notificationDeviceToken);
  }

  @override
  bool isLoggedIn() {
    return authRepoInterface.isLoggedIn();
  }

  @override
  Future<bool> clearSharedData() async {
    return await authRepoInterface.clearSharedData();
  }

  @override
  Future<void> saveUserCredentials(String number, String password) async {
    return await authRepoInterface.saveUserCredentials(number, password);
  }

  @override
  String getUserNumber() {
    return authRepoInterface.getUserNumber();
  }

  @override
  String getUserPassword() {
    return authRepoInterface.getUserPassword();
  }

  @override
  Future<bool> clearUserCredentials() async {
    return await authRepoInterface.clearUserCredentials();
  }

  @override
  String getUserToken() {
    return authRepoInterface.getUserToken();
  }

  @override
  void setNotificationActive(bool isActive) {
    authRepoInterface.setNotificationActive(isActive);
  }

  @override
  Future<bool> toggleRestaurantClosedStatus() async {
    return await authRepoInterface.toggleRestaurantClosedStatus();
  }

  @override
  Future<bool> deleteVendor() async {
    return await authRepoInterface.delete();
  }

  @override
  Future<Response> registerRestaurant(Map<String, String> data, XFile? logo, XFile? cover, List<MultipartDocument> additionalDocument) async {
    Response response = await authRepoInterface.registerRestaurant(data, logo, cover, additionalDocument);
    if(response.statusCode == 200) {
      int? restaurantId = response.body['restaurant_id'];
      Get.off(() => BusinessPlanScreen(restaurantId: restaurantId));
    }
    return response;
  }

  @override
  Future<FilePickerResult?> picFile(MediaData mediaData) async{
    List<String> permission = [];
    if(mediaData.image == 1) {
      permission.add('jpg');
    }
    if(mediaData.pdf == 1) {
      permission.add('pdf');
    }
    if(mediaData.docs == 1) {
      permission.add('doc');
    }

    FilePickerResult? result;

    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: permission,
      allowMultiple: false,
    );
    if(result != null && result.files.isNotEmpty) {
      if(result.files.single.size > 2000000) {
        result = null;
        showCustomSnackBar('please_upload_lower_size_file'.tr);
      } else {
        return result;
      }
    }
    return result;
  }

  @override
  Future<XFile?> pickImageFromGallery() async{
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickImage != null) {
      pickImage.length().then((value) {
        if (value > 2000000) {
          showCustomSnackBar('please_upload_lower_size_file'.tr);
        } else {
          return pickImage;
        }
      });
    }
    return pickImage;
  }

  @override
  List<MultipartDocument> prepareMultipartDocuments(List<String> inputTypeList, List<FilePickerResult> additionalDocuments){
    List<MultipartDocument> multiPartsDocuments = [];
    List<String> dataName = [];
    for(String data in inputTypeList) {
      dataName.add('additional_documents[$data]');
    }
    for(FilePickerResult file in additionalDocuments) {
      int index = additionalDocuments.indexOf(file);
      multiPartsDocuments.add(MultipartDocument('${dataName[index]}[]', file));
    }
    return multiPartsDocuments;
  }

  @override
  Future<ResponseModel?> manageLogin(Response response, int? subscription) async {
    ResponseModel? responseModel;
    if (response.statusCode == 200) {
      if(response.body['pending_payment'] != null) {
        Get.to(BusinessPlanScreen(restaurantId: null, paymentId: response.body['pending_payment']['id']));
      } else if(response.body['subscribed'] != null){
        int? restaurantId = response.body['subscribed']['restaurant_id'];
        Get.to(()=> BusinessPlanScreen(restaurantId: restaurantId));
        responseModel = ResponseModel(false, 'no');
      }else{
        saveUserToken(response.body['token'], response.body['zone_wise_topic']);
        await updateToken();
        responseModel = ResponseModel(true, 'successful');
      }
    } else if(response.statusCode == 205){
      if(subscription == 1){
        Get.toNamed(RouteHelper.getSubscriptionViewRoute());
      }else{
        responseModel = ResponseModel(false, 'subscription_not_available_please_contact_with_admin'.tr);
      }
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  String? getSubscriptionType (Response response) {
    String? subscriptionType;
    if (response.statusCode == 200 && response.body['subscribed'] != null) {
      subscriptionType = response.body['subscribed']['type'];
    }
    return subscriptionType;
  }

  @override
  String? getExpiredToken (Response response, int? subscription) {
    String? expiredToken;
    if(response.statusCode == 205 && subscription == 1) {
      expiredToken = response.body['token'];
    }
    return expiredToken;
  }

  @override
  ProfileModel? getProfileModel(Response response, int? subscription) {
    ProfileModel? profileModel;
    if(response.statusCode == 205 && subscription == 1) {
      profileModel = ProfileModel(
        restaurants: [Restaurant(id: int.parse(response.body['restaurant_id'].toString()))],
        balance: response.body['balance']?.toDouble(),
        subscription: Subscription.fromJson(response.body['subscription']),
        subscriptionOtherData: SubscriptionOtherData.fromJson(response.body['subscription_other_data']),
      );
    }
    return profileModel;
  }

}