import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:store_compare/views/home/home_controller.dart';
import 'package:store_compare/views/home/home_states.dart';
import 'package:store_compare/views/home/widgets/loading_page.dart';
import 'package:store_compare/views/home/widgets/no_product.dart';
import 'package:store_compare/views/home/widgets/product_detail.dart';
import 'package:store_compare/views/home/widgets/product_list.dart';
import 'package:store_compare/views/shop_list/shop_list.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.obx(
        (state) => Scaffold(
            appBar: AppBar(
              title: Visibility(
                visible: [
                  HomeStates.details,
                  HomeStates.search,
                  HomeStates.empty
                ].contains(state),
                child: TextField(
                  key: const ValueKey('#searchField'),
                  decoration: const InputDecoration(
                    hintText: 'type to search...',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                  focusNode: controller.focusNode,
                  controller: controller.searchController,
                  onChanged: controller.filter,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              actions: [
                Visibility(
                  visible: [
                    HomeStates.list,
                    HomeStates.details,
                    HomeStates.search,
                    HomeStates.empty
                  ].contains(state),
                  child: IconButton(
                      key: const ValueKey('#search'),
                      onPressed: controller.search,
                      icon: state == HomeStates.list
                          ? const Icon(Icons.search)
                          : const Icon(Icons.cancel)),
                ),
                Visibility(
                  visible: state == HomeStates.shopList,
                  child: IconButton(
                      key: const ValueKey('#clean'),
                      onPressed: controller.cleanShopList,
                      icon: const Icon(Icons.cleaning_services_outlined)),
                ),
              ],
            ),
            backgroundColor: context.theme.scaffoldBackgroundColor,
            body: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: context.theme.dividerColor))),
              padding: const EdgeInsets.only(bottom: 8),
              child: loadState(state ?? HomeStates.loading),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
            floatingActionButton: Visibility(
              visible: [HomeStates.details, HomeStates.empty].contains(state),
              child: FloatingActionButton(
                onPressed: controller.showDialog,
                tooltip: 'Add new product',
                child: const Icon(Icons.add_shopping_cart),
              ),
            ),
            bottomNavigationBar: SalomonBottomBar(
              items: [
                SalomonBottomBarItem(
                    icon: const Icon(Icons.list_alt),
                    title: const Text('Productos')),
                SalomonBottomBarItem(
                    icon: const Icon(Icons.shopping_basket),
                    title: const Text('A Comprar')),
                /*SalomonBottomBarItem(
                    icon: const Icon(Icons.code),
                    title: const Text('Nomencladores')),*/
              ],
              currentIndex: controller.currentIndex,
              //optional, default as 0
              onTap: controller.changeIndex,
            )),
        onLoading: const LoadingPage());
  }

  Widget loadState(HomeStates homeStates) {
    switch (homeStates) {
      case HomeStates.loading:
        return const LoadingPage();
      case HomeStates.list:
        return ProductList(
            onItemLongPress: controller.onItemLongPress,
            onItemTap: controller.onItemTap,
            onDoubleTap: () => controller.onItemLongPress(null),
            onRefresh: controller.loadData,
            products: controller.products);
      case HomeStates.search:
        return ProductList(
            onItemTap: controller.onItemTap,
            onItemLongPress: controller.onItemLongPress,
            onRefresh: () async =>
                controller.filter(controller.searchController.text),
            products: controller.products);
      case HomeStates.details:
        return ProductDetail(product: controller.products.first);
      case HomeStates.empty:
        return const NoProduct();
      case HomeStates.shopList:
        return const ShopListView();
      case HomeStates.nomenclators:
        return Container(color: Colors.red,);
    }
  }
}
