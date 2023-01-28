import 'dart:async';
import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:store_compare/helpers/extensions.dart';
import 'package:store_compare/models/product.dart';
import 'package:store_compare/services/nomenclator_service.dart';
import 'package:store_compare/services/shop_item_service.dart';

class ShopListController extends GetxController {
  RxMap<Nomenclator, List<ShopItem>> itemMap =
      <Nomenclator, List<ShopItem>>{}.obs;
  ShopItemContract shopItemService = Get.find<ShopItemContract>();
  ProductServiceContract productService = Get.find<ProductServiceContract>();
  ExpandableController expandableController =
      ExpandableController(initialExpanded: false);

  RxMap<ShopItem, List<Product>> itemProducts = <ShopItem, List<Product>>{}.obs;
  bool loading = false;

  @override
  void onInit() {
    fetchItems();
    super.onInit();
  }

  Future<void> fetchItems() async {
    final response = await shopItemService.fetchAll();
    response.sort((a, b) => a.category.value.compareTo(b.category.value));
    unawaited(fetchProducts(response));
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
      Get.context?.saveError(error.toString());
    });

    if (!itemMap.containsKey(item.category)) {
      itemMap[item.category] = <ShopItem>[];
    }
    itemMap[data['category']]!.insert(0, item);
    unawaited(fetchProducts([item]));
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
      itemProducts.remove(item);
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
    while (items.isNotEmpty) {
      final item = items.removeLast();
      itemProducts.remove(item);
      shopItemService.delete(item);
    }
    if (clear) {
      itemMap.remove(category);
    }
    itemProducts.refresh();
  }

  String getAmount(List<ShopItem> list) {
    var total = 0;
    var current = 0;

    for (final e in list) {
      total += e.amount;
      if (!e.completed) {
        current += e.amount;
      }
    }

    return '($current/$total)';
  }

  Future<void> fetchProducts(List<ShopItem> response) async {
    loading = true;
    for (final element in response) {
      if (!itemProducts.containsKey(element)) {
        itemProducts[element] = [];
      }
      itemProducts[element]!.addAll(await productService.getAllByTagAndCategory(
          element.name, element.category.value));
    }
    itemProducts.refresh();
    loading = false;
  }

  Future<double> getItemPrice(ShopItem item) async {
    if (!loading) {
      final list = itemProducts[item]!
          .where((element) => !element.isOffer)
          .map((e) => e.price);

      if (list.isNotEmpty) {
        return list.reduce(max).toDouble() * item.amount;
      }

      return _defaultPricePerCategory(item.category.value) * item.amount;
    } else {
      return Future.delayed(1.seconds, () => getItemPrice(item));
    }
  }

  double _defaultPricePerCategory(String category) {
    switch (category) {
      case 'carnico':
        return 10;
      case 'fruta/verdura':
        return 5;
      case 'limpieza':
        return 12;
      default:
        return 7;
    }
  }

  Future<double> getCategoryPrice(List<ShopItem> value) async {
    var response = 0.0;
    for (final item in value) {
      response += await getItemPrice(item);
    }
    return response;
  }

  Future<double> getTotalValue() async {
    var response = 0.0;
    for (final item in itemMap.values.toList()) {
      response += await getCategoryPrice(item);
    }
    return response;
  }
}
