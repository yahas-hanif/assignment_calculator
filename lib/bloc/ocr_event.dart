part of 'ocr_bloc.dart';

@immutable
abstract class OcrEvent {}

class OcrImagePicked extends OcrEvent {
  final String imagePath;

  OcrImagePicked(this.imagePath);
}
