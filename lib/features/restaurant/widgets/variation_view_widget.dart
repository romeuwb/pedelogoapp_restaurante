import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/controllers/restaurant_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VariationViewWidget extends StatefulWidget {
  final RestaurantController restController;
  final Product? product;
  const VariationViewWidget({super.key, required this.restController, required this.product});

  @override
  State<VariationViewWidget> createState() => _VariationViewWidgetState();
}

class _VariationViewWidgetState extends State<VariationViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Text(
        'variation'.tr,
        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
      ),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

      widget.restController.variationList!.isNotEmpty ? ListView.builder(
        itemCount: widget.restController.variationList!.length,
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
        return Stack(children: [

          Container(
            margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
            child: Column(children: [

              Row(children: [

                Expanded(
                  child: CustomTextFieldWidget(
                    hintText: 'name'.tr,
                    showTitle: true,
                    //showShadow: true,
                    controller: widget.restController.variationList![index].nameController,
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                    child: CheckboxListTile(
                      value: widget.restController.variationList![index].required,
                      title: Text('required'.tr),
                      tristate: true,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value){
                        widget.restController.setVariationRequired(index);
                      },
                    ),
                  ),
                ),

              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text('select_type'.tr, style: robotoMedium),

                Row( children: [

                  InkWell(
                    onTap: () =>  widget.restController.changeSelectVariationType(index),
                    child: Row(children: [
                      Radio(
                        value: true,
                        groupValue: widget.restController.variationList![index].isSingle,
                        onChanged: (bool? value){
                          widget.restController.changeSelectVariationType(index);
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      Text('single'.tr)
                    ]),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeLarge),

                  InkWell(
                    onTap: () =>  widget.restController.changeSelectVariationType(index),
                    child: Row(children: [
                      Radio(
                        value: false,
                        groupValue: widget.restController.variationList![index].isSingle,
                        onChanged: (bool? value){
                          widget.restController.changeSelectVariationType(index);
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      Text('multiple'.tr)
                    ]),
                  ),

                ]),
              ]),

              Visibility(
                visible: !widget.restController.variationList![index].isSingle,
                child: Row(children: [

                  Flexible(
                    child: CustomTextFieldWidget(
                      hintText: 'min'.tr,
                      showTitle: true,
                      //showShadow: true,
                      inputType: TextInputType.number,
                      controller: widget.restController.variationList![index].minController,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Flexible(
                    child: CustomTextFieldWidget(
                      hintText: 'max'.tr,
                      inputType: TextInputType.number,
                      showTitle: true,
                      //showShadow: true,
                      controller: widget.restController.variationList![index].maxController,
                    ),
                  ),

                ]),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  ListView.builder(
                    itemCount: widget.restController.variationList![index].options!.length,
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        child: Row(children: [

                          Flexible(
                            flex: 4,
                            child: CustomTextFieldWidget(
                              hintText: 'option_name'.tr,
                              showTitle: true,
                              controller: widget.restController.variationList![index].options![i].optionNameController,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Flexible(
                            flex: 4,
                            child: CustomTextFieldWidget(
                              hintText: 'additional_price'.tr,
                              showTitle: true,
                              //showShadow: true,
                              controller: widget.restController.variationList![index].options![i].optionPriceController,
                              inputType: TextInputType.number,
                              inputAction: TextInputAction.done,
                            ),
                          ),

                          Flexible(flex: 1, child: Padding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                            child: widget.restController.variationList![index].options!.length > 1 ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => widget.restController.removeOptionVariation(index, i),
                            ) : const SizedBox(),
                          )),

                        ]),
                      );
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  InkWell(
                    onTap: (){
                      widget.restController.addOptionVariation(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall), border: Border.all(color: Theme.of(context).primaryColor)),
                      child: Text('add_new_option'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    ),
                  ),

                ]),
              ),

            ]),
          ),

          Align(alignment: Alignment.topRight,
            child: IconButton(icon: const Icon(Icons.clear),
              onPressed: () => widget.restController.removeVariation(index),
            ),
          ),

        ]);
      }) : const SizedBox(),

      const SizedBox(height: Dimensions.paddingSizeDefault),

      InkWell(
        onTap: () {
          widget.restController.addVariation();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          child: Text(widget.restController.variationList!.isNotEmpty ? 'add_new_variation'.tr : 'add_variation'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeDefault)),
        ),
      ),

      const SizedBox(height: Dimensions.paddingSizeLarge),

    ]);
  }
}