import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:store_compare/helpers/extensions.dart';
import 'package:store_compare/services/nomenclator_service.dart';
import 'package:store_compare/services/shop_item_service.dart';

class ShopListController extends GetxController {
  RxMap<Nomenclator, List<ShopItem>> itemMap =
      <Nomenclator, List<ShopItem>>{}.obs;
  ShopItemContract shopItemService = Get.find<ShopItemContract>();
  ExpandableController expandableController =
      ExpandableController(initialExpanded: false);

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  Future<void> fetchItems() async {
    final response = await shopItemService.fetchAll();
    response.sort((a, b) => a.category.value.compareTo(b.category.value));
    itemMap.assignAll(response.fold({}, (previousValue, element) {
      if (!previousValue.containsKey(element.category)) {
        previousValue[element.category] = <ShopItem>[];
      }
      previousValue[element.category]!.add(element);
      return previousValue;
    }));
  }

  Future<void> addNewItem(Map<String, dynamic> data) async {
    final item =
        await shopItemService.save(ShopItem.fromMap(data)).catchError((error) {
      Get.context?.saveError(error);
    });

    if (!itemMap.containsKey(item.category)) {
      itemMap[item.category] = <ShopItem>[];
    }
    itemMap[data['category']]!.insert(0, item);
    itemMap.refresh();
  }

  Future<void> toggle(Nomenclator category, int index) async {
    final prev = itemMap[category]![index].completed;
    itemMap[category]![index].completed = await shopItemService
        .toggle(itemMap[category]![index])
        .catchError((error) {
      itemMap[category]![index].completed = prev;
      itemMap.refresh();
      Get.context?.saveError(error.toString());
    });
    itemMap.refresh();
  }

  void dropItem(Nomenclator category, int index) {
    final item = itemMap[category]!.removeAt(index);
    shopItemService.delete(item).then((_) {
      if (itemMap[category]!.isEmpty) {
        itemMap.remove(category);
      }
      itemMap.refresh();
    }).catchError((error) {
      Future.delayed(1.seconds, () {
        itemMap[category]!.insert(index, item);
        Get.context?.saveError(error.toString());
        itemMap.refresh();
      });
    });
  }

  void dropItems() {
    for (final key in itemMap.keys) {
      dropCategory(key);
    }
    itemMap.clear();
  }

  void dropCategory(Nomenclator category, {bool clear = false}) {
    final items = itemMap[category]!;
    while(items.isNotEmpty){
      shopItemService.delete(items.removeLast());
    }
    if(clear){
      itemMap.remove(category);
    }
  }

  String getAmount(List<ShopItem> list) {
    var total = 0;
    var current = 0;

    for(final e in list){
      total += e.amount;
      if(!e.completed){
        current += e.amount;
      }
    }

    return '($current/$total)';
  }
}
