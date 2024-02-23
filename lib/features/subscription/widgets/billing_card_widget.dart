import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';

class BillingCardWidget extends StatelessWidget {
  final String logo;
  final String title;
  final String subTitle;
  final bool titleBig;
  final bool subtitleSmall;
  const BillingCardWidget({super.key, required this.logo, required this.title, required this.subTitle, this.titleBig = false, this.subtitleSmall = false});

  @override
  Widget build(BuildContext context) {
    return Row(children: [

      Image.asset(logo, height: 35, width: 35, fit: BoxFit.contain),
      const SizedBox(width: Dimensions.paddingSizeLarge),

      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Text(title, style: robotoMedium.copyWith(
          color: titleBig ? Theme.of(context).colorScheme.error : Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5),
          fontSize: titleBig ? Dimensions.fontSizeExtraLarge : Dimensions.fontSizeSmall),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        Text(subTitle, style: robotoBold.copyWith(fontSize: subtitleSmall ? Dimensions.fontSizeSmall : Dimensions.fontSizeExtraLarge)),

      ]),

    ]);
  }
}