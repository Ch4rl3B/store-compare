import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/models/product.dart';
import 'package:store_compare/views/home/home_controller.dart';

class ProductList extends GetView<HomeController> {
  final List<Product> products;
  final Future<void> Function() onRefresh;
  final Function(Product)? onItemTap;

  const ProductList(
      {Key? key,
      required this.products,
      required this.onRefresh,
      this.onItemTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              itemExtent: 70,
              children: products
                  .map((product) => ListTile(
                        key: ValueKey(product.objectId),
                        onTap: () => onItemTap?.call(product),
                        leading: SizedBox(
                          width: 70,
                          child: Center(
                              child: Icon(categories[product.category],
                                  size: 35,
                                  color: product.isPrimary
                                      ? context.theme.toggleableActiveColor
                                      : null)),
                        ),
                        title: Text.rich(
                          TextSpan(
                              text: product.productName,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: product.isPrimary
                                      ? context.theme.toggleableActiveColor
                                      : null),
                              children: [
                                if (product.isOffer)
                                  const TextSpan(
                                      text: ' ☻ ',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.amber))
                              ]),
                        ),
                        subtitle:
                            Text(product.tag, style: const TextStyle(fontSize: 15)),
                        trailing: SizedBox(
                          width: 70,
                          child: Center(
                            child: Text(
                              '€ ${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: context.theme.colorScheme.primary),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
        Divider(color: context.theme.colorScheme.onBackground, height: 2,),
        const SizedBox(height: 4,),
        Row(
          children: [
            Expanded(child: Container()),
            Text('Total: €${controller.getTotalValue(products)}', style: TextStyle(
                fontSize: 14,
                color: context.theme.colorScheme.primary),
              textAlign: TextAlign.end,),
            const SizedBox(width: 24,)
          ],
        )
      ],
    );
  }
}
