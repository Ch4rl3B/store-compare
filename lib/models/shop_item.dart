import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:store_compare/constants/keys.dart';
import 'package:store_compare/models/nomenclator.dart';
import 'package:store_compare/models/product.dart';

class ShopItem extends ParseObject implements ParseCloneable {
  ShopItem() : super('ShopItems');
  ShopItem.clone() : this();

  /// Looks strangely hacky but due to Flutter not using reflection, we have to
  /// mimic a clone
  @override
  ShopItem clone(Map<String, dynamic> map) => ShopItem.clone()..fromJson(map);

  String get name => get<String>(keyItemName)!;
  set name(String name) => set<String>(keyItemName, name);

  int get amount => get<int>(keyItemAmount)!;

  set amount(int amount) => set<int>(keyItemAmount, amount);

  bool get completed => get<bool>(keyItemCompleted)!;
  set completed(bool? completed) =>
      set<bool>(keyItemCompleted, completed ?? false);

  Nomenclator get category => get<Nomenclator>(keyItemCategory)!;
  set category(Nomenclator category) =>
      set<Nomenclator>(keyItemCategory, category);

  @override
  bool operator ==(Object other) {
    if (other is Product) {
      return name == other.tag;
    }
    return (other is ShopItem) && name == other.name;
  }

  @override
  int get hashCode => name.hashCode;

  factory ShopItem.fromMap(Map<String, dynamic> objectData) {
    return ShopItem()
      ..name = objectData[keyItemName] as String
      ..amount = objectData[keyItemAmount] as int
      ..category = Nomenclator.fromMap(
          objectData[keyItemCategory] as Map<String, dynamic>)
      ..completed = objectData[keyItemCompleted] as bool;
  }
}
