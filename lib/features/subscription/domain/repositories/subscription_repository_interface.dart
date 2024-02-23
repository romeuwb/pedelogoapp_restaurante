import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class SubscriptionRepositoryInterface implements RepositoryInterface {
  Future<dynamic> renewBusinessPlan(Map<String, String> body, Map<String, String>? headers);
}