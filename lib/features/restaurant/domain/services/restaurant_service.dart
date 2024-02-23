import 'package:stackfood_multivendor_restaurant/features/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/cuisine_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/review_model.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/repositories/restaurant_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/services/restaurant_service_interface.dart';
import 'package:image_picker/image_picker.dart';

class RestaurantService implements RestaurantServiceInterface {
  final RestaurantRepositoryInterface restaurantRepositoryInterface;
  RestaurantService({required this.restaurantRepositoryInterface});

  @override
  Future<CuisineModel?> getCuisineList() async {
    return await restaurantRepositoryInterface.getList();
  }

  @override
  Future<ProductModel?> getProductList(String offset, String type) async {
    return await restaurantRepositoryInterface.getProductList(offset, type);
  }

  @override
  Future<bool> updateRestaurant(Restaurant restaurant, List<String> cuisines, XFile? logo, XFile? cover, String token, List<Translation> translation) async {
    return await restaurantRepositoryInterface.updateRestaurant(restaurant, cuisines, logo, cover, token, translation);
  }

  @override
  Future<bool> addProduct(Product product, XFile? image, bool isAdd, String tags) async {
    return await restaurantRepositoryInterface.addProduct(product, image, isAdd, tags);
  }

  @override
  Future<bool> deleteProduct(int productID) async {
    return await restaurantRepositoryInterface.delete(id: productID);
  }

  @override
  Future<List<ReviewModel>?> getRestaurantReviewList(int? restaurantID) async {
    return await restaurantRepositoryInterface.getRestaurantReviewList(restaurantID);
  }

  @override
  Future<List<ReviewModel>?> getProductReviewList(int? productID) async {
    return await restaurantRepositoryInterface.getProductReviewList(productID);
  }

  @override
  Future<bool> updateProductStatus(int? productID, int status) async {
    return await restaurantRepositoryInterface.updateProductStatus(productID, status);
  }

  @override
  Future<bool> updateRecommendedProductStatus(int? productID, int status) async {
    return await restaurantRepositoryInterface.updateRecommendedProductStatus(productID, status);
  }

  @override
  Future<int?> addSchedule(Schedules schedule) async {
    return await restaurantRepositoryInterface.addSchedule(schedule);
  }

  @override
  Future<bool> deleteSchedule(int? scheduleID) async {
    return await restaurantRepositoryInterface.deleteSchedule(scheduleID);
  }

  @override
  Future<Product?> getProductDetails(int productId) async {
    return await restaurantRepositoryInterface.get(productId);
  }

  @override
  Future<bool> updateAnnouncement(int status, String announcement) async {
    return await restaurantRepositoryInterface.updateAnnouncement(status, announcement);
  }

}