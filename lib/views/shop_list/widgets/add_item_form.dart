import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/models/nomenclator.dart';
import 'package:store_compare/services/contracts.dart';

class AddItemForm extends StatelessWidget {
  final ValueChanged<Map<String, dynamic>> submit;
  final categories = Get.find<NomenclatorsServiceContract>()
      .nomenclators[Nomenclators.category];

  AddItemForm({Key? key, required this.submit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
        form: () => fb.group({
              keyItemName: ['', Validators.required],
              keyItemAmount: [1, Validators.min(1)],
              keyItemCategory: fb.control<Nomenclator>(
                  categories!.first, [Validators.required])
            }),
        builder: (context, form, child) => Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ReactiveTextField<String>(
                          validationMessages: (control) => {
                            ValidationMessage.required:
                                'El campo no debe estar vacío'
                          },
                          decoration:
                              const InputDecoration(label: Text('Item')),
                          formControlName: keyItemName,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ReactiveDropdownField<Nomenclator>(
                                    key: const ValueKey(keyItemCategory),
                                    formControlName: keyItemCategory,
                                    items: (categories ?? <Nomenclator>[])
                                        .map((e) =>
                                            DropdownMenuItem<Nomenclator>(
                                              key: ValueKey(e.objectId),
                                              value: e,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    icons[e.data],
                                                    size: 18,
                                                  ),
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(e.value)
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                    validationMessages: (control) => {
                                          ValidationMessage.required:
                                              'Requerido'
                                        },
                                    decoration: const InputDecoration(
                                        label: Text('Categoría')))),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: ReactiveTextField<int>(
                              formControlName: keyItemAmount,
                              validationMessages: (control) =>
                                  {ValidationMessage.min: '+ de 1'},
                              decoration: const InputDecoration(
                                  label: Text('Cantidad')),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    width: Get.width - 24,
                    height: 45,
                    child: ReactiveFormConsumer(
                        builder: (context, form, child) => ElevatedButton.icon(
                            onPressed: form.valid
                                ? () {
                                    submit.call(form.value);
                                    form.reset(value: {keyItemAmount: 1});
                                  }
                                : null,
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text('Adicionar')))),
                const SizedBox(
                  height: 6,
                ),
              ],
            ));
  }
}
