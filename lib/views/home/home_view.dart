import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/views/home/home_controller.dart';
import 'package:store_compare/constants/categories.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: controller.obx(
          (state) => ListView(
                itemExtent: 70,
                children: controller.products
                    .map((product) => ListTile(
                          leading: SizedBox(
                            width: 70,
                            child: Center(
                              child: Icon(categories[product.category], size: 35)
                            ),
                          ),
                          title: Text(product.productName,
                              style: const TextStyle(fontSize: 16)),
                          subtitle:  Text(product.tag,
                              style: const TextStyle(fontSize: 15)),
                          trailing: SizedBox(
                            width: 70,
                            child: Center(
                              child: Text(
                                product.realPrice.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .colorScheme.primary),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
          onLoading: Column(
            children: [
              LinearProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
              Expanded(
                  child: Center(
                child: Text(
                  'Getting items...',
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ))
            ],
          )),
    );
  }
}
