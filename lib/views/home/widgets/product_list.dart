import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/models/product.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;

  const ProductList({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      itemExtent: 70,
      children: products
          .map((product) => ListTile(
              key: ValueKey(product.objectId),
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
              subtitle: Text(product.tag,
                  style: const TextStyle(fontSize: 15)),
        trailing: SizedBox(
          width: 70,
          child: Center(
            child: Text.rich(
              TextSpan(text: product.price.toString(), style: TextStyle(
                  fontSize: 14,
                  color: context.theme.colorScheme.primary),
                  children: [
                    if(product.isOffer)
                      const TextSpan(text: ' ☻ ', style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber))
                  ]
              ),
            ),
          ),
        ),
      ))
          .toList(),
    );
  }
}
