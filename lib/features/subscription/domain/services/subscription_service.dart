import 'package:stackfood_multivendor_restaurant/features/subscription/domain/repositories/subscription_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/subscription/domain/services/subscription_service_interface.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class SubscriptionService implements SubscriptionServiceInterface {
  final SubscriptionRepositoryInterface subscriptionRepositoryInterface;
  SubscriptionService({required this.subscriptionRepositoryInterface});

  @override
  Future<Response> renewBusinessPlan(Map<String, String> body, Map<String, String>? headers) async{
   return await subscriptionRepositoryInterface.renewBusinessPlan(body, headers);
  }

}