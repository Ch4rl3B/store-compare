import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/models/product.dart';
import 'package:store_compare/views/home/home_controller.dart';

class ProductList extends GetView<HomeController> {
  final List<Product> products;
  final Future<void> Function() onRefresh;
  final Function(Product)? onItemTap;
  final Function(Product)? onItemDismiss;

  const ProductList(
      {Key? key,
      required this.products,
      required this.onRefresh,
      this.onItemTap,
      this.onItemDismiss})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemExtent: 75,
              children: products
                  .fold<Map<DateTime, List<Product>>>({}, (map, product) {
                    if (!map.containsKey(product.createdAt!.endOfDay)) {
                      map[product.createdAt!.endOfDay] = <Product>[];
                    }
                    map[product.createdAt!.endOfDay]!.add(product);
                    return map;
                  })
                  .entries
                  .fold<List<Widget>>([], (list, entry) {
                    list
                      ..add(addDateAmount(context, entry.key,
                          controller.getTotalValue(entry.value)))
                      ..addAll(entry.value.map((e) => productItem(context, e)));
                    return list;
                  }),
            ),
          ),
        ),
        Divider(
          color: context.theme.colorScheme.onBackground,
          height: 2,
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Expanded(child: Container()),
            Text(
              'Total: €${controller.getTotalValue(products)}',
              style: TextStyle(
                  fontSize: 14, color: context.theme.colorScheme.primary),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              width: 24,
            )
          ],
        )
      ],
    );
  }

  Widget addDateAmount(
          BuildContext context, DateTime dateTime, String totalValue) =>
      Card(
        color: context.theme.primaryColorLight.withOpacity(0.3),
        shadowColor: Colors.grey.withAlpha(5),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                dateTime.format('dd.MM.yyyy'),
                style: context.textTheme.titleLarge,
              ),
              Text(
                '€ $totalValue',
                style: context.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );

  Widget productItem(BuildContext context, Product product) => InkWell(
        key: ValueKey(product.objectId),
        onTap: () => onItemTap?.call(product),
        child: Dismissible(
          key: ValueKey('Dism-${product.objectId}'),
          direction: onItemDismiss != null
              ? DismissDirection.endToStart
              : DismissDirection.none,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              onItemDismiss?.call(product);
            }
            return false;
          },
          background: Container(
            color: context.theme.primaryColorLight,
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  child: Center(
                      child: Icon(categories[product.category],
                          size: 35,
                          color: product.isPrimary
                              ? context.theme.toggleableActiveColor
                              : context.theme.disabledColor)),
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
        ),
      );
}
