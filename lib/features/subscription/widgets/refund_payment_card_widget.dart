import 'package:stackfood_multivendor_restaurant/features/subscription/controllers/subscription_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefundPaymentCardWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final int index;
  final Function onTap;
  const RefundPaymentCardWidget({super.key, required this.title, required this.subTitle, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(builder: (subscriptionController) {
      return Stack( clipBehavior: Clip.none, children: [

        InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: subscriptionController.paymentIndex == index ? Border.all(color: Theme.of(context).primaryColor, width: 1) : null,
              boxShadow: subscriptionController.paymentIndex != index ? [BoxShadow(color: Colors.grey[300]!, blurRadius: 10)] : null,
              color: subscriptionController.paymentIndex == index ? Theme.of(context).primaryColor.withOpacity(0.05) : Theme.of(context).cardColor,
            ),
            alignment: Alignment.center,
            width: context.width,
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Text(
                title, style: robotoBold.copyWith(color: subscriptionController.paymentIndex == index ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(
                subTitle, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
              ),

            ]),
          ),
        ),

        subscriptionController.paymentIndex == index ? Positioned(
          top: -8, right: -8,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
            child: Icon(Icons.check, size: 18, color: Theme.of(context).cardColor),
          ),
        ) : const SizedBox(),

      ]);
    });
  }
}