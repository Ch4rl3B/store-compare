import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/models/shop_item.dart';
import 'package:supercharged/supercharged.dart';

class ShopItemListElement extends StatefulWidget {
  final ShopItem item;
  final ValueChanged<bool?>? onChanged;

  const ShopItemListElement({Key? key, required this.item, this.onChanged})
      : super(key: key);

  @override
  State<ShopItemListElement> createState() => _ShopItemListElementState();
}

class _ShopItemListElementState extends State<ShopItemListElement> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          if (loading)
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(right: 18, left: 12),
              child: const CircularProgressIndicator(),
            )
          else
            Checkbox(value: widget.item.completed, onChanged: (i){
              setState(() {
                loading = true;
                widget.onChanged?.call(i);
              });
              Future.delayed(1.5.seconds, (){
                setState(() {
                  loading = false;
                });
              });
            }),
          Icon(icons[widget.item.category.data], size: 18,),
          const SizedBox(width: 4,),
          Expanded(
            child: Text(
              '${widget.item.name} x${widget.item.amount}',
              style: context.theme.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
