import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_raw_autocomplete/reactive_raw_autocomplete.dart';
import 'package:store_compare/constants/categories.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/models/nomenclator.dart';
import 'package:store_compare/services/contracts.dart';

class _Option {
  final String value;
  final bool downloaded;

  _Option(this.value, {this.downloaded = false});

  @override
  String toString() => value;
}

class AddItemForm extends StatelessWidget {
  final ValueChanged<Map<String, dynamic>> submit;
  final categories = Get.find<NomenclatorsServiceContract>()
      .nomenclators[Nomenclators.category];

  AddItemForm({super.key, required this.submit});

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
                        ReactiveRawAutocomplete<String, _Option>(
                            formControlName: keyItemName,
                            validationMessages: (control) => {
                              ValidationMessage.required:
                              'El campo no debe estar vacío'
                            },
                            decoration:
                            const InputDecoration(label: Text('Item')),
                            valueAccessor: _ValueAccessor(),
                            optionsBuilder: _optionsBuilder,
                            optionsViewBuilder: _optionsViewBuilder),
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

  FutureOr<Iterable<_Option>> _optionsBuilder(
      TextEditingValue textEditingValue) async {
    final donwloaded =
        await Get.find<ProductServiceContract>().getTags(textEditingValue.text);

    return donwloaded.isNotEmpty
        ? donwloaded.map((e) => _Option(e, downloaded: true))
        : [_Option(textEditingValue.text)];
  }

  Widget _optionsViewBuilder(BuildContext context,
      AutocompleteOnSelected<_Option> onSelected, Iterable<_Option> options) {
    final sController = ScrollController();
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Material(
          elevation: 4,
          child: SizedBox(
            height: options.length > 4 ? 235 : options.length * 58,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: RawScrollbar(
                controller: sController,
                thumbVisibility: true,
                trackVisibility: true,
                thumbColor: Colors.greenAccent,
                radius: const Radius.circular(20),
                thickness: 10,
                child: ListView.builder(
                  controller: sController,
                  padding: const EdgeInsets.all(8),
                  itemCount: options.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    final option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        leading: Container(
                          child: option.downloaded
                              ? const Icon(
                                  Icons.cloud_download,
                                  color: Colors.greenAccent,
                                )
                              : Icon(
                                  Icons.fiber_new_rounded,
                                  color: context.theme.errorColor,
                                ),
                        ),
                        title: Text(
                          option.value,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ValueAccessor extends ControlValueAccessor<String, _Option> {
  @override
  _Option? modelToViewValue(String? modelValue) {
    return modelValue != null ? _Option(modelValue) : null;
  }

  @override
  String? viewToModelValue(_Option? viewValue) {
    return viewValue?.value.split(' >> ')[0];
  }
}
