import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/models/product.dart';
import 'package:store_compare/views/home/home_controller.dart';
import 'package:store_compare/views/home/widgets/product_list.dart';

class ProductDetail extends GetView<HomeController> {
  final Product product;

  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: SizedBox(
              width: 70,
              child: Center(
                  child: Icon(categories[product.category],
                      size: 35,
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
              width: 70,
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.amber),
                height: 25,
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
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      primary: context.theme.colorScheme.secondary),
                  child: Text('high: ${controller.getMax}'),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      primary: context.theme.primaryColorDark),
                  child: Text('mid: ${controller.getMedia}'),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: context.theme.primaryColorLight,
                  ),
                  child: Text('low: ${controller.getMin}'),
                ),
              )
            ],
          ),
          Divider(color: context.theme.colorScheme.onBackground),
          Expanded(
            child: ProductList(
              products: controller.filtered
                  .where((element) => element == product)
                  .toList(),
            ),
          ),
          Divider(color: context.theme.colorScheme.onBackground),
          Row(
            children: [
              Expanded(child: Container()),
              Text('Total: €${controller.getTotalValue}', style: TextStyle(
                  fontSize: 14,
                  color: context.theme.colorScheme.primary),
                textAlign: TextAlign.end,),
              const SizedBox(width: 24,)
            ],
          )
        ],
      ),
    );
  }
}
