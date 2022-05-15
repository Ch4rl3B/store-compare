import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/models/nomenclator.dart';
import 'package:store_compare/models/shop_item.dart';
import 'package:store_compare/views/shop_list/shop_list.dart';
import 'package:store_compare/views/shop_list/widgets/shop_item_list_element.dart';

class ShopItemList extends StatelessWidget {
  final List<ShopItem> list;
  final Function(Nomenclator, int) onItemSelected;
  final Function(Nomenclator, int) onItemDismissed;

  const ShopItemList({
    super.key,
    required this.list,
    required this.onItemSelected,
    required this.onItemDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
        itemExtent: 45,
        itemCount: list.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey(list[index].objectId),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return Get.defaultDialog<bool>(
                  title: 'Eliminar item',
                  middleText: 'Esta acción no se puede deshacer',
                  textConfirm: 'Eliminar',
                  textCancel: 'Mejor no',
                  onConfirm: () {
                    Get.back(result: true);
                  },
                  onCancel: () {
                    Get.back(result: false);
                  });
            }
            return false;
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              onItemDismissed.call(list[index].category, index);
            }
          },
          background: Container(
            color: context.theme.errorColor,
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: FutureBuilder<double>(
              future:
              Get.find<ShopListController>().getItemPrice(list[index]),
              initialData: 0,
              builder: (context, snapshot) {
                return ShopItemListElement(
                  item: list[index],
                  price: !snapshot.hasData
                      ? 'loading'
                      : '€ ${snapshot.data!.toStringAsFixed(2)}',
                  onChanged: (_) =>
                      onItemSelected(list[index].category, index),
                );
              }),
        ));
  }
}
