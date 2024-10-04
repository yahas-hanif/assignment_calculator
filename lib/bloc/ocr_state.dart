part of 'ocr_bloc.dart';

@immutable
abstract class OcrState {}

class OcrInitial extends OcrState {}


class OcrLoading extends OcrState {}

class OcrLoaded extends OcrState {
  final String detectedText;
  final String result;

  OcrLoaded(this.detectedText, this.result);
}

class OcrError extends OcrState {
  final String message;

  OcrError(this.message);
}
