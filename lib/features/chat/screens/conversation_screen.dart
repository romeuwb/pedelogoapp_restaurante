import 'package:stackfood_multivendor_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_image_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_ink_well_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/paginated_list_view_widget.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/controllers/chat_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/language/controllers/localization_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/chat/widgets/search_field_widget.dart';
import 'package:stackfood_multivendor_restaurant/helper/date_converter_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/helper/user_type.dart';
import 'package:stackfood_multivendor_restaurant/util/dimensions.dart';
import 'package:stackfood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Get.find<ChatController>().getConversationList(1);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {

      ConversationsModel? conversation0;
      if(chatController.searchConversationModel != null) {
        conversation0 = chatController.searchConversationModel;
      }else {
        conversation0 = chatController.conversationModel;
      }

      return Scaffold(

        appBar: CustomAppBarWidget(title: 'conversation_list'.tr),

        body: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(children: [

            (conversation0 != null && conversation0.conversations != null) ? SearchFieldWidget(
              controller: _searchController,
              hint: 'search'.tr,
              suffixIcon: chatController.searchConversationModel != null ? Icons.close : Icons.search,
              onSubmit: (String text) {
                if(_searchController.text.trim().isNotEmpty) {
                  chatController.searchConversation(_searchController.text.trim());
                }else {
                  showCustomSnackBar('write_somethings'.tr);
                }
              },
              iconPressed: () {
                if(chatController.searchConversationModel != null) {
                  _searchController.text = '';
                  chatController.removeSearchMode();
                }else {
                  if(_searchController.text.trim().isNotEmpty) {
                    chatController.searchConversation(_searchController.text.trim());
                  }else {
                    showCustomSnackBar('write_somethings'.tr);
                  }
                }
              },
            ) : const SizedBox(),

            SizedBox(height: (conversation0 != null && conversation0.conversations != null
              && chatController.conversationModel!.conversations!.isNotEmpty) ? Dimensions.paddingSizeSmall : 0),

            Expanded(child: (conversation0 != null && conversation0.conversations != null) ? conversation0.conversations!.isNotEmpty  ? RefreshIndicator(
              onRefresh: () async {
                Get.find<ChatController>().getConversationList(1);
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Center(child: SizedBox(width: 1170, child: PaginatedListViewWidget(
                  scrollController: _scrollController,
                  onPaginate: (int? offset) => chatController.getConversationList(offset!),
                  totalSize: conversation0.totalSize,
                  offset: conversation0.offset,
                  enabledPagination: chatController.searchConversationModel == null,
                  productView: ListView.builder(
                    itemCount: conversation0.conversations!.length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      Conversation conversation = conversation0!.conversations![index];

                      User? user;
                      String? type;
                      if(conversation.senderType == UserType.vendor.name) {
                        user = conversation.receiver;
                        type = conversation.receiverType;
                      }else {
                        user = conversation.sender;
                        type = conversation.senderType;
                      }

                      String? baseUrl = '';
                      if(type == UserType.customer.name) {
                        baseUrl = Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl;
                      }else {
                        baseUrl = Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl;
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, spreadRadius: 1, blurRadius: 5)],
                        ),
                        child: CustomInkWellWidget(
                          onTap: (){
                            if(user != null){
                              Get.toNamed(RouteHelper.getChatRoute(
                                notificationBody: NotificationBodyModel(
                                  type: conversation.senderType,
                                  notificationType: NotificationType.message,
                                  customerId: type == UserType.customer.name ? user.userId : null,
                                  deliveryManId: type == UserType.delivery_man.name ? user.id : null,
                                ),
                                conversationId: conversation.id,
                              ))!.then((value) => Get.find<ChatController>().getConversationList(1));
                            }else{
                              showCustomSnackBar('${type!.tr} ${'deleted'.tr}');
                            }
                          },
                          highlightColor: Theme.of(context).colorScheme.background.withOpacity(0.05),
                          radius: Dimensions.radiusSmall,
                          child: Stack(children: [

                            Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              child: Row(children: [

                                ClipOval(
                                  child: CustomImageWidget(
                                    height: 50, width: 50,fit: BoxFit.cover,
                                    image: '$baseUrl/${user != null ? user.image : ''}',
                                  ),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  user != null ? Text('${user.fName} ${user.lName}', style: robotoMedium) : Text('${type!.tr} ${'deleted'.tr}', style: robotoMedium),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                  Text(
                                    type!.tr,
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                  ),

                                ])),
                              ]),
                            ),

                            Positioned( right: Get.find<LocalizationController>().isLtr ? 5 : null, bottom: 5, left: Get.find<LocalizationController>().isLtr ? null : 5,
                              child: Text(
                                DateConverter.localDateToIsoStringAMPM(DateConverter.dateTimeStringToDate(conversation.lastMessageTime!)),
                                style: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall),
                              ),
                            ),

                            (conversation.unreadMessageCount! > 0) ? Positioned( right: Get.find<LocalizationController>().isLtr ? 5 : null, top: 5,
                              left: Get.find<LocalizationController>().isLtr ? null : 5, child: Container(
                                padding: EdgeInsets.all(
                                  conversation.lastMessage != null ? (conversation.lastMessage!.senderId == user!.id)
                                      ? Dimensions.paddingSizeExtraSmall : 0.0 : Dimensions.paddingSizeExtraSmall,
                                ),
                                decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                                child: Text(
                                  conversation.lastMessage != null ? (conversation.lastMessage!.senderId == user!.id)
                                      ? conversation.unreadMessageCount.toString() : '' : conversation.unreadMessageCount.toString(),
                                  style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeExtraSmall),
                                )),
                            ) : const SizedBox(),

                          ]),
                        ),
                      );
                    },
                  ),
                ))))) : Center(child: Text('no_conversation_found'.tr))  :  const Center(child: CircularProgressIndicator()),
            ),

          ]),
        ),
      );
    });
  }
}