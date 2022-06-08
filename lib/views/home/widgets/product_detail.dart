import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/models/product.dart';
import 'package:store_compare/views/home/home_controller.dart';
import 'package:store_compare/views/home/widgets/product_list.dart';

class ProductDetail extends GetView<HomeController> {
  final Product product;

  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              width: 30,
              child: Center(
                  child: Image.asset(
                      controller.getCategoryIcon(product.category),
                      width: 35,
                      height: 35,
                      color: product.isPrimary
                          ? context.theme.toggleableActiveColor
                          : null)),
            ),
            title: Text(product.productName,
                style: TextStyle(
                    fontSize: 16,
                    color: product.isPrimary
                        ? context.theme.toggleableActiveColor
                        : null)),
            subtitle: Text(product.tag, style: const TextStyle(fontSize: 15)),
            trailing: SizedBox(
              width: 30,
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amber),
                height: 30,
                width: 30,
                child: Center(
                  child: Text(
                    controller.offers.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      primary: context.theme.colorScheme.secondary),
                  child: Text('▲: ${controller.getMax}'),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      primary: context.theme.primaryColorDark),
                  child: Text('regular: ${controller.getMedia}'),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: context.theme.primaryColorLight,
                  ),
                  child: Text('▼: ${controller.getMin}'),
                ),
              )
            ],
          ),
          Divider(color: context.theme.colorScheme.onBackground),
          Expanded(
            child: ProductList(
              onRefresh: () async =>
                  controller.filter(controller.searchController.text),
              products: controller.getProductFilteredList(product),
            ),
          ),
        ],
      ),
    );
  }
}
