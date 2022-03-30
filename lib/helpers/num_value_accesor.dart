import 'package:reactive_forms/reactive_forms.dart';

class NumValueAccessor extends ControlValueAccessor<num, String> {
  final int fractionDigits;

  NumValueAccessor({this.fractionDigits = 2});

  @override
  String modelToViewValue(num? modelValue) {
    return modelValue == null ? '' : modelValue.toStringAsFixed(fractionDigits);
  }

  @override
  num? viewToModelValue(String? viewValue) {
    return (viewValue == '' || viewValue == null)
        ? null
        : num.tryParse(viewValue);
  }
}
