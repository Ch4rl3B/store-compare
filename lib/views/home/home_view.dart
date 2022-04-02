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
  const HomeView({Key? key}) : super(key: key);

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
                  controller: controller.searchController,
                  onChanged: controller.filter,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              actions: [
                Visibility(
                  visible: state! != HomeStates.shopList,
                  child: IconButton(
                      key: const ValueKey('#search'),
                      onPressed: controller.search,
                      icon: state == HomeStates.list
                          ? const Icon(Icons.search)
                          : const Icon(Icons.cancel)),
                ),
              ],
            ),
            backgroundColor: context.theme.scaffoldBackgroundColor,
            body: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: context.theme.dividerColor))),
              padding: const EdgeInsets.only(bottom: 8),
              child: loadState(state),
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
            onItemTap: controller.onItemTap,
            onRefresh: controller.loadData,
            products: controller.products);
      case HomeStates.search:
        return ProductList(
            onRefresh: () async =>
                controller.filter(controller.searchController.text),
            products: controller.products);
      case HomeStates.details:
        return ProductDetail(product: controller.products.first);
      case HomeStates.empty:
        return const NoProduct();
      case HomeStates.shopList:
        return const ShopListView();
    }
  }
}
