import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/models/product.dart';
import 'package:store_compare/views/home/home_controller.dart';
import 'package:store_compare/views/home/widgets/product_list_item.dart';

class ProductList extends GetView<HomeController> {
  final List<Product> products;
  final Future<void> Function() onRefresh;
  final Function(Product)? onItemTap;
  final Function(Product)? onItemLongPress;
  final VoidCallback? onDoubleTap;

  const ProductList(
      {Key? key,
      required this.products,
      required this.onRefresh,
      this.onItemTap,
      this.onDoubleTap,
      this.onItemLongPress})
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
                      ..addAll(entry.value.map((e) => ProductListItem(
                            product: e,
                            onItemTap: () => onItemTap?.call(e),
                            onItemLongPress: () => onItemLongPress?.call(e),
                            iconData: controller.getCategoryIcon(e.category),
                          )));
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
      GestureDetector(
        onDoubleTap: onDoubleTap,
        child: Card(
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
        ),
      );
}
