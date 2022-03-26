import 'package:get/get.dart';
import 'package:store_compare/services/product_service.dart';
import 'package:store_compare/views/home/home_states.dart';


class HomeController extends GetxController with StateMixin<HomeStates> {
  final ProductService productService = Get.find<ProductService>();
  late List<Product> products;

  @override
  void onInit() {
    change(HomeStates.loading, status: RxStatus.loading());
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
     products = await productService.fetchAll();
     change(HomeStates.settled, status: RxStatus.success());
  }

  void search() {
    if(state! == HomeStates.search){
      loadData();
    } else {
      change(HomeStates.search, status: RxStatus.success());
    }
  }

  Future<void> filter(String value) async {
    products = await productService.filter(value);
    refresh();
  }
}
