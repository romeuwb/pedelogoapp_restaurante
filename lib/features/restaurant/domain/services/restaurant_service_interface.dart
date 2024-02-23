import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:image_picker/image_picker.dart';

abstract class RestaurantServiceInterface  {
  Future<dynamic> getCuisineList();
  Future<dynamic> getProductList(String offset, String type);
  Future<dynamic> updateRestaurant(Restaurant restaurant, List<String> cuisines, XFile? logo, XFile? cover, String token, List<Translation> translation);
  Future<dynamic> addProduct(Product product, XFile? image, bool isAdd, String tags);
  Future<dynamic> deleteProduct(int productID);
  Future<dynamic> getRestaurantReviewList(int? restaurantID);
  Future<dynamic> getProductReviewList(int? productID);
  Future<dynamic> updateProductStatus(int? productID, int status);
  Future<dynamic> updateRecommendedProductStatus(int? productID, int status);
  Future<dynamic> addSchedule(Schedules schedule);
  Future<dynamic> deleteSchedule(int? scheduleID);
  Future<dynamic> getProductDetails(int productId);
  Future<dynamic> updateAnnouncement(int status, String announcement);
}