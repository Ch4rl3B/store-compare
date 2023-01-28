import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/constants/paths.dart';
import 'package:store_compare/helpers/extensions.dart';
import 'package:store_compare/models/nomenclator.dart';
import 'package:store_compare/services/auth_service.dart';
import 'package:store_compare/services/product_service.dart';
import 'package:store_compare/views/home/home_states.dart';
import 'package:store_compare/views/home/widgets/loading_dialog.dart';
import 'package:store_compare/views/product_form/add_product_dialog.dart';
import 'package:store_compare/views/product_form/add_product_dialog_controller.dart';
import 'package:store_compare/views/product_form/add_product_interface.dart';
import 'package:store_compare/views/shop_list/shop_list.dart';

class HomeController extends GetxController
    with StateMixin<HomeStates>
    implements AddProductInterface {
  final ProductServiceContract productService = Get.find();
  final NomenclatorsServiceContract nomenclatorsService = Get.find();
  List<Product> products = [];
  List<Product> filtered = [];
  final searchController = TextEditingController();
  Timer? timer;
  final FocusNode focusNode = FocusNode(debugLabel: 'searchTextField');

  HomeStates? previousState;

  @override
  void onInit() {
    change(HomeStates.loading, status: RxStatus.loading());
    if (Get.find<AuthService>().isUnlocked) {
      loadData();
    } else {
      Future.delayed(1.seconds, () {
        Get
          ..offNamed(Paths.auth)
          ..delete<HomeController>();
      });
    }
    super.onInit();
  }

  Future<void> loadData() async {
    products.clear();
    filtered.clear();
    filtered = await productService.fetchAll();
    products = List.from(filtered);
    searchController.clear();
    change(HomeStates.list, status: RxStatus.success());
  }

  void search() {
    if ([HomeStates.details, HomeStates.search].contains(state)) {
      loadData();
      focusNode.unfocus();
    } else {
      change(HomeStates.search, status: RxStatus.success());
      focusNode.requestFocus();
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
      if (products.isEmpty) {
        change(HomeStates.empty, status: RxStatus.success());
      } else if (products.length == 1) {
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

    if (list.isNotEmpty) {
      return list.reduce(max).toStringAsFixed(2);
    }

    return '--';
  }

  String get getMin {
    final list = filtered
        .where((element) => element == products.first && !element.isOffer)
        .map((e) => e.price);

    if (list.isNotEmpty) {
      return list.reduce(min).toStringAsFixed(2);
    }

    return '--';
  }

  String get getBestShop {
    final list = filtered
        .where((element) => element == products.first && !element.isOffer);

    if (list.isNotEmpty) {
      return list.reduce((a, b) => a.price <= b.price ? a : b).shop;
    }

    return 'unknown';
  }

  String get getMedia {
    final list = filtered
        .where((element) => element == products.first)
        .map((e) => e.price)
        .toList();

    if (list.isNotEmpty) {
      // Count occurrences of each item
      final folded = list.fold(<num, int>{}, (Map<num, int> acc, num curr) {
        acc[curr] = (acc[curr] ?? 0) + 1;
        return acc;
      });

      // Sort the keys by its occurrences
      final sortedKeys = folded.keys.toList()
        ..sort((a, b) => folded[b]!.compareTo(folded[a]!));

      return sortedKeys.first.toStringAsFixed(2);
    }
    return products.first.price.toStringAsFixed(2);
  }

  String getTotalValue(List<Product> products) {
    final list = products.map((e) => e.realPrice);
    if (list.isNotEmpty) {
      return list.reduce((a, b) => a + b).toStringAsFixed(2);
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
        bindedProduct: products.length == 1
            ? products.first
            : Product.fromName(searchController.text)));
    Get.dialog(const AddProductDialog(),
            barrierDismissible: false, useSafeArea: true)
        .then((_) {
      Get.delete<AddProductDialogController>();
    });
  }

  @override
  Future<void> addProduct(Map<String, dynamic> formData) async {
    debugPrint(formData.toString());
    final amount = formData.remove(keyAmount) as int;
    final productsToSave =
        List.generate(amount, (index) => Product.fromMap(formData));
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
    } catch (ex) {
      Get.back();
      Get.context?.saveError(ex.toString());
    }
  }

  @override
  Future<void> editProduct(Map<String, dynamic> formData) {
    throw UnimplementedError();
  }

  void _populateLists(List<Product> newProducts) {
    if (products.length > 1) {
      products.insertAll(0, newProducts);
    }
    if (products.isEmpty) {
      products.insert(0, newProducts.last);
      change(HomeStates.details, status: RxStatus.success());
    }
    filtered.insertAll(0, newProducts);
    refresh();
  }

  void changeIndex(int index) {
    previousState = state;
    switch (index) {
      case 1:
        change(HomeStates.shopList, status: RxStatus.success());
        break;
      case 2:
        change(HomeStates.nomenclators, status: RxStatus.success());
        break;
      default:
        change(HomeStates.list, status: RxStatus.success());
    }
  }

  int get currentIndex {
    switch (state) {
      case HomeStates.shopList:
        return 1;
      case HomeStates.nomenclators:
        return 2;
      case HomeStates.loading:
      case HomeStates.list:
      case HomeStates.search:
      case HomeStates.details:
      case HomeStates.empty:
      case null:
        return 0;
    }
  }

  void onItemTap(Product p1) {
    searchController.text = p1.productName;
    filter(p1.searchCode.toString());
  }

  void cleanShopList() {
    Get.find<ShopListController>().dropItems();
  }

  void onItemLongPress(Product? p1) {
    Get.put(AddProductDialogController(this, bindedProduct: p1));
    Get.dialog(const AddProductDialog(),
            barrierDismissible: false, useSafeArea: true)
        .then((_) {
      Get.delete<AddProductDialogController>();
    });
  }

  String getCategoryIcon(String category) {
    final categories = nomenclatorsService.nomenclators[Nomenclators.category];
    return images[categories
            ?.firstWhere((element) => element.value == category,
                orElse: Nomenclator.new)
            .data ??
        'bug']!;
  }

  List<Product> getProductFilteredList(Product product) {
    final list = filtered.where((element) => element == product).toList();
    if (list.isNotEmpty) {
      return list
        ..sort((a, b) => (b.shopDate ?? DateTime(1990))
            .compareTo(a.shopDate ?? DateTime(1990)));
    } else {
      return [];
    }
  }
}
