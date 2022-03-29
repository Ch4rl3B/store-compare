import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/views/home/home_controller.dart';
import 'package:store_compare/views/home/home_states.dart';
import 'package:store_compare/views/home/widgets/product_detail.dart';
import 'package:store_compare/views/home/widgets/product_list.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: controller.obx((state) => Visibility(
              visible: state! == HomeStates.search,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'type to search...',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: controller.filter,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )),
        actions: [
          IconButton(
              onPressed: controller.search,
              icon: controller.obx((state) => state! == HomeStates.settled
                  ? const Icon(Icons.search)
                  : const Icon(Icons.cancel)))
        ],
      ),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: controller.obx(
          (state) => controller.products.length > 1
              ? ProductList(products: controller.products)
              : ProductDetail(product: controller.products.first,),
          onLoading: Column(
            children: [
              LinearProgressIndicator(
                color: Theme.of(context).toggleableActiveColor,
              ),
              Expanded(
                  child: Center(
                child: Text(
                  'Getting items...',
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).toggleableActiveColor),
                ),
              ))
            ],
          )),
    );
  }
}
