abstract class ReportServiceInterface {
  Future<dynamic> getTransactionReportList({required int offset, required String? from, required String? to});
  Future<dynamic> getOrderReportList({required int offset, required String? from, required String? to});
  Future<dynamic> getCampaignReportList({required int offset, required String? from, required String? to});
  Future<dynamic> getFoodReportList({required int offset, required String? from, required String? to});
}