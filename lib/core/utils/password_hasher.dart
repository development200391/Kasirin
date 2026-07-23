import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashPassword(String plainText) {
  return sha256.convert(utf8.encode(plainText)).toString();
}
