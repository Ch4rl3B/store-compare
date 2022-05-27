import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback? onItemTap;
  final VoidCallback? onItemLongPress;
  final String? iconData;

  const ProductListItem(
      {super.key,
      required this.product,
      this.onItemLongPress,
      this.onItemTap,
      this.iconData})
     ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey(product.objectId),
      onTap: onItemTap,
      onLongPress: onItemLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            SizedBox(
              width: 56,
              child: Image.asset(iconData ?? images['bug']!,
                  width: 40,
                  height: 40),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.productName,
                    style: TextStyle(
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                        color: product.isPrimary
                            ? context.theme.toggleableActiveColor
                            : null)),
                Text(product.tag,
                    style: const TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    )),
                Text(product.shop,
                    style: const TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            )),
            SizedBox(
              width: 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('€ ${product.realPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          backgroundColor: product.isOffer
                              ? Colors.amber
                              : Colors.transparent,
                          fontSize: 14,
                          color: context.theme.colorScheme.primary)),
                  const SizedBox(
                    height: 2,
                  ),
                  if (product.price != product.realPrice)
                    Text(
                      '€ ${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: context.theme.colorScheme.secondary),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
