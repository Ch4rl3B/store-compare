import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactivePinCode extends ReactiveFormField<String, String> {
  ReactivePinCode(
    BuildContext context, {
    super.key,
    super.formControlName,
    super.formControl,
    required ValueChanged<String> onCompleted,
  }) : super(builder: (ReactiveFormFieldState<String, String> field) {
          return PinCodeTextField(
            appContext: context,
            length: 6,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              fieldHeight: Get.width / 9,
              fieldWidth: Get.width / 9,
              activeColor: Colors.white,
              disabledColor: Colors.white,
              errorBorderColor: Colors.white,
              inactiveColor: Colors.white,
              selectedColor: Colors.green,
              borderWidth: 1,
            ),
            cursorColor: Colors.white,
            textStyle: TextStyle(
              fontSize: Get.width / 9.8,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            keyboardType: TextInputType.number,
            animationDuration: const Duration(milliseconds: 300),
            textCapitalization: TextCapitalization.characters,
            onChanged: (value) {
              field.didChange(value);
            },
            onCompleted: onCompleted,
          );
        });

  @override
  ReactiveFormFieldState<String, String> createState() =>
      ReactiveFormFieldState<String, String>();
}
