import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:store_compare/constants/paths.dart';
import 'package:store_compare/services/auth_service.dart';
import 'package:store_compare/views/auth/auth_states.dart';

class AuthController extends GetxController with StateMixin<AuthStates> {
  late AuthService service;
  FormGroup form = FormGroup({
    'code': FormControl<String>(
        validators: [Validators.required, Validators.minLength(5)]),
  });

  @override
  void onInit() {
    loading();
    super.onInit();
  }

  Future<void> loading() async {
    service = Get.find<AuthService>();
    change(AuthStates.init, status: RxStatus.success());
  }

  void doAuth() {
    service.authenticate(form.value['code']! as String).then((value) {
      if (value) {
        goHome();
      } else {
        change(AuthStates.wrong,
            status: RxStatus.error('El codigo no es valido'));
      }
    });
  }

  void goHome() {
    Get.offNamed(Paths.home);
  }

  @override
  void onClose() {
    Get.delete<AuthService>();
    super.onClose();
  }
}
