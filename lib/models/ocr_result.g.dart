// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OCRResultAdapter extends TypeAdapter<OCRResult> {
  @override
  final int typeId = 0;

  @override
  OCRResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OCRResult(
      detectedText: fields[0] as String,
      result: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OCRResult obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.detectedText)
      ..writeByte(1)
      ..write(obj.result);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OCRResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
