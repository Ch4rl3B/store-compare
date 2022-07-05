import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:store_compare/constants/keys.dart';

const authString =
    '23f09f3173f04a98d86624f2e1afa8e20f39f90fd94e6ee63218b976af9581e2';

class AuthService extends GetxService {

  Future<bool> authenticate(String code) async {
    final key = utf8.encode(keySecretPassword);
    final bytes = utf8.encode(code);

    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    return digest.toString().hashCode == authString.hashCode;
  }
}
