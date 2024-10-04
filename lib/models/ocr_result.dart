import 'package:hive/hive.dart';

part 'ocr_result.g.dart'; 

@HiveType(typeId: 0)
class OCRResult extends HiveObject {
  @HiveField(0)
  late String detectedText;

  @HiveField(1)
  late String result;

  OCRResult({required this.detectedText, required this.result});
}
