import 'package:stackfood_multivendor_restaurant/features/business/domain/models/business_plan_model.dart';

abstract class BusinessServiceInterface {
  Future<dynamic> getPackageList();
  Future<dynamic> setUpBusinessPlan(BusinessPlanModel businessPlanModel);
  Future<dynamic> subscriptionPayment(String id, String? paymentName);
}