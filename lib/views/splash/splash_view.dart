import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_compare/views/splash/splash.dart';

class SplashView extends GetView<SplashController> {

  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme
          .of(context)
          .primaryColor,
      child: controller.obx((state) =>
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(bottom: 8),
                child: const CircularProgressIndicator(color: Colors.white,),
              ),
              _stateWidget(state!)
            ],
          ),
        onError: (errorMsg) =>
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Icon(Icons.error, size: 50,
                    color: Theme
                        .of(context)
                        .errorColor,),
                ),
                Text(errorMsg!, style: const TextStyle(fontSize: 18,
                    color: Colors.white),)
              ],
            ),
      ),
    );
  }

  Widget _stateWidget(SplashStates state) {
    switch (state) {
      case SplashStates.loading:
        return const Text('Loading...', style: TextStyle(fontSize: 24,
            color: Colors.white),);
      case SplashStates.fetching:
        return const Text('Fetching...', style: TextStyle(fontSize: 24,
            color: Colors.white),);
      case SplashStates.complete:
        return const Text('Complete...', style: TextStyle(fontSize: 24,
            color: Colors.white),);
    }
  }

}
