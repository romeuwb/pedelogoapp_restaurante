import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';

class PlanTileWidget extends StatelessWidget {
  final String title1;
  final String title2;
  const PlanTileWidget({super.key, required this.title1, required this.title2});

  @override
  Widget build(BuildContext context) {
    return Row(children: [

      const Icon(Icons.check_circle, size: 22, color: Colors.blue),
      const SizedBox(width: Dimensions.paddingSizeDefault),

      Text(title1, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),

      Text(title2, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5))),

    ]);
  }
}