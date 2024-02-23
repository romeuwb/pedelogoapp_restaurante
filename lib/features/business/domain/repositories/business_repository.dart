import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/business_plan_model.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/repositories/business_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class BusinessRepository implements BusinessRepositoryInterface<PackageModel> {
  final ApiClient apiClient;
  BusinessRepository({required this.apiClient});

  @override
  Future<PackageModel?> getList() async {
    PackageModel? packageModel;
    Response response = await apiClient.getData(AppConstants.restaurantPackagesUri);
    if(response.statusCode == 200) {
      packageModel = PackageModel.fromJson(response.body);
    }
    return packageModel;
  }

  @override
  Future<Response> setUpBusinessPlan(BusinessPlanModel businessPlanModel) async {
    return await apiClient.postData(AppConstants.businessPlanUri, businessPlanModel.toJson());
  }

  @override
  Future<Response> subscriptionPayment(String id, String? paymentName) async {
    return await apiClient.postData(AppConstants.businessPlanPaymentUri, {'id': id, 'payment_gateway': paymentName});
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete({int? id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }

}