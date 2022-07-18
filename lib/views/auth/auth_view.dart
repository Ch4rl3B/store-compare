import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:store_compare/views/auth/auth.dart';
import 'package:store_compare/views/auth/reactive_pin_code.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: controller.obx(
        (state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_stateWidget(state!)],
        ),
        onError: (errorMsg) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Icon(
                Icons.error,
                size: 50,
                color: Theme.of(context).errorColor,
              ),
            ),
            Text(
              errorMsg!,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _stateWidget(AuthStates state) {
    switch (state) {
      case AuthStates.init:
        return _formWidget();
      case AuthStates.wrong:
        return const Text(
          'Wrong...',
          style: TextStyle(fontSize: 24, color: Colors.white),
        );
    }
  }

  Widget _formWidget() => ReactiveForm(
        formGroup: controller.form,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 8),
          child: Column(
            children: [
              const Text(
                'Introduzca el código',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ReactivePinCode(Get.context!,
                  key: const Key('code'),
                  formControlName: 'code',
                  onCompleted: (_) => controller.doAuth()),
            ],
          ),
        ),
      );
}
