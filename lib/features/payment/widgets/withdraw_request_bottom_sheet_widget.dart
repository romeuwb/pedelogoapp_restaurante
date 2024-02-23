import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_form_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/payment/controllers/payment_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawRequestBottomSheetWidget extends StatefulWidget {
  const WithdrawRequestBottomSheetWidget({super.key});

  @override
  State<WithdrawRequestBottomSheetWidget> createState() => _WithdrawRequestBottomSheetWidgetState();
}

class _WithdrawRequestBottomSheetWidgetState extends State<WithdrawRequestBottomSheetWidget> {

  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    Get.find<PaymentController>().setMethod(willUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
      ),
      child: GetBuilder<PaymentController>(builder: (paymentController) {
        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Text('withdraw'.tr, style: robotoMedium),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            Image.asset(Images.bank, height: 30, width: 30),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            DropdownButton(
              value: paymentController.methodIndex,
              items: paymentController.methodList,
              onChanged: (int? index){
                paymentController.setMethodIndex(index);
                paymentController.setMethod();
              },
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: paymentController.methodFields.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(children: [

                  Row(children: [

                    Expanded(
                      child: CustomTextFormFieldWidget(
                        titleName: paymentController.methodFields[index].inputName.toString().replaceAll('_', ' '),
                        hintText: paymentController.methodFields[index].placeholder,
                        controller: paymentController.textControllerList[index],
                        capitalization: TextCapitalization.words,
                        inputType: paymentController.methodFields[index].inputType == 'phone' ? TextInputType.phone : paymentController.methodFields[index].inputType == 'number'
                            ? TextInputType.number : paymentController.methodFields[index].inputType == 'email' ? TextInputType.emailAddress : TextInputType.name,
                        focusNode: paymentController.focusList[index],
                        nextFocus: index != paymentController.methodFields.length-1 ? paymentController.focusList[index + 1] : _amountFocus,
                        isRequired: paymentController.methodFields[index].isRequired == 1,
                      ),
                    ),

                    paymentController.methodFields[index].inputType == 'date' ? IconButton(
                      onPressed: () async {

                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          String formattedDate = DateConverter.dateTimeForCoupon(pickedDate);
                          setState(() {
                            paymentController.textControllerList[index].text = formattedDate;
                          });
                        }

                      },
                      icon: const Icon(Icons.date_range_sharp),
                    ) : const SizedBox(),
                  ]),
                  SizedBox(height: index != paymentController.methodFields.length-1 ? Dimensions.paddingSizeLarge : 0),

              ]);
            }),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            CustomTextFormFieldWidget(
              hintText: 'enter_amount'.tr,
              controller: _amountController,
              capitalization: TextCapitalization.words,
              inputType: TextInputType.number,
              focusNode: _amountFocus,
              inputAction: TextInputAction.done,
              isRequired: true,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            !paymentController.isLoading ? CustomButtonWidget(
              buttonText: 'withdraw'.tr,
              onPressed: () {

                bool fieldEmpty = false;

                for (var element in paymentController.methodFields) {
                  if(element.isRequired == 1){
                    if(paymentController.textControllerList[paymentController.methodFields.indexOf(element)].text.isEmpty){
                      fieldEmpty = true;
                    }
                  }
                }

                if(fieldEmpty){
                  showCustomSnackBar('required_fields_can_not_be_empty'.tr);
                }else if(_amountController.text.trim().isEmpty){
                  showCustomSnackBar('enter_amount'.tr);
                }else{
                  Map<String?, String> data = {};
                  data['id'] = paymentController.widthDrawMethods![paymentController.methodIndex!].id.toString();
                  data['amount'] = _amountController.text.trim();
                  for (var result in paymentController.methodFields) {
                    data[result.inputName] = paymentController.textControllerList[paymentController.methodFields.indexOf(result)].text.trim();
                  }
                  paymentController.requestWithdraw(data);
                }

              },
            ) : const Center(child: CircularProgressIndicator()),

          ]),
        );
      }),
    );
  }
}