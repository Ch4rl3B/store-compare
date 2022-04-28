import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:store_compare/models/nomenclator.dart';
import 'package:store_compare/services/contracts.dart';

export 'package:store_compare/models/nomenclator.dart';
export 'package:store_compare/services/contracts.dart';

class NomenclatorsService extends GetxService
    implements NomenclatorsServiceContract {

  @override
  Map<String, List<Nomenclator>> nomenclators = {};

  static Future<NomenclatorsService> create() async {
    final service = NomenclatorsService();
    final nomenclators = await service.fetchAll();
    service.nomenclators = nomenclators.fold(<String, List<Nomenclator>>{},
        (previousValue, element){
      if (!previousValue.containsKey(element.type)) {
        previousValue[element.type] = List.empty(growable: true);
      }
      previousValue[element.type]!.add(element);
      return previousValue;
    });
    return service;
  }

  @override
  Future<List<Nomenclator>> fetchAll() async {
    // Create your query
    final parseQuery = QueryBuilder<Nomenclator>(Nomenclator())
      ..orderByDescending('createdAt');
    // The query will resolve only after calling this method, retrieving
    // an array of `Nomenclator`, if success
    final apiResponse = await parseQuery.query<Nomenclator>();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results! as List<Nomenclator>;
    } else {
      return Future.error(apiResponse.error!.message);
    }
  }

  @override
  Future<Nomenclator> save(Nomenclator itemToSave) {
    // TODO(Ch4rli3B): implement save, https://no-url.com/
    throw UnimplementedError();
  }

  @override
  Future<bool> toggle(Nomenclator itemToSave) {
    // TODO(Ch4rli3B): implement save, https://no-url.com/
    throw UnimplementedError();
  }

  @override
  Future<void> delete(Nomenclator itemToDelete) {
    // TODO(Ch4rli3B): implement save, https://no-url.com/
    throw UnimplementedError();
  }
}
