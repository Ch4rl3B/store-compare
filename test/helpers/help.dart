
import 'package:dart_date/dart_date.dart';

import 'mock_services.dart';

void main() {
  setupParseInstance();
  final list = generateProducts()
    ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  var lastDate = list.first.createdAt!;
  list.fold<List<dynamic>>([], (list, product){
      if(list.isEmpty){
        list.add(lastDate.toString());
      }
      if(product.createdAt!.isSameDay(lastDate)){
        list.add(product.toString());
      } else {
        lastDate = product.createdAt!;
        list.addAll([
          lastDate.toString(),
          product.toString()
        ]);
      }
      return list;
  });
}
