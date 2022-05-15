import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: (Get.height - kToolbarHeight * 5) / 2,
          horizontal: (Get.width - kToolbarHeight * 3) / 2),
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Saving...', style: Get.theme.textTheme.bodyLarge,),
            const SizedBox(
                width: kToolbarHeight * 2,
                height: kToolbarHeight * 2,
                child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}
