import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/helpers/extensions.dart';
import 'package:store_compare/services/product_service.dart';
import 'package:store_compare/views/home/home_states.dart';
import 'package:store_compare/views/home/widgets/loading_dialog.dart';
import 'package:store_compare/views/product_form/add_product_dialog.dart';
import 'package:store_compare/views/product_form/add_product_dialog_controller.dart';
import 'package:store_compare/views/product_form/add_product_interface.dart';

class HomeController extends GetxController
    with StateMixin<HomeStates>
    implements AddProductInterface {
  final ProductServiceContract productService =
      Get.find<ProductServiceContract>();
  late List<Product> products;
  late List<Product> filtered;
  final searchController = TextEditingController();
  Timer? timer;

  HomeStates? previousState;




  @override
  void onInit() {
    change(HomeStates.loading, status: RxStatus.loading());
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    filtered = await productService.fetchAll();
    products = filtered;
    searchController.clear();
    change(HomeStates.list, status: RxStatus.success());
  }

  void search() {
    if ([HomeStates.details, HomeStates.search].contains(state)) {
      loadData();
    } else {
      change(HomeStates.search, status: RxStatus.success());
    }
  }

  void filter(String value) {
    if (timer != null) {
      timer!.cancel();
    }
    timer = setTimer(value);
  }

  Timer setTimer(String value) {
    return Timer(500.milliseconds, () async {
      debugPrint('text to search: $value');
      filtered = await productService.filter(value);
      products = filtered.toSet().toList();
      if(products.isEmpty){
        change(HomeStates.empty, status: RxStatus.success());
      } else if(products.length == 1){
        change(HomeStates.details, status: RxStatus.success());
      } else {
        change(HomeStates.search, status: RxStatus.success());
      }
      timer = null;
    });
  }

  String get getMax {
    final list = filtered
        .where((element) => element == products.first && !element.isOffer)
        .map((e) => e.price);

    if(list.isNotEmpty) {
      return list.reduce(max)
          .toString();
    }

    return '--';
  }

  String get getMin {
    final list = filtered
        .where((element) => element == products.first && !element.isOffer)
        .map((e) => e.price);

    if(list.isNotEmpty) {
      return list.reduce(min)
          .toString();
    }

    return '--';
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

  String getTotalValue(List<Product> products) {
    final list = products
        .map((e) => e.price);
    if(list.isNotEmpty){
      return list
          .reduce((a, b) => a + b)
          .toStringAsFixed(2);
    }
    return '0.00';
  }

  int get offers {
    return filtered
        .where((element) => element == products.first && element.isOffer)
        .length;
  }

  void showDialog() {
    Get.put(AddProductDialogController(this,
        bindedProduct: products.length == 1 ? products.first : null));
    Get.dialog(const AddProductDialog(),
            barrierDismissible: false, useSafeArea: true)
        .then((_) {
      Get.delete<AddProductDialogController>();
    });
  }

  @override
  Future<void> addProduct(Map<String, dynamic> formData) async {
    debugPrint(formData.toString());
    final amount = formData.remove(keyAmount);
    final productsToSave = List.generate(
        amount, (index) => Product.fromMap(formData));
    unawaited(Get.dialog(const LoadingDialog(), barrierDismissible: true));
    try {
      _populateLists(await productService.saveBulk(productsToSave));
      Get
        ..back()
        ..snackbar('Salva completa', 'Los productos han sido salvados',
            duration: 2.seconds,
            backgroundColor: Get.theme.primaryColorLight,
            snackPosition: SnackPosition.BOTTOM,
            isDismissible: true,
            margin: const EdgeInsets.only(bottom: 12));
    } catch (ex){
      Get.back();
      Get.context?.saveError(ex.toString());
    }
  }

  @override
  Future<void> editProduct(Map<String, dynamic> formData) {
    throw UnimplementedError();
  }

  void _populateLists(List<Product> newProducts) {
    if(products.length > 1) {
      products.addAll(newProducts);
    }
    if(products.isEmpty){
      products.add(newProducts.last);
      change(HomeStates.details, status: RxStatus.success());
    }
    filtered.addAll(newProducts);
    refresh();
  }

  void changeIndex(int index) {
    switch(index){
      case 1  :
        previousState = state;
        change(HomeStates.shopList, status: RxStatus.success());
        break;
      default:
        change(previousState ?? HomeStates.list, status: RxStatus.success());
    }
  }

  int get currentIndex => state! == HomeStates.shopList ? 1 : 0;


  void onItemTap(Product p1) {
    searchController.text = p1.productName;
    filter(p1.searchCode.toString());
  }
}
