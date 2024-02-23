import 'package:stackfood_multivendor_restaurant/features/business/domain/models/business_plan_model.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/models/package_model.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/repositories/business_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/business/domain/services/business_service_interface.dart';
import 'package:get/get.dart';

class BusinessService implements BusinessServiceInterface {
  final BusinessRepositoryInterface businessRepositoryInterface;
  BusinessService({required this.businessRepositoryInterface});

  @override
  Future<PackageModel?> getPackageList() async {
    return await businessRepositoryInterface.getList();
  }

  @override
  Future<Response> setUpBusinessPlan(BusinessPlanModel businessPlanModel) async {
    return await businessRepositoryInterface.setUpBusinessPlan(businessPlanModel);
  }

  @override
  Future<Response> subscriptionPayment(String id, String? paymentName) async {
    return await businessRepositoryInterface.subscriptionPayment(id, paymentName);
  }

}