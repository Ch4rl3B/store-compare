import 'package:get/get.dart';
import 'package:store_compare/constants/paths.dart';
import 'package:store_compare/views/home/home_controller.dart';
import 'package:store_compare/views/views.dart';

class AppRoutes {
  static final appRoutes = {
    Paths.splash: (context) {
      Get.put(SplashController());
      return const SplashView();
    },
    Paths.home: (context) {
      Get
        ..put(HomeController())
        ..put(ShopListController());
      return const HomeView();
    },
  };
}
