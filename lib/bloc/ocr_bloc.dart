import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../services/database_helper_hive.dart';
import '../services/ocr_service.dart'; 
import 'storage_switch_bloc.dart'; 

part 'ocr_event.dart';
part 'ocr_state.dart';

class OcrBloc extends Bloc<OcrEvent, OcrState> {
  final OcrService _ocrService; 
  final StorageSwitchBloc _storageSwitchBloc; 

  OcrBloc(this._ocrService, this._storageSwitchBloc) : super(OcrInitial()) {
    on<OcrImagePicked>((event, emit) async {
      emit(OcrLoading());
      try {
        final result = await _ocrService.performOCR(event.imagePath);

        if (_storageSwitchBloc.state is StorageUsingSQLite) {
          final DatabaseHelper databaseHelper = DatabaseHelper();
          await databaseHelper.insertResult(result.detectedText, result.result);
        } else if (_storageSwitchBloc.state is StorageUsingHive) {
          final DatabaseHelperHive databaseHiveHelper = DatabaseHelperHive();
          await databaseHiveHelper.insertResult(result.detectedText, result.result);
        }

        emit(OcrLoaded(result.detectedText, result.result));
      } catch (e) {
        emit(OcrError('Failed to process image: $e'));
      }
    });
  }
}
