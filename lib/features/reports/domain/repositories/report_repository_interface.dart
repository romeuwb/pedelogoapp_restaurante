import 'package:stackfood_multivendor_restaurant/interface/repository_interface.dart';

abstract class ReportRepositoryInterface implements RepositoryInterface{
  Future<dynamic> getTransactionReportList({required int offset, required String? from, required String? to});
  Future<dynamic> getOrderReportList({required int offset, required String? from, required String? to});
  Future<dynamic> getCampaignReportList({required int offset, required String? from, required String? to});
  Future<dynamic> getFoodReportList({required int offset, required String? from, required String? to});
}