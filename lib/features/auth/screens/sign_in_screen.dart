import 'package:stackfood_multivendor_restaurant/common/widgets/custom_button_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_text_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/images.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    _emailController.text = Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();

    return Scaffold(
      body: SafeArea(child: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: GetBuilder<AuthController>(builder: (authController) {

                  return Column(children: [

                    Image.asset(Images.logo, width: 100),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Image.asset(Images.logoName, width: 100),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Text('sign_in'.tr.toUpperCase(), style: robotoBlack.copyWith(fontSize: 30)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      'only_for_restaurant_owner'.tr, textAlign: TextAlign.center,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(height: 50),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        color: Theme.of(context).cardColor,
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                      ),
                      child: Column(children: [

                        CustomTextFieldWidget(
                          hintText: 'email'.tr,
                          controller: _emailController,
                          focusNode: _emailFocus,
                          nextFocus: _passwordFocus,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline_rounded,
                          divider: true,
                          showBorder: false,
                        ),

                        CustomTextFieldWidget(
                          hintText: 'password'.tr,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          showBorder: false,
                          onSubmit: (text) => GetPlatform.isWeb ? _login(authController) : null,
                        ),

                      ]),
                    ),
                    const SizedBox(height: 10),

                    Row(children: [

                      Expanded(
                        child: ListTile(
                          onTap: () => authController.toggleRememberMe(),
                          leading: Checkbox(
                            activeColor: Theme.of(context).primaryColor,
                            value: authController.isActiveRememberMe,
                            onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                          ),
                          title: Text('remember_me'.tr),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          horizontalTitleGap: 0,
                        ),
                      ),

                      TextButton(
                        onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute()),
                        child: Text('${'forgot_password'.tr}?'),
                      ),

                    ]),
                    const SizedBox(height: 50),

                    !authController.isLoading ? CustomButtonWidget(
                      buttonText: 'sign_in'.tr,
                      onPressed: () => _login(authController),
                    ) : const Center(child: CircularProgressIndicator()),
                    SizedBox(height: Get.find<SplashController>().configModel!.toggleRestaurantRegistration! ? Dimensions.paddingSizeSmall : 0),

                    Get.find<SplashController>().configModel!.toggleRestaurantRegistration! ? TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(1, 40),
                      ),
                      onPressed: () async {
                        Get.toNamed(RouteHelper.getRestaurantRegistrationRoute());
                      },
                      child: RichText(text: TextSpan(children: [
                        TextSpan(text: '${'join_as'.tr} ', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                        TextSpan(text: 'restaurant'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                      ])),
                    ) : const SizedBox(),

                  ]);
                }),
              ),
            ),
          ),
        ),
      )),
    );
  }

  void _login(AuthController authController) async {

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController.login(email, password).then((status) async {
        if (status != null) {
          if (status.isSuccess) {
            if (authController.isActiveRememberMe) {
              authController.saveUserCredentials(email, password);
            } else {
              authController.clearUserCredentials();
            }
            await Get.find<ProfileController>().getProfile();
            Get.offAllNamed(RouteHelper.getInitialRoute());
          } else {
            if (status.message != 'no') {
              showCustomSnackBar(status.message);
            }
          }
        }
      });
    }

  }
}