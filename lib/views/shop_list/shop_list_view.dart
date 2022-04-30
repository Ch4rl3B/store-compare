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
        SizedBox(
            height: 210,
            width: double.infinity,
            child: AddItemForm(submit: controller.addNewItem,)),
        Expanded(
          flex: 3,
          child: Obx(() => ShopItemList(
                // ignore: invalid_use_of_protected_member
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
