import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:store_compare/constants/paths.dart';
import 'package:store_compare/services/product_service.dart';
import 'package:store_compare/views/splash/splash_states.dart';
import 'package:supercharged/supercharged.dart';

class SplashController extends GetxController with StateMixin<SplashStates> {
  final keyApplicationId = 'IRNq7nLL7wg6lzkBOYMoz4AP7jDfKnvXyDoOPDY4';
  final keyClientKey = 'PBlxGtwOGe24VEisoySlyj3MgjLHV8uAQDZIOvQd';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  @override
  void onInit() {
    loading();
    super.onInit();
  }

  Future<void> loading() async {
    change(SplashStates.loading, status: RxStatus.success());
    //Here should go all loading futures...
    await Future.wait([
      Parse().initialize(keyApplicationId, keyParseServerUrl,
          // ignore: invalid_return_type_for_catch_error
          clientKey: keyClientKey,
          registeredSubClassMap: <String, ParseObjectConstructor>{
            'Products': Product.new,
          },
      // ignore: invalid_return_type_for_catch_error
      ).catchError(onError),
    ]);
    Get.put(ProductService());
    await fetchData();
  }

  Future<void> fetchData() async {
    change(SplashStates.fetching, status: RxStatus.success());
    //Here should go all fetching data process...
    await Future.delayed(5.seconds);
    change(SplashStates.complete, status: RxStatus.success());
    goHome();
  }

  void goHome() {
    Get.offNamed(Paths.home);
  }

  void onError(Object error) {
    change(SplashStates.complete, status: RxStatus.error(error.toString()));
  }

  @override
  void onClose() {
    Get.delete<ProductService>();
    super.onClose();
  }
}
