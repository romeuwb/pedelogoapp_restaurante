import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';

class PackageWidget extends StatelessWidget {
  final String title;
  const PackageWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [

          Icon(Icons.check_circle, size: 18, color: Theme.of(context).primaryColor),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text(title, style: robotoMedium),

        ]),
      ),

      Divider(indent: 50, endIndent: 50, color: Theme.of(context).dividerColor,thickness: 1),

    ]);
  }
}