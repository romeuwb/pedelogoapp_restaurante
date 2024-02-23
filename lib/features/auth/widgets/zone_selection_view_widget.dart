import 'package:stackfood_multivendor_restaurant/common/widgets/custom_dropdown_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/location_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneSelectionWidget extends StatelessWidget {
  final LocationController locationController;
  final List<DropdownItem<int>> zoneList;
  const ZoneSelectionWidget({super.key, required this.locationController, required this.zoneList});

  @override
  Widget build(BuildContext context) {
    return zoneList.isNotEmpty ? Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).primaryColor, width: 0.3),
      ),
      child: CustomDropdownWidget<int>(
        onChange: (int? value, int index) {
          locationController.setZoneIndex(value);
        },
        dropdownButtonStyle: DropdownButtonStyle(
          height: 45,
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeExtraSmall,
          ),
          primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
        ),
        dropdownStyle: DropdownStyle(
          elevation: 10,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        ),
        items: zoneList,
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text('${locationController.zoneList![locationController.selectedZoneIndex!].name}'),
        ),
      ),
    ) : Center(child: Text('service_not_available_in_this_area'.tr));
  }
}