import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart';

String compress(String text) {
  final bytes = utf8.encode(text);
  final compressedData = GZipEncoder().encode(bytes);
  return base64.encode(compressedData!);
}

String encryptText(String plainText) {
  final key = Key.fromUtf8('12345678901234567890123456789012');
  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(key));

  final compressedText = compress(plainText);
  final encrypted = encrypter.encrypt(compressedText, iv: iv);

  return '${iv.base64}:${encrypted.base64}';
}

String decompress(String compressedText) {
  final compressedBytes = base64.decode(compressedText);
  final decompressedData = GZipDecoder().decodeBytes(compressedBytes);
  return utf8.decode(decompressedData);
}

String decryptText(String encryptedText) {
  final key = Key.fromUtf8('12345678901234567890123456789012');
  final parts = encryptedText.split(':');
  final iv = IV.fromBase64(parts[0]);
  final encryptedData = parts[1];

  final encrypter = Encrypter(AES(key));
  final compressedText = encrypter.decrypt64(encryptedData, iv: iv);
  return decompress(compressedText);
}
