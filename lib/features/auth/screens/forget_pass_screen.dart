import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/forgot_password_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: 'forgot_password'.tr),

      body: SafeArea(child: Center(child: Scrollbar(child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Center(child: SizedBox(width: 1170, child: Column(children: [

          Text('please_enter_email'.tr, style: robotoRegular, textAlign: TextAlign.center),
          const SizedBox(height: 50),

          CustomTextFieldWidget(
            controller: _emailController,
            inputType: TextInputType.emailAddress,
            inputAction: TextInputAction.done,
            hintText: 'email'.tr,
            prefixIcon: Icons.email_outlined,
            onSubmit: (text) => GetPlatform.isWeb ? _forgetPass() : null,
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),

          GetBuilder<ForgotPasswordController>(builder: (forgotPasswordController) {
            return !forgotPasswordController.isLoading ? CustomButtonWidget(
              buttonText: 'next'.tr,
              onPressed: () => _forgetPass(),
            ) : const Center(child: CircularProgressIndicator());
          }),

        ]))),
      )))),
    );
  }

  void _forgetPass() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else {
      Get.find<ForgotPasswordController>().forgotPassword(email).then((status) async {
        if (status.isSuccess) {
          Get.toNamed(RouteHelper.getVerificationRoute(email));
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }

}