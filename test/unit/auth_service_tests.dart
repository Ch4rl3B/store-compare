import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:store_compare/services/auth_service.dart';

void main() {
  late AuthService service;

  setUp(() async {
    service = Get.put(AuthService());
  });

  tearDown(() async {
    await Get.delete<AuthService>();
  });

  test('Service has been instantiated', () async {
    expect(true, service.initialized);
  });

  test('Wrong code wont authenticate', () async {
    const code = '123456';
    expect(await service.authenticate(code), false);
  });
}
