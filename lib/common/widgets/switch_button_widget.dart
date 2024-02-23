import 'package:stackfood_multivendor_restaurant/common/controllers/theme_controller.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwitchButtonWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool? isButtonActive;
  final Function onTap;
  const SwitchButtonWidget({super.key, required this.icon, required this.title, required this.onTap, this.isButtonActive});

  @override
  State<SwitchButtonWidget> createState() => _SwitchButtonWidgetState();
}

class _SwitchButtonWidgetState extends State<SwitchButtonWidget> {
  bool? _buttonActive;

  @override
  void initState() {
    super.initState();

    _buttonActive = widget.isButtonActive;
  }

  final MaterialStateProperty<Icon?> thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Icon(Icons.circle, color: Get.find<ThemeController>().darkTheme ? Colors.black : Colors.white);
      }
      return Icon(Icons.circle, color: Get.find<ThemeController>().darkTheme ? Colors.white: Colors.black);
    },
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(_buttonActive != null) {
          setState(() {
            _buttonActive = !_buttonActive!;
          });
        }
        widget.onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: _buttonActive != null ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(children: [

          Icon(widget.icon, size: 25),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Text(widget.title, style: robotoRegular)),
         _buttonActive != null ? Switch(
           thumbIcon: thumbIcon,
            value: _buttonActive!,
            onChanged: (bool isActive) {
              if(_buttonActive != null) {
                setState(() {
                  _buttonActive = !_buttonActive!;
                });
              }
              widget.onTap();
            },
          ) : const SizedBox(),
        ]),
      ),
    );
  }
}