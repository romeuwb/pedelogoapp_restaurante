import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/controllers/report_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/food/widget/food_report_details_card_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/reports/screens/food/widget/line_chart_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/custom_print_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/price_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodReportScreen extends StatefulWidget {
  const FoodReportScreen({super.key});

  @override
  State<FoodReportScreen> createState() => _FoodReportScreenState();
}

class _FoodReportScreenState extends State<FoodReportScreen> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<ReportController>().initSetDate();
    Get.find<ReportController>().setOffset(1);
    Get.find<ReportController>().getFoodReportList(
      offset: Get.find<ReportController>().offset.toString(),
      from: Get.find<ReportController>().from, to: Get.find<ReportController>().to,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<ReportController>().orderTransactions != null
          && !Get.find<ReportController>().isLoading) {
        int pageSize = (Get.find<ReportController>().pageSize! / 10).ceil();
        if (Get.find<ReportController>().offset < pageSize) {
          Get.find<ReportController>().setOffset(Get.find<ReportController>().offset+1);
          customPrint('end of the page');
          Get.find<ReportController>().showBottomLoader();
          Get.find<ReportController>().getFoodReportList(
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
        title: 'food_report'.tr,
        menuWidget: IconButton(
          icon: Icon(Icons.filter_list_sharp, color: Theme.of(context).textTheme.bodyLarge!.color),
          onPressed: () => Get.find<ReportController>().showDatePicker(context),
        ),
      ),

      body: GetBuilder<ReportController>(builder: (reportController) {
        return reportController.foods != null ? SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text("sales_statistic".tr, style: robotoMedium),

                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

                  Text(reportController.avgType ?? '', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(PriceConverter.convertPrice(reportController.earningAvg!), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),

                ]),

              ]),
            ),

            LineChartWidget(reportController: reportController),

            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                Text(
                  "food_list".tr,
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
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

            reportController.foods != null ? reportController.foods!.isNotEmpty ? ListView.builder(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reportController.foods!.length,
              itemBuilder: (context, index) {
                return FoodReportDetailsCardWidget(foods: reportController.foods![index]);
              },
            ) : Center(child: Padding(padding: const EdgeInsets.only(top : 200), child: Text('no_food_found'.tr, style: robotoMedium)))
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