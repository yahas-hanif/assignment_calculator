import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

import '../services/database_helper.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  DatabaseBloc() : super(DatabaseInitial()) {
    on<DatabaseFetchResults>((event, emit) async {
      emit(DatabaseLoading());
      try {
        final results = await _databaseHelper.getResults();

        final decryptedResults = results.map((map) {
          return {
            'detectedText': map["detectedText"].toString(),
            'result':map["result"].toString(),
          };
        }).toList();

        emit(DatabaseResultsLoaded(decryptedResults));
      } catch (e) {
        emit(DatabaseError('Failed to fetch results: $e'));
      }
    });

    on<DatabaseInsertResult>((event, emit) async {
      try {
        await _databaseHelper.insertResult(event.detectedText, event.result);
      } catch (e) {
        emit(DatabaseError('Failed to insert result: $e'));
      }
    });
  }
}
