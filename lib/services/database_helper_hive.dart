import 'package:hive_flutter/hive_flutter.dart';
import '../app/method.dart';
import '../models/ocr_result.dart';
import 'dart:convert';

class DatabaseHelperHive {
  static final DatabaseHelperHive _instance = DatabaseHelperHive._internal();
  factory DatabaseHelperHive() => _instance;

  late Box<OCRResult> _ocrBox;

  DatabaseHelperHive._internal();

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(OCRResultAdapter());
    _ocrBox = await Hive.openBox<OCRResult>('ocr_results');
  }

  Future<void> insertResult(String detectedText, String result) async {
    final encryptedText = encryptText(detectedText);
    final encryptedResult = encryptText(result);

    final ocrResult = OCRResult(
      detectedText: utf8.encode(encryptedText).toString(),
      result: utf8.encode(encryptedResult).toString(),
    );

    await _ocrBox.add(ocrResult);
  }

  Future<List<Map<String, dynamic>>> getResults() async {
    final results = _ocrBox.values.toList();

    return results.map((ocrResult) {
      return {
        'detectedText': decryptText(utf8.decode(
            (ocrResult.detectedText as String)
                .replaceAll(RegExp(r'[\[\]]'), '')
                .split(', ')
                .map(int.parse)
                .toList())),
        'result': decryptText(utf8.decode((ocrResult.result as String)
            .replaceAll(RegExp(r'[\[\]]'), '')
            .split(', ')
            .map(int.parse)
            .toList())),
      };
    }).toList();
  }

  Future<void> close() async {
    await _ocrBox.close();
  }
}
