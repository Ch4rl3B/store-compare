import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/models/shop_item.dart';
import 'package:store_compare/views/shop_list/widgets/shop_item_list_element.dart';

class ShopItemList extends StatelessWidget {
  final List<ShopItem> list;
  final ValueChanged<int> onItemSelected;
  final Future<void> Function() onRefresh;
  final ValueChanged<int> onItemDismissed;

  const ShopItemList({
    Key? key,
    required this.list,
    required this.onItemSelected,
    required this.onRefresh,
    required this.onItemDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
          padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
          itemExtent: 45,
          itemCount: list.length,
          itemBuilder: (context, index) => Dismissible(
                key: ValueKey(list[index].objectId),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    return await Get.defaultDialog<bool>(
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
                    onItemDismissed.call(index);
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
                child: ShopItemListElement(
                  item: list[index],
                  onChanged: (_) => onItemSelected(index),
                ),
              )),
    );
  }
}
