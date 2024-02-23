import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/controllers/report_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/order/widget/order_status_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/widgets/report_details_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_print_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderReportScreen extends StatefulWidget {
  const OrderReportScreen({super.key});

  @override
  State<OrderReportScreen> createState() => _OrderReportScreenState();
}

class _OrderReportScreenState extends State<OrderReportScreen> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<ReportController>().initSetDate();
    Get.find<ReportController>().setOffset(1);
    Get.find<ReportController>().getOrderReportList(
      offset: Get.find<ReportController>().offset.toString(),
      from: Get.find<ReportController>().from, to: Get.find<ReportController>().to,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<ReportController>().orders != null
          && !Get.find<ReportController>().isLoading) {
        int pageSize = (Get.find<ReportController>().pageSize! / 10).ceil();
        if (Get.find<ReportController>().offset < pageSize) {
          Get.find<ReportController>().setOffset(Get.find<ReportController>().offset+1);
          customPrint('end of the page');
          Get.find<ReportController>().showBottomLoader();
          Get.find<ReportController>().getOrderReportList(
            offset: Get.find<ReportController>().offset.toString(),
            from: Get.find<ReportController>().from, to: Get.find<ReportController>().to,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(
        title: 'order_report'.tr,
        menuWidget: IconButton(
          icon: Icon(Icons.filter_list_sharp, color: Theme.of(context).textTheme.bodyLarge!.color),
          onPressed: () => Get.find<ReportController>().showDatePicker(context, order: true),
        ),
      ),

      body: GetBuilder<ReportController>(builder: (reportController) {
        return reportController.orders != null ? SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Row(children: [

                    Column(children: [

                      OrderStatusCardWidget(
                        image: Images.scheduled,
                        title: 'scheduled_orders'.tr,
                        totalCount: reportController.otherData!.totalScheduledCount ?? 0,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      OrderStatusCardWidget(
                        image: Images.processing,
                        title: 'processing_orders'.tr,
                        totalCount: reportController.otherData!.totalProgressCount ?? 0,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      OrderStatusCardWidget(
                        image: Images.cancel,
                        title: 'canceled'.tr,
                        totalCount: reportController.otherData!.totalCanceledCount ?? 0,
                      ),

                    ]),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Column(children: [

                      OrderStatusCardWidget(
                        image: Images.pending,
                        title: 'pending_orders'.tr,
                        totalCount: reportController.otherData!.totalPendingCount ?? 0,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      OrderStatusCardWidget(
                        image: Images.foodOnTheWay,
                        title: 'food_on_the_way'.tr,
                        totalCount: reportController.otherData!.totalOnTheWayCount ?? 0,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      OrderStatusCardWidget(
                        image: Images.paymentFailed,
                        title: 'payment_failed'.tr,
                        totalCount: reportController.otherData!.totalFailedCount ?? 0,
                      ),

                    ]),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    Column(children: [

                      OrderStatusCardWidget(
                        image: Images.accept,
                        title: 'accepted_orders'.tr,
                        totalCount: reportController.otherData!.totalAcceptedCount ?? 0,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      OrderStatusCardWidget(
                        image: Images.deliver,
                        title: 'delivered'.tr,
                        totalCount: reportController.otherData!.totalDeliveredCount ?? 0,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      OrderStatusCardWidget(
                        image: Images.refund,
                        title: 'refunded'.tr,
                        totalCount: reportController.otherData!.totalRefundedCount ?? 0,
                      ),

                    ]),

                  ]),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                Text(
                  "total_orders".tr,
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                const Spacer(),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                  ),
                  child: Text(DateConverter.convertDateToDate(reportController.from!), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                ),
                const SizedBox(width: 5),

                Text('to'.tr, style: robotoMedium.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(width: 5),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                  ),
                  child: Text(DateConverter.convertDateToDate(reportController.to!), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                ),

              ]),
            ),

            reportController.orders != null ? reportController.orders!.isNotEmpty ? ListView.builder(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reportController.orders!.length,
              itemBuilder: (context, index) {
                return ReportDetailsCardWidget(orders: reportController.orders![index]);
              },
            ) : Center(child: Padding(padding: const EdgeInsets.only(top : 200), child: Text('no_order_found'.tr, style: robotoMedium)))
              : const Center(child: CircularProgressIndicator()),

            reportController.isLoading ? Center(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            )) : const SizedBox(),

          ]),
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}