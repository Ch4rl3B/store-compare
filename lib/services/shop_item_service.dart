import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/models/shop_item.dart';
import 'package:store_compare/services/contracts.dart';

export 'package:store_compare/models/shop_item.dart';
export 'package:store_compare/services/contracts.dart';

class ShopItemService extends GetxService implements ShopItemContract {
  @override
  Future<List<ShopItem>> fetchAll() async {
    final query = QueryBuilder<ShopItem>(ShopItem())
      ..includeObject([keyItemCategory])
      ..orderByDescending('createdAt');

    final apiResponse = await query.query<ShopItem>();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results!.cast<ShopItem>();
    } else {
      return Future.error(apiResponse.error!.message);
    }
  }

  @override
  Future<ShopItem> save(ShopItem itemToSave) async {
    final response = await itemToSave.save();
    if (response.success) {
      return response.result as ShopItem;
    } else {
      throw Exception(response.error?.message);
    }
  }

  @override
  Future<bool> toggle(ShopItem itemToSave) async {
    itemToSave.completed = !itemToSave.completed;
    final response = await itemToSave.save();
    if (response.success) {
      return (response.result as ShopItem).completed;
    } else {
      throw Exception(response.error?.message);
    }
  }

  @override
  Future<void> delete(ShopItem itemToDelete) async {
    final response = await itemToDelete.delete();
    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }
}
