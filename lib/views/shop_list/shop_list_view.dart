import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/views/shop_list/shop_list_controller.dart';
import 'package:store_compare/views/shop_list/widgets/add_item_form.dart';
import 'package:store_compare/views/shop_list/widgets/shop_item_list.dart';

class ShopListView extends GetView<ShopListController> {
  const ShopListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 250,
            width: double.infinity,
            child: AddItemForm(
              submit: controller.addNewItem,
            )),
        Expanded(
          child: Obx(() => RefreshIndicator(
                onRefresh: controller.fetchItems,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                      // ignore: invalid_use_of_protected_member
                      itemCount: controller.itemMap.value.keys.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: itemBuilder),
                ),
              )),
        )
      ],
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final element = controller.itemMap.entries.toList()[index];
    return Dismissible(
      key: ValueKey(element.key.objectId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return Get.defaultDialog<bool>(
              title: 'Eliminar categoría',
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
          controller.dropCategory(element.key, clear: true);
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
      child: ExpandableNotifier(
          child: ScrollOnExpand(
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToCollapse: true,
              ),
              header: Container(
                height: 45,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(icons[element.key.data], size: 18,),
                    const SizedBox(width: 2,),
                    Text(element.key.value.toUpperCase()),
                    const SizedBox(width: 2,),
                    Text(controller.getAmount(element.value))
                  ],
                ),
              ),
              collapsed: Container(),
              expanded: SizedBox(
                height: element.value.length * 45,
                child: ShopItemList(
                  list: element.value,
                  onItemSelected: controller.toggle,
                  onItemDismissed: controller.dropItem,
                ),
              ),
              builder: (_, collapsed, expanded) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4, right: 8, bottom: 10),
                  child: Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: const ExpandableThemeData(
                        crossFadePoint: 0),
                  ),
                );
              },
              ),
            ),
          ),
    );
  }
}
