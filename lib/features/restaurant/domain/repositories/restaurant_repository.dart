import 'dart:convert';
import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/cuisine_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/repositories/restaurant_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';

class RestaurantRepository implements RestaurantRepositoryInterface{
  final ApiClient apiClient;
  RestaurantRepository({required this.apiClient});

  @override
  Future<CuisineModel?> getList() async {
    CuisineModel? cuisineModel;
    Response response = await apiClient.getData(AppConstants.cuisineUri);
    if(response.statusCode == 200) {
      cuisineModel = CuisineModel.fromJson(response.body);
    }
    return cuisineModel;
  }

  @override
  Future<ProductModel?> getProductList(String offset, String type) async {
    ProductModel? productModel;
    Response response = await apiClient.getData('${AppConstants.productListUri}?offset=$offset&limit=10&type=$type');
    if(response.statusCode == 200) {
      productModel = ProductModel.fromJson(response.body);
    }
    return productModel;
  }

  @override
  Future<bool> updateRestaurant(Restaurant restaurant, List<String> cuisines, XFile? logo, XFile? cover, String token, List<Translation> translation) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      '_method': 'put', 'name': restaurant.name!, 'contact_number': restaurant.phone!, 'schedule_order': restaurant.scheduleOrder! ? '1' : '0',
      'address': restaurant.address!, 'minimum_order': restaurant.minimumOrder.toString(), 'delivery': restaurant.delivery! ? '1' : '0',
      'take_away': restaurant.takeAway! ? '1' : '0', 'gst_status': restaurant.gstStatus! ? '1' : '0', 'gst': restaurant.gstCode!,
      'veg': restaurant.veg.toString(), 'non_veg': restaurant.nonVeg.toString(), 'cuisine_ids': jsonEncode(cuisines), 'order_subscription_active': restaurant.orderSubscriptionActive! ? '1' : '0',
      'translations': jsonEncode(translation), 'cutlery': restaurant.cutlery! ? '1' : '0', 'instant_order': restaurant.instanceOrder! ? '1' : '0',
    });
    if(restaurant.minimumShippingCharge != null && restaurant.perKmShippingCharge != null && restaurant.maximumShippingCharge != null) {
      fields.addAll(<String, String>{
        'minimum_delivery_charge': restaurant.minimumShippingCharge.toString(),
        'maximum_delivery_charge': restaurant.maximumShippingCharge.toString(),
        'per_km_delivery_charge': restaurant.perKmShippingCharge.toString(),
      });
    }
    Response response = await apiClient.postMultipartData(AppConstants.restaurantUpdateUri, fields, [MultipartBody('logo', logo), MultipartBody('cover_photo', cover)], []);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> addProduct(Product product, XFile? image, bool isAdd, String tags) async {
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'price': product.price.toString(), 'discount': product.discount.toString(),
      'discount_type': product.discountType!, 'category_id': product.categoryIds![0].id!,
      'available_time_starts': product.availableTimeStarts!,
      'available_time_ends': product.availableTimeEnds!, 'veg': product.veg.toString(),
      'translations': jsonEncode(product.translations), 'tags': tags, 'maximum_cart_quantity': product.maxOrderQuantity.toString(),
      'options': jsonEncode(product.variations),
    });
    String addon = '';
    for(int index=0; index<product.addOns!.length; index++) {
      addon = '$addon${index == 0 ? product.addOns![index].id : ',${product.addOns![index].id}'}';
    }
    fields.addAll(<String, String> {'addon_ids': addon});
    if(product.categoryIds!.length > 1) {
      fields.addAll(<String, String> {'sub_category_id': product.categoryIds![1].id!});
    }
    if(!isAdd) {
      fields.addAll(<String, String> {'_method': 'put', 'id': product.id.toString()});
    }
    Response response = await apiClient.postMultipartData(isAdd ? AppConstants.addProductUri : AppConstants.updateProductUri, fields, [MultipartBody('image', image)], []);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> delete({int? id}) async {
    Response response = await apiClient.postData('${AppConstants.deleteProductUri}?id=$id', {"_method": "delete"});
    return (response.statusCode == 200);
  }

  @override
  Future<List<ReviewModel>?> getRestaurantReviewList(int? restaurantID) async {
    List<ReviewModel>? restaurantReviewList;
    Response response = await apiClient.getData('${AppConstants.restaurantReviewUri}?restaurant_id=$restaurantID');
    if(response.statusCode == 200) {
      restaurantReviewList = [];
      response.body.forEach((review) => restaurantReviewList!.add(ReviewModel.fromJson(review)));
    }
    return restaurantReviewList;
  }

  @override
  Future<List<ReviewModel>?> getProductReviewList(int? productID) async {
    List<ReviewModel>? productReviewList;
    Response response = await apiClient.getData('${AppConstants.productReviewUri}/$productID');
    if(response.statusCode == 200) {
      productReviewList = [];
      response.body.forEach((review) => productReviewList!.add(ReviewModel.fromJson(review)));
    }
    return productReviewList;
  }

  @override
  Future<bool> updateProductStatus(int? productID, int status) async {
    Response response = await apiClient.getData('${AppConstants.updateProductStatusUri}?id=$productID&status=$status');
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateRecommendedProductStatus(int? productID, int status) async {
    Response response = await apiClient.getData('${AppConstants.updateProductRecommendedUri}?id=$productID&status=$status');
    return (response.statusCode == 200);
  }

  @override
  Future<int?> addSchedule(Schedules schedule) async {
    int? scheduleID;
    Response response = await apiClient.postData(AppConstants.addSchedule, schedule.toJson());
    if(response.statusCode == 200) {
      scheduleID = int.parse(response.body['id'].toString());
    }
    return scheduleID;
  }

  @override
  Future<bool> deleteSchedule(int? scheduleID) async {
    Response response = await apiClient.postData('${AppConstants.deleteSchedule}$scheduleID', {"_method": "delete"});
    return (response.statusCode == 200);
  }

  @override
  Future<Product?> get(int id) async {
    Product? product;
    Response response = await apiClient.getData('${AppConstants.productDetailsUri}/$id');
    if(response.statusCode == 200) {
      product = Product.fromJson(response.body);
    }
    return product;
  }

  @override
  Future<bool> updateAnnouncement(int status, String announcement) async {
    Map<String, String> fields = {'announcement_status': status.toString(), 'announcement_message': announcement, '_method': 'put'};
    Response response = await apiClient.postData(AppConstants.announcementUri, fields);
    return (response.statusCode == 200);
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    // TODO: implement update
    throw UnimplementedError();
  }

}