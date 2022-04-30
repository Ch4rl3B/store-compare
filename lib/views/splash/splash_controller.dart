import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/constants/paths.dart';
import 'package:store_compare/services/nomenclator_service.dart';
import 'package:store_compare/services/product_service.dart';
import 'package:store_compare/services/shop_item_service.dart';
import 'package:store_compare/views/splash/splash_states.dart';

class SplashController extends GetxController with StateMixin<SplashStates> {
  @override
  void onInit() {
    loading();
    super.onInit();
  }

  Future<void> loading() async {
    change(SplashStates.loading, status: RxStatus.success());
    //Here should go all loading futures...
    await Future.wait([
      Parse().initialize(
        keyApplicationId, keyParseServerUrl,
        // ignore: invalid_return_type_for_catch_error
        clientKey: keyClientKey,
        appName: keyApplicationName,
        registeredSubClassMap: <String, ParseObjectConstructor>{
          'Products': Product.new,
          'ShopItems': ShopItem.new,
          'Nomenclators': Nomenclator.new
        },
        // ignore: invalid_return_type_for_catch_error
      ).catchError(onError),
    ]);
    Get
      ..put<ProductServiceContract>(ProductService())
      ..put<ShopItemContract>(ShopItemService());

    await fetchData();
  }

  Future<void> fetchData() async {
    change(SplashStates.fetching, status: RxStatus.success());
    //Here should go all fetching data process...
    await Get.putAsync<NomenclatorsServiceContract>(NomenclatorsService.create);
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
