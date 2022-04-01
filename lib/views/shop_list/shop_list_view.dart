import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/views/shop_list/shop_list_controller.dart';
import 'package:store_compare/views/shop_list/widgets/add_item_form.dart';
import 'package:store_compare/views/shop_list/widgets/shop_item_list.dart';

class ShopListView extends GetView<ShopListController> {
  const ShopListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: AddItemForm(submit: controller.addNewItem,)),
        Expanded(
          flex: 3,
          child: Obx(() => ShopItemList(
                list: controller.itemList.value,
                onItemSelected: controller.toggle,
                onRefresh: controller.fetchItems,
                onItemDismissed: controller.dropItem,
              )),
        ),
      ],
    );
  }
}
