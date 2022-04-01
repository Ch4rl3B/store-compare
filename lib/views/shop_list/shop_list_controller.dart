import 'package:get/get.dart';
import 'package:store_compare/helpers/extensions.dart';
import 'package:store_compare/services/shop_item_service.dart';

class ShopListController extends GetxController {
  RxList<ShopItem> itemList = <ShopItem>[].obs;
  ShopItemContract shopItemService = Get.find<ShopItemContract>();

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  Future<void> fetchItems() async {
    final response = await shopItemService.fetchAll();
    itemList.assignAll(response);
  }

  Future<void> addNewItem(Map<String, dynamic> data) async {
    itemList.insert(0, await shopItemService.save(ShopItem.fromMap(data)).catchError((error){
      Get.context?.saveError(error);
    }));
  }

  Future<void> toggle(int index) async {
    final prev = itemList[index].completed;
    itemList[index].completed =
        await shopItemService.toggle(itemList[index]).catchError((error) {
          itemList[index].completed = prev;
          itemList.refresh();
          Get.context?.saveError(error.toString());
        });
    itemList.refresh();
  }

  void dropItem(int index) {
    final item = itemList.removeAt(index);
    shopItemService.delete(item).catchError((error){
      Future.delayed(1.seconds, (){
        itemList.insert(index, item);
        Get.context?.saveError(error.toString());
      });
    });
  }
}
