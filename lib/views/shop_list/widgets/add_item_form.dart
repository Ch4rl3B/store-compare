import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:store_compare/constants/keys.dart';

class AddItemForm extends StatelessWidget {
  final ValueChanged<Map<String, dynamic>> submit;

  const AddItemForm({Key? key, required this.submit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
        form: () => fb.group({
          keyItemName: ['', Validators.required],
          keyItemAmount: [1, Validators.min(1)]
        }),
        builder: (context, form, child) => Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: ReactiveTextField<String>(
                          validationMessages: (control) => {
                            ValidationMessage.required:
                            'El campo no debe estar vacío'
                          },
                          decoration:
                          const InputDecoration(label: Text('Item')),
                          formControlName: keyItemName,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: ReactiveTextField<int>(
                          formControlName: keyItemAmount,
                          validationMessages: (control) =>
                          {ValidationMessage.min: '+ de 1'},
                          decoration:
                          const InputDecoration(label: Text('Cantidad')),
                        )),
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
                          form.reset(value: {
                            keyItemAmount : 1
                          });
                        }
                            : null,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Adicionar'))
                )),
            const SizedBox(
              height: 4,
            ),
          ],
        ) );
  }
}
