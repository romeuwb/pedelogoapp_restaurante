import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/order/domain/models/update_status_model.dart';

abstract class OrderServiceInterface {
  Future<dynamic> getOrderDetails(int orderID);
  Future<dynamic> getCurrentOrders();
  Future<dynamic> getPaginatedOrderList(int offset, String status);
  Future<dynamic> updateOrderStatus(UpdateStatusModel updateStatusBody, List<MultipartBody> proofAttachment);
  Future<dynamic> getOrderWithId(int? orderId);
  Future<dynamic> getCancelReasons();
  Future<dynamic> sendDeliveredNotification(int? orderID);
}