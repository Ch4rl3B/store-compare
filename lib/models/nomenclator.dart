import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:store_compare/constants/keys.dart';

class Nomenclator extends ParseObject implements ParseCloneable {
  Nomenclator() : super('Nomenclators');

  Nomenclator.clone() : this();

  /// Looks strangely hacky but due to Flutter not using reflection, we have to
  /// mimic a clone
  @override
  Nomenclator clone(Map<String, dynamic> map) =>
      Nomenclator.clone()..fromJson(map);

  String get type => get<String>(keyNomenclatorType)!;

  set type(String type) => set<String>(keyNomenclatorType, type);

  String get value => get<String>(keyNomenclatorValue)!;

  set value(String value) => set<String>(keyNomenclatorValue, value);

  bool get active => get<bool>(keyNomenclatorActive)!;

  set active(bool? active) => set<bool>(keyNomenclatorActive, active ?? false);

  String? get data => get<String>(keyNomenclatorData);

  set data(String? data) => set<String?>(keyNomenclatorData, data);

  @override
  bool operator ==(Object other) {
    if (other is String) {
      return other == value;
    }
    return (other is Nomenclator) && type == other.type && value == other.value;
  }

  @override
  int get hashCode => type.hashCode ^ value.hashCode;

  factory Nomenclator.fromMap(Map<String, dynamic> objectData) {
    return Nomenclator()
      ..type = objectData[keyNomenclatorType]
      ..value = objectData[keyNomenclatorValue]
      ..active = objectData[keyNomenclatorActive]
      ..data = objectData[keyNomenclatorData];
  }
}


class Nomenclators {
  static String shop = 'SHOP';
  static String category = 'CATEGORY';
}
