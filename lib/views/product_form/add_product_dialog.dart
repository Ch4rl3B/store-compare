import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/helpers/num_value_accesor.dart';
import 'package:store_compare/views/product_form/add_product_dialog_controller.dart';

class AddProductDialog extends GetView<AddProductDialogController> {
  const AddProductDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        leading: IconButton(
          key: const ValueKey('#close'),
          onPressed: Get.back,
          icon: const Icon(Icons.close),
          tooltip: 'Close wihout save',
        ),
        actions: [
          IconButton(
            key: const ValueKey('#save'),
            onPressed: controller.saveOne,
            icon: const Icon(Icons.save),
            tooltip: 'Save and close',
          )
        ],
      ),
      body: ReactiveForm(
        formGroup: controller.form,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 12),
          itemExtent: 67,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReactiveValueListenableBuilder(
                    key: const ValueKey(keyAmount),
                    formControlName: keyAmount,
                    builder: (context, field, child) => Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Text(
                            'Cantidad: ${field.value.toString()}',
                            style: context.theme.textTheme.bodyLarge,
                          ),
                        )),
                ReactiveSlider(
                  key: const ValueKey('$keyAmount-slider'),
                  formControlName: keyAmount,
                  min: 1,
                  max: 10,
                  divisions: 10,
                  labelBuilder: (value) => value.toStringAsFixed(0),
                ),
              ],
            ),
            ReactiveDatePicker(
                key: const ValueKey(keyShopDate),
                formControlName: keyShopDate,
                errorInvalidText: 'El campo no debe estar vacío',
                builder: (context, picker, child) {
                  return ReactiveTextField(
                    formControlName: keyShopDate,
                    onTap: picker.showPicker,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.date_range),
                        label: Text('Fecha de la Compra')),
                    valueAccessor: DateTimeValueAccessor(
                        dateTimeFormat: DateFormat('dd.MM.yyyy')),
                    readOnly: true,
                  );
                },
                firstDate: DateTime(2022, 5, 27),
                lastDate: DateTime.now().addDays(1)),
            ReactiveTextField<String>(
              key: const ValueKey(keyName),
              formControlName: keyName,
              validationMessages: (control) =>
                  {'required': 'El campo no debe estar vacío'},
              decoration: const InputDecoration(label: Text('Nombre Aleman')),
            ),
            ReactiveTextField<String>(
              key: const ValueKey(keyTag),
              formControlName: keyTag,
              validationMessages: (control) =>
                  {'required': 'El campo no debe estar vacío'},
              decoration: const InputDecoration(label: Text('Identificador')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ReactiveTextField<num>(
                    key: const ValueKey(keyPrice),
                    formControlName: keyPrice,
                    valueAccessor: NumValueAccessor(),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validationMessages: (control) =>
                        {'required': 'El campo no debe estar vacío'},
                    decoration:
                        const InputDecoration(label: Text('Precio x Unidad')),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: ReactiveTextField<num>(
                    key: const ValueKey(keyRealPrice),
                    formControlName: keyRealPrice,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    valueAccessor: NumValueAccessor(),
                    validationMessages: (control) =>
                        {'required': 'El campo no debe estar vacío'},
                    decoration:
                        const InputDecoration(label: Text('Precio Total')),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ReactiveDropdownField<String>(
                  key: const ValueKey(keyCategory),
                  formControlName: keyCategory,
                  hint: const Text('Categoria:'),
                  itemHeight: kMinInteractiveDimension,
                  items: controller.categories
                      .map((entry) => DropdownMenuItem<String>(
                          value: entry.value,
                          child: Row(
                            children: [
                              Icon(icons[entry.data ?? '']),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(entry.value),
                            ],
                          )))
                      .toList()),
            ),
            ReactiveDropdownField<String>(
              key: const ValueKey(keyShop),
              formControlName: keyShop,
              items: controller.nomenclators
                  .map((e) => DropdownMenuItem<String>(
                        key: ValueKey(e.toString()),
                        value: e.value,
                        child: Text(e.value),
                      ))
                  .toList(),
              validationMessages: (control) =>
                  {'required': 'El campo no debe estar vacío'},
              decoration: const InputDecoration(label: Text('Tienda')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Primario: ',
                  style: context.theme.textTheme.bodyLarge,
                ),
                ReactiveSwitch.adaptive(
                  formControlName: keyIsPrimary,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'Rebaja: ',
                  style: context.theme.textTheme.bodyLarge,
                ),
                ReactiveSwitch.adaptive(
                  formControlName: keyIsOffer,
                  activeColor: Colors.amber,
                ),
              ],
            ),
            ReactiveFormConsumer(
              builder: (context, form, child) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                    onPressed: form.valid ? controller.saveOne : null,
                  ),
                );
              },
            ),
            ReactiveFormConsumer(
              builder: (context, form, child) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: context.theme.colorScheme.secondary),
                    icon: const Icon(Icons.cleaning_services),
                    label: const Text('Limpiar'),
                    onPressed: form.pristine ? null : controller.clean,
                  ),
                );
              },
            ),
            ReactiveFormConsumer(
              builder: (context, form, child) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: context.theme.colorScheme.error),
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                    onPressed: controller.cancel,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
