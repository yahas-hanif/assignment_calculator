import 'package:google_ml_kit/google_ml_kit.dart';
import '../models/ocr_model.dart';

class OcrService {
  Future<OcrResult> performOCR(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final recognisedText = await textDetector.processImage(inputImage);

    String detectedText = recognisedText.text;

    Map<String, String> replacements = {
      'I': '1',
      'O': '0',
      'S': '5',
      'Z': '2',
      'A': '4',
      ':': '/',
    };

    for (var entry in replacements.entries) {
      detectedText = detectedText.replaceAll(entry.key, entry.value);
    }

    detectedText =
        detectedText.replaceAllMapped(RegExp(r'(\d)\s*[xX]\s*(\d)'), (match) {
      return '${match.group(1)}*${match.group(2)}';
    });

    List<String> expressions = detectedText.replaceAll(' ', '').split('\n');
    print(expressions);

    if (expressions.isEmpty) {
      throw ('No text detected in the image');
    }

    String firstExpression = expressions.isNotEmpty ? expressions[0] : '';

    print(firstExpression);
    if (firstExpression.isEmpty) {
      throw ('No text detected in the image');
    }
    firstExpression = _filterExpression(firstExpression);

    String result = _evaluateExpression(firstExpression).toString();

    textDetector.close();

    return OcrResult(detectedText: firstExpression, result: result);
  }

  String _filterExpression(String expression) {
    RegExp regExp = RegExp(r'(\d+)\s*([\+\-\*\/])\s*(\d+)');
    Match? match = regExp.firstMatch(expression);

    return match != null ? match.group(0)! : '';
  }

  double _evaluateExpression(String expression) {
    RegExp regExp = RegExp(r'(\d+)\s*([\+\-\*\/])\s*(\d+)');
    Match? match = regExp.firstMatch(expression);

    if (match != null) {
      double num1 = double.parse(match.group(1)!);
      String operator = match.group(2)!;
      double num2 = double.parse(match.group(3)!);

      switch (operator) {
        case '+':
          return num1 + num2;
        case '-':
          return num1 - num2;
        case '*':
          return num1 * num2;
        case '/':
          return num1 / num2;
      }
    }
    return 0.0;
  }
}
