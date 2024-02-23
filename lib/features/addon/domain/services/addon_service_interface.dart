import 'package:stackfood_multivendor_restaurant/features/restaurant/domain/models/product_model.dart';

abstract class AddonServiceInterface {
  Future<List<AddOns>?> getAddonList();
  Future<bool> addAddon(AddOns addonModel);
  Future<bool> updateAddon(Map<String, dynamic> body);
  Future<bool> deleteAddon(int id);
  List<int?> prepareAddonIds(List<AddOns> addonList);
}