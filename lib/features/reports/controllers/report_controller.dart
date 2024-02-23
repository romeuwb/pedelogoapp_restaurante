import 'package:stackfood_multivendor_restaurant/features/reports/domain/services/report_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/domain/models/report_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController implements GetxService {
  final ReportServiceInterface reportServiceInterface;
  ReportController({required this.reportServiceInterface});

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double? _onHold;
  double? get onHold => _onHold;

  double? _canceled;
  double? get canceled => _canceled;

  double? _completedTransactions;
  double? get completedTransactions => _completedTransactions;

  List<OrderTransactions>? _orderTransactions;
  List<OrderTransactions>? get orderTransactions => _orderTransactions;

  late DateTimeRange _selectedDateRange;

  String? _from;
  String? get from => _from;

  String? _to;
  String? get to => _to;

  OtherData? _otherData;
  OtherData? get otherData => _otherData;

  List<Orders>? _orders;
  List<Orders>? get orders => _orders;

  List<String>? _label;
  List<String>? get label => _label;

  List<double>? _earning;
  List<double>? get earning => _earning;

  double? _earningAvg;
  double? get earningAvg => _earningAvg;

  List<Foods>? _foods;
  List<Foods>? get foods => _foods;

  String? _avgType;
  String? get avgType => _avgType;

  void initSetDate() {
    _from = DateConverter.dateTimeForCoupon(DateTime.now().subtract(const Duration(days: 30)));
    _to = DateConverter.dateTimeForCoupon(DateTime.now());
  }

  Future<void> getTransactionReportList({required String offset, required String? from, required String? to}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _orderTransactions = null;
      update();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      TransactionReportModel? transactionReport = await reportServiceInterface.getTransactionReportList(offset: int.parse(offset), from: from, to: to);
      if (transactionReport != null) {
        TransactionReportModel transactionReportModel = transactionReport;
        _onHold = transactionReportModel.onHold;
        _canceled = transactionReportModel.canceled;
        _completedTransactions = transactionReportModel.completedTransactions;
        if (offset == '1') {
          _orderTransactions = [];
        }
        _orderTransactions!.addAll(transactionReportModel.orderTransactions!);
        _pageSize = transactionReportModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<void> getOrderReportList({required String offset, required String? from, required String? to}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _orders = null;
      update();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      OrderReportModel? orderReport = await reportServiceInterface.getOrderReportList(offset: int.parse(offset), from: from, to: to);
      if (orderReport != null) {
        OrderReportModel orderReportModel = orderReport;
        _otherData = orderReportModel.otherData;
        if (offset == '1') {
          _orders = [];
        }
        _orders!.addAll(orderReportModel.orders!);
        _pageSize = orderReportModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<void> getCampaignReportList({required String offset, required String? from, required String? to}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _orders = null;
      update();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      OrderReportModel? campaignReport = await reportServiceInterface.getCampaignReportList(offset: int.parse(offset), from: from, to: to);
      if (campaignReport != null) {
        OrderReportModel campaignReportModel = campaignReport;
        if (offset == '1') {
          _orders = [];
        }
        _orders!.addAll(campaignReportModel.orders!);
        _pageSize = campaignReportModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<void> getFoodReportList({required String offset, required String? from, required String? to}) async {

    if (offset == '1') {
      _offsetList = [];
      _offset = 1;
      _label = null;
      _earning = null;
      _earningAvg = null;
      _foods = null;
      update();
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);

      FoodReportModel? foodReport = await reportServiceInterface.getFoodReportList(offset: int.parse(offset), from: from, to: to);
      if (foodReport != null) {
        FoodReportModel foodReportModel = foodReport;
        if (offset == '1') {
          _label = [];
          _earning = [];
          _earningAvg = null;
          _foods = [];
        }
        _label!.addAll(foodReportModel.label!);
        _earning!.addAll(foodReportModel.earning!);
        _earningAvg = foodReportModel.earningAvg!;
        _avgType = foodReportModel.avgType!;
        _foods!.addAll(foodReportModel.foods!);
        _pageSize = foodReportModel.totalSize;

        _isLoading = false;
        update();
      }
    } else {
      if (isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void showDatePicker(BuildContext context, {bool transaction = false, bool order = false, bool campaign = false}) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'done'.tr,
      confirmText: 'done'.tr,
      cancelText: 'cancel'.tr,
      fieldStartLabelText: 'start_date'.tr,
      fieldEndLabelText: 'end_date'.tr,
      errorInvalidRangeText: 'select_range'.tr,
    );

    if (result != null) {
      _selectedDateRange = result;

      _from = _selectedDateRange.start.toString().split(' ')[0];
      _to = _selectedDateRange.end.toString().split(' ')[0];
      update();
      if(transaction){
        getTransactionReportList(offset: '1', from: _from, to: _to);
      }
      if(order){
        getOrderReportList(offset: '1', from: _from, to: _to);
      }
      if(campaign) {
        getCampaignReportList(offset: '1', from: _from, to: _to);
      }
      getFoodReportList(offset: '1', from: _from, to: _to);
    }
  }

}