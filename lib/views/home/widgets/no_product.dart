import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class NoProduct extends StatelessWidget {
  const NoProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_shopping_cart,
            size: 50,
          ),
          const SizedBox(
            height: 8,
          ),
          Text('No results found',
              style: context.theme.textTheme.labelLarge?.copyWith(fontSize: 22))
        ],
      ),
    );
  }
}
