import 'dart:math';

import 'package:get/get.dart';
import 'package:store_compare/services/product_service.dart';
import 'package:store_compare/views/home/home_states.dart';

class HomeController extends GetxController with StateMixin<HomeStates> {
  final ProductServiceContract productService =
      Get.find<ProductServiceContract>();
  late List<Product> products;
  late List<Product> filtered;

  @override
  void onInit() {
    change(HomeStates.loading, status: RxStatus.loading());
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    products = await productService.fetchAll();
    change(HomeStates.settled, status: RxStatus.success());
  }

  void search() {
    if (state! == HomeStates.search) {
      loadData();
    } else {
      change(HomeStates.search, status: RxStatus.success());
    }
  }

  Future<void> filter(String value) async {
    filtered = await productService.filter(value);
    products = filtered.toSet().toList();
    refresh();
  }

  String get getMax {
    return filtered
        .where((element) => element == products.first)
        .map((e) => e.price)
        .reduce(max)
        .toString();
  }

  String get getMin {
    return filtered
        .where((element) => element == products.first && !element.isOffer)
        .map((e) => e.price)
        .reduce(min)
        .toString();
  }

  String get getMedia {
    final list = filtered
        .where((element) => element == products.first)
        .map((e) => e.price)
        .toList();

    if (list.isNotEmpty) {
      // Count occurrences of each item
      final folded = list.fold({}, (Map acc, num curr) {
        acc[curr] = (acc[curr] ?? 0) + 1;
        return acc;
      });

      // Sort the keys by its occurrences
      final sortedKeys = folded.keys.toList()
        ..sort((a, b) => folded[b].compareTo(folded[a]));

      return sortedKeys.first.toString();
    }
    return products.first.price.toString();
  }

  int get offers {
    return filtered
        .where((element) => element == products.first && element.isOffer)
        .length;
  }
}
