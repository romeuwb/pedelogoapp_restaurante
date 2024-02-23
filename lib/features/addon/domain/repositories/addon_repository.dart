import 'package:stackfood_multivendor_restaurant/api/api_client.dart';
import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';
import 'package:stackfood_multivendor_restaurant/features/addon/domain/repositories/addon_repository_interface.dart';
import 'package:stackfood_multivendor_restaurant/util/app_constants.dart';
import 'package:get/get.dart';

class AddonRepository implements AddonRepositoryInterface<AddOns> {
  final ApiClient apiClient;
  AddonRepository({required this.apiClient});

  @override
  Future<bool> add(AddOns addonModel) async {
    Response response = await apiClient.postData(AppConstants.addAddonUri, addonModel.toJson());
    return (response.statusCode == 200);
  }

  @override
  Future update(Map<String, dynamic> body) async {
    Response response = await apiClient.putData(AppConstants.updateAddonUri, body);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> delete({int? id}) async {
    Response response = await apiClient.postData('${AppConstants.deleteAddonUri}?id=$id', {"_method": "delete"});
    return (response.statusCode == 200);
  }

  @override
  Future<List<AddOns>?> getList() async {
    List<AddOns>? addonList;

    Response response = await apiClient.getData(AppConstants.addonListUri);
    if(response.statusCode == 200) {
      addonList = [];

      response.body.forEach((addon) {
        addonList!.add(AddOns.fromJson(addon));
      });
    }

    return addonList;
  }

  @override
  Future get(int id) {
    // TODO: implement get
    throw UnimplementedError();
  }

}