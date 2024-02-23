import 'package:stackfood_multivendor_restaurant/common/widgets/confirmation_dialog_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/controllers/campaign_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/campaign/domain/models/campaign_model.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignDetailsScreen extends StatelessWidget {
  final CampaignModel campaignModel;
  const CampaignDetailsScreen({super.key, required this.campaignModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Column(children: [

        Expanded(child: CustomScrollView(slivers: [

          SliverAppBar(
            expandedHeight: 230, toolbarHeight: 50,
            pinned: true, floating: false,
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              icon: Icon(Icons.chevron_left, color: Theme.of(context).cardColor),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: CustomImageWidget(
                fit: BoxFit.cover, placeholder: Images.restaurantCover,
                image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}/${campaignModel.image}',
              ),
            ),
          ),

          SliverToBoxAdapter(child: Center(child: Container(
            width: 1170,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            color: Theme.of(context).cardColor,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(
                    image: '${Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl}/${campaignModel.image}',
                    height: 40, width: 50, fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    campaignModel.title!, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),

                  Row(children: [

                    Text('date'.tr, style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                    )),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text(
                      '${DateConverter.convertDateToDate(campaignModel.availableDateStarts!)}'' - ${DateConverter.convertDateToDate(campaignModel.availableDateEnds!)}',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                    ),

                  ]),

                  Row(children: [

                    Text('daily_time'.tr, style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
                    )),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Text(
                      '${DateConverter.convertStringTimeToTime(campaignModel.startTime!)}'' - ${DateConverter.convertStringTimeToTime(campaignModel.endTime!)}',
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                    ),

                  ]),

                ])),

              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(
                campaignModel.description ?? 'no_description_found'.tr,
                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
              ),

            ]),

          ))),

        ])),

        CustomButtonWidget(
          buttonText: campaignModel.isJoined! ? 'leave_now'.tr : 'join_now'.tr,
          color: campaignModel.isJoined! ? Theme.of(context).secondaryHeaderColor : Theme.of(context).primaryColor,
          margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          onPressed: () {
            Get.dialog(ConfirmationDialogWidget(
              icon: Images.warning, description: campaignModel.isJoined! ? 'are_you_sure_to_leave'.tr : 'are_you_sure_to_join'.tr,
              onYesPressed: () {
                if(campaignModel.isJoined!) {
                  Get.find<CampaignController>().leaveCampaign(campaignModel.id, true);
                }else {
                  Get.find<CampaignController>().joinCampaign(campaignModel.id, true);
                }
              },
            ));
          },
        ),

      ]),
    );
  }
}