import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

import '../app/method.dart';
import '../models/ocr_result.dart';
import '../services/database_helper_hive.dart';

part 'database_hive_event.dart';
part 'database_hive_state.dart';

class DatabaseHiveBloc extends Bloc<DatabaseHiveEvent, DatabaseHiveState> {
  late Box<OCRResult> _ocrBox;
  final DatabaseHelperHive _databaseHelper = DatabaseHelperHive();

  DatabaseHiveBloc() : super(DatabaseHiveInitial()) {
    on<DatabaseHiveFetchResults>((event, emit) async {
      emit(DatabaseHiveLoading());
      try {
        final results = await _databaseHelper.getResults();

        final decryptedResults = results.map((map) {
          return {
            'detectedText': map["detectedText"].toString(),
            'result': map["result"].toString(),
          };
        }).toList();

        emit(DatabaseHiveResultsLoaded(decryptedResults));
      } catch (e) {
        emit(DatabaseHiveError('Failed to fetch results: $e'));
      }
    });

    on<DatabaseHiveInsertResult>((event, emit) async {
      try {
        final encryptedText = encryptText(event.detectedText);
        final encryptedResult = encryptText(event.result);

        final newResult = OCRResult(
          detectedText: encryptedText,
          result: encryptedResult,
        );

        await _ocrBox.add(newResult);
        emit(DatabaseHiveResultInserted());
      } catch (e) {
        emit(DatabaseHiveError('Failed to insert result: $e'));
      }
    });
  }

  Future<void> closeBox() async {
    await _ocrBox.close();
  }
}
