import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/models/product.dart';
import 'package:store_compare/services/nomenclator_service.dart';
import 'package:store_compare/views/product_form/add_product_interface.dart';

class AddProductDialogController extends GetxController {
  final Product? bindedProduct;
  final AddProductInterface parent;
  final NomenclatorsServiceContract nomenclatorsService = Get.find();

  AddProductDialogController(this.parent, {this.bindedProduct});

  final FormGroup form = FormGroup({
    keyAmount: FormControl<int>(value: 1, validators: [
      Validators.required,
    ]),
    keyName: FormControl<String>(validators: [
      Validators.required,
    ]),
    keyTag: FormControl<String>(validators: [
      Validators.required,
    ]),
    keyPrice: FormControl<num>(validators: [
      Validators.required,
    ]),
    keyCategory: FormControl<String>(value: categories.keys.first, validators: [
      Validators.required,
    ]),
    keyRealPrice: FormControl<num>(validators: [
      Validators.required,
    ]),
    keyIsPrimary: FormControl<bool>(value: false),
    keyIsOffer: FormControl<bool>(value: false),
    keyShop: FormControl<String>(),
  });

  List<Nomenclator> get nomenclators =>
      nomenclatorsService.nomenclators[keyShop.toUpperCase()]
          ?.takeWhile((value) => value.active)
          .toList() ??
      [];

  @override
  void onInit() {
    initForm();
    if (bindedProduct != null) {
      form.control(keyName).markAsDisabled();
      form.control(keyCategory).markAsDisabled();
    }
    form.control(keyPrice).valueChanges.listen((event) {
      form.control(keyRealPrice).value = event;
    });
    super.onInit();
  }

  void saveOne() {
    Get.back();
    parent.addProduct(form.rawValue);
  }

  void clean() {
    Get.defaultDialog(
        title: 'Limpiar formulario',
        content: Text.rich(
          TextSpan(
              text: 'Se revertirán todos los valores introducidos ',
              children: [
                TextSpan(
                    text: 'Esta acción no se puede deshacer.',
                    style: TextStyle(color: Get.theme.errorColor))
              ]),
          textAlign: TextAlign.center,
        ),
        textConfirm: '   Limpiar   ',
        textCancel: 'Mejor no',
        onConfirm: () {
          initForm();
          Get.back();
        });
  }

  void initForm() {
    form.reset(value: {
      keyAmount: 1,
      keyCategory: bindedProduct?.category,
      keyName: bindedProduct?.productName,
      keyTag: bindedProduct?.tag,
      keyPrice: bindedProduct?.price,
      keyRealPrice: bindedProduct?.realPrice,
      keyIsOffer: bindedProduct?.isOffer,
      keyIsPrimary: bindedProduct?.isPrimary,
      // ignore: iterable_contains_unrelated_type
      keyShop: nomenclators.contains(bindedProduct?.shop)
          ? bindedProduct?.shop
          : null
    });
  }

  void cancel() {
    Get.defaultDialog(
        title: 'Cancelar acción',
        content: Text.rich(
          TextSpan(text: '¿Seguro que desea salir? ', children: [
            TextSpan(
                text: 'Se perderán todos los cambios.',
                style: TextStyle(color: Get.theme.errorColor))
          ]),
          textAlign: TextAlign.center,
        ),
        textConfirm: '    Salir     ',
        textCancel: 'Mejor no',
        onConfirm: () {
          Get
            ..back()
            ..back();
        });
  }
}
