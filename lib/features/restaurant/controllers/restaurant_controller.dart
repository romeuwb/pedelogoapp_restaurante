import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/cuisine_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/variant_type_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/variation_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/services/restaurant_service_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/category/controllers/category_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/controllers/addon_controller.dart';
import 'package:stackfood_multivendor_restaurant/helper/route_helper.dart';
import 'package:stackfood_multivendor_restaurant/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantController extends GetxController implements GetxService {
  final RestaurantServiceInterface restaurantServiceInterface;
  RestaurantController({required this.restaurantServiceInterface});

  List<Product>? _productList;
  List<Product>? get productList => _productList;

  List<ReviewModel>? _restaurantReviewList;
  List<ReviewModel>? get restaurantReviewList => _restaurantReviewList;

  List<ReviewModel>? _productReviewList;
  List<ReviewModel>? get productReviewList => _productReviewList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _pageSize;
  int? get pageSize => _pageSize;

  List<String> _offsetList = [];

  int _offset = 1;
  int get offset => _offset;

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;

  XFile? _pickedLogo;
  XFile? get pickedLogo => _pickedLogo;

  XFile? _pickedCover;
  XFile? get pickedCover => _pickedCover;

  int? _categoryIndex = 0;
  int? get categoryIndex => _categoryIndex;

  int? _subCategoryIndex = 0;
  int? get subCategoryIndex => _subCategoryIndex;

  List<int>? _selectedAddons;
  List<int>? get selectedAddons => _selectedAddons;

  List<VariantTypeModel>? _variantTypeList;
  List<VariantTypeModel>? get variantTypeList => _variantTypeList;

  bool _isAvailable = true;
  bool get isAvailable => _isAvailable;

  bool _isRecommended = true;
  bool get isRecommended => _isRecommended;

  List<Schedules>? _scheduleList;
  List<Schedules>? get scheduleList => _scheduleList;

  bool _scheduleLoading = false;
  bool get scheduleLoading => _scheduleLoading;

  bool? _isGstEnabled;
  bool? get isGstEnabled => _isGstEnabled;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  bool _isVeg = false;
  bool get isVeg => _isVeg;

  bool? _isRestVeg = true;
  bool? get isRestVeg => _isRestVeg;

  bool? _isRestNonVeg = true;
  bool? get isRestNonVeg => _isRestNonVeg;

  String _type = 'all';
  String get type => _type;

  static final List<String> _productTypeList = ['all', 'veg', 'non_veg'];
  List<String> get productTypeList => _productTypeList;

  List<VariationModel>? _variationList;
  List<VariationModel>? get variationList => _variationList;

  List<String?> _tagList = [];
  List<String?> get tagList => _tagList;

  CuisineModel? _cuisineModel;
  CuisineModel? get cuisineModel => _cuisineModel;

  List<int>? _selectedCuisines;
  List<int>? get selectedCuisines => _selectedCuisines;

  List<int?>? _cuisineIds;
  List<int?>? get cuisineIds => _cuisineIds;

  Product? _product;
  Product? get product => _product;

  int _announcementStatus = 0;
  int get announcementStatus => _announcementStatus;

  bool instantOrder = false;
  bool scheduleOrder = false;


  void initRestaurantData(Restaurant restaurant) {
    _pickedLogo = null;
    _pickedCover = null;
    _isGstEnabled = restaurant.gstStatus;
    _scheduleList = [];
    _scheduleList!.addAll(restaurant.schedules!);
    _isRestVeg = restaurant.veg == 1;
    _isRestNonVeg = restaurant.nonVeg == 1;
    _getCuisineList(restaurant.cuisines);
  }

  Future<void> _getCuisineList(List<Cuisine>? cuisines) async {
    _selectedCuisines = [];
    CuisineModel? cuisineModel = await restaurantServiceInterface.getCuisineList();
    if (cuisineModel != null) {
      _cuisineModel = cuisineModel;
      for (var modelCuisine in _cuisineModel!.cuisines!) {
        for(Cuisine cuisine in cuisines!){
          if(modelCuisine.id == cuisine.id){
            _selectedCuisines!.add(_cuisineModel!.cuisines!.indexOf(modelCuisine));
          }
        }
      }
    }
    update();
  }

  void setTag(String? name, {bool willUpdate = true}){
    _tagList.add(name);
    if(willUpdate) {
      update();
    }
  }

  void initializeTags(){
    _tagList = [];
  }

  void removeTag(int index){
    _tagList.removeAt(index);
    update();
  }

  void setEmptyVariationList(){
    _variationList = [];
  }

  void setExistingVariation(List<Variation>? variationList){
    _variationList = [];
    if(variationList != null && variationList.isNotEmpty) {
      for (var variation in variationList) {
        List<Option> options = [];

        for (var option in variation.variationValues!) {
          options.add(Option(
              optionNameController: TextEditingController(text: option.level),
              optionPriceController: TextEditingController(text: option.optionPrice)),
          );
        }

        _variationList!.add(VariationModel(
            nameController: TextEditingController(text: variation.name),
            isSingle: variation.type == 'single' ? true : false,
            minController: TextEditingController(text: variation.min),
            maxController: TextEditingController(text: variation.max),
            required: variation.required == 'on' ? true : false,
            options: options),
        );
      }
    }
  }

  void changeSelectVariationType(int index){
    _variationList![index].isSingle = !_variationList![index].isSingle;
    update();
  }

  void setVariationRequired(int index){
    _variationList![index].required = !_variationList![index].required;
    update();
  }

  void addVariation(){
    _variationList!.add(VariationModel(
      nameController: TextEditingController(), required: false, isSingle: true, maxController: TextEditingController(), minController: TextEditingController(),
      options: [Option(optionNameController: TextEditingController(), optionPriceController: TextEditingController())],
    ));
    update();
  }

  void removeVariation(int index){
    _variationList!.removeAt(index);
    update();
  }

  void addOptionVariation(int index){
    _variationList![index].options!.add(Option(optionNameController: TextEditingController(), optionPriceController: TextEditingController()));
    update();
  }

  void removeOptionVariation(int vIndex, int oIndex){
    _variationList![vIndex].options!.removeAt(oIndex);
    update();
  }

  Future<void> getProductList(String offset, String type) async {
    if(offset == '1') {
      _offsetList = [];
      _offset = 1;
      _type = type;
      _productList = null;
      update();
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ProductModel? productModel = await restaurantServiceInterface.getProductList(offset, type);
      if (productModel != null) {
        if (offset == '1') {
          _productList = [];
        }
        _productList!.addAll(productModel.products!);
        _pageSize = productModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  void getAttributeList(Product? product) async {
    _discountTypeIndex = 0;
    _categoryIndex = 0;
    _subCategoryIndex = 0;
    _pickedLogo = null;
    _selectedAddons = [];
    _variantTypeList = [];
    List<int?> addonsIds = await Get.find<AddonController>().getAddonList();
    if(product != null && product.addOns != null) {
      for(int index=0; index<product.addOns!.length; index++) {
        setSelectedAddonIndex(addonsIds.indexOf(product.addOns![index].id), false);
      }
    }
    await Get.find<CategoryController>().getCategoryList(product);
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  Future<void> updateRestaurant(Restaurant restaurant, List<String> cuisines, String token,List<Translation> translation) async {
    _isLoading = true;
    update();
    bool isSuccess = await restaurantServiceInterface.updateRestaurant(restaurant, cuisines, _pickedLogo, _pickedCover, token, translation);
    if(isSuccess) {
      Get.back();
      Get.find<ProfileController>().getProfile();
      showCustomSnackBar('restaurant_settings_updated_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    }else {
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }

  void setSelectedAddonIndex(int index, bool notify) {
    if(!_selectedAddons!.contains(index)) {
      _selectedAddons!.add(index);
      if(notify) {
        update();
      }
    }
  }

  void removeAddon(int index) {
    _selectedAddons!.removeAt(index);
    update();
  }

  Future<void> addProduct(Product product, bool isAdd) async {
    _isLoading = true;
    update();

    String tags = '';
    for (var element in _tagList) {
      tags = tags + (tags.isEmpty ? '' : ',') + element!.replaceAll(' ', '');
    }

    bool isSuccess = await restaurantServiceInterface.addProduct(product, _pickedLogo, isAdd, tags);
    if(isSuccess) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar(isAdd ? 'product_added_successfully'.tr : 'product_updated_successfully'.tr, isError: false);
      getProductList('1', 'all');
    }
    _isLoading = false;
    update();
  }

  Future<void> deleteProduct(int productID) async {
    _isLoading = true;
    update();
    bool isSuccess = await restaurantServiceInterface.deleteProduct(productID);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar('product_deleted_successfully'.tr, isError: false);
      getProductList('1', 'all');
    }
    _isLoading = false;
    update();
  }

  Future<void> getRestaurantReviewList(int? restaurantID) async {
    _tabIndex = 0;
    List<ReviewModel>? restaurantReviewList = await restaurantServiceInterface.getRestaurantReviewList(restaurantID);
    if(restaurantReviewList != null) {
      _restaurantReviewList = [];
      _restaurantReviewList!.addAll(restaurantReviewList);
    }
    update();
  }

  Future<void> getProductReviewList(int? productID) async {
    _productReviewList = null;
    List<ReviewModel>? productReviewList = await restaurantServiceInterface.getProductReviewList(productID);
    if(productReviewList != null) {
      _productReviewList = [];
      _productReviewList!.addAll(productReviewList);
    }
    update();
  }

  void setAvailability(bool isAvailable) {
    _isAvailable = isAvailable;
  }

  void toggleAvailable(int? productID) async {
    bool isSuccess = await restaurantServiceInterface.updateProductStatus(productID, _isAvailable ? 0 : 1);
    if(isSuccess) {
      getProductList('1', 'all');
      _isAvailable = !_isAvailable;
      showCustomSnackBar('food_status_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void setRecommended(bool isRecommended) {
    _isRecommended = isRecommended;
  }

  void toggleRecommendedProduct(int? productID) async {
    bool isSuccess = await restaurantServiceInterface.updateRecommendedProductStatus(productID, _isRecommended ? 0 : 1);
    if(isSuccess) {
      getProductList('1', 'all');
      _isRecommended = !_isRecommended;
      showCustomSnackBar('food_status_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void toggleGst() {
    _isGstEnabled = !_isGstEnabled!;
    update();
  }

  Future<void> addSchedule(Schedules schedule) async {
    schedule.openingTime = '${schedule.openingTime!}:00';
    schedule.closingTime = '${schedule.closingTime!}:00';
    _scheduleLoading = true;
    update();
    int? scheduleID = await restaurantServiceInterface.addSchedule(schedule);
    if(scheduleID != null) {
      schedule.id = scheduleID;
      _scheduleList!.add(schedule);
      Get.back();
      showCustomSnackBar('schedule_added_successfully'.tr, isError: false);
    }
    _scheduleLoading = false;
    update();
  }

  Future<void> deleteSchedule(int? scheduleID) async {
    _scheduleLoading = true;
    update();
    bool isSuccess = await restaurantServiceInterface.deleteSchedule(scheduleID);
    if(isSuccess) {
      _scheduleList!.removeWhere((schedule) => schedule.id == scheduleID);
      Get.back();
      showCustomSnackBar('schedule_removed_successfully'.tr, isError: false);
    }
    _scheduleLoading = false;
    update();
  }

  void setTabIndex(int index) {
    bool notify = true;
    if(_tabIndex == index) {
      notify = false;
    }
    _tabIndex = index;
    if(notify) {
      update();
    }
  }

  void setVeg(bool isVeg, bool notify) {
    _isVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void setRestVeg(bool? isVeg, bool notify) {
    _isRestVeg = isVeg;
    if(notify) {
      update();
    }
  }

  void setRestNonVeg(bool? isNonVeg, bool notify) {
    _isRestNonVeg = isNonVeg;
    if(notify) {
      update();
    }
  }

  Future<Product?> getProductDetails(int productId) async {
    _isLoading = true;
    update();
    Product? product = await restaurantServiceInterface.getProductDetails(productId);
    if (product != null) {
      _product = product;
      if(_product?.translations == null || _product!.translations!.isEmpty) {
        _product!.translations = [];
        _product!.translations!.add(Translation(
          locale: Get.find<SplashController>().configModel!.language!.first.key,
          key: 'name', value: _product!.name,
        ));
        _product!.translations!.add(Translation(
          locale: Get.find<SplashController>().configModel!.language!.first.key,
          key: 'description', value: _product!.description,
        ));
      }
      _isLoading = false;
      update();
    }
    _isLoading = false;
    update();
    return _product;
  }

  Future<void> getCuisineList() async {
    _selectedCuisines = [];
    CuisineModel? cuisineModel = await restaurantServiceInterface.getCuisineList();
    if (cuisineModel != null) {
      _cuisineIds = [];
      _cuisineIds!.add(0);
      _cuisineModel = cuisineModel;
      for (var cuisine in _cuisineModel!.cuisines!) {
        _cuisineIds!.add(cuisine.id);
      }
    }
    update();
  }

  void setSelectedCuisineIndex(int index, bool notify) {
    if(!_selectedCuisines!.contains(index)) {
      _selectedCuisines!.add(index);
      if(notify) {
        update();
      }
    }
  }

  void removeCuisine(int index) {
    _selectedCuisines!.removeAt(index);
    update();
  }

  Future<void> updateAnnouncement(int status, String announcement) async{
    _isLoading = true;
    update();
    bool isSuccess = await restaurantServiceInterface.updateAnnouncement(status, announcement);
    if(isSuccess){
      Get.back();
      showCustomSnackBar('announcement_updated_successfully'.tr, isError: false);
      Get.find<ProfileController>().getProfile();
    }
    _isLoading = false;
    update();
  }

  void setAnnouncementStatus(int index){
    _announcementStatus = index;
    update();
  }

  void setInstantOrder(bool value){
    if(!checkWarning(value, scheduleOrder)){
      instantOrder = value;
    }
    update();
  }

  void setOrderStatus(bool instant, bool schedule){
    instantOrder = instant;
    scheduleOrder = schedule;
    update();
  }

  void setScheduleOrder(bool value){
    if(!checkWarning(instantOrder, value)){
      scheduleOrder = value;
    }
    update();
  }

  bool checkWarning(bool instantOrder, bool scheduleOrder){
    if(!instantOrder && !scheduleOrder){
      showCustomSnackBar('can_not_disable_both_instance_order_and_schedule_order'.tr, isError: true);
    }
    return (!instantOrder && !scheduleOrder);
  }

}