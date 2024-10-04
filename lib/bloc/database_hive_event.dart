part of 'database_hive_bloc.dart';

@immutable
abstract class DatabaseHiveEvent {}

class DatabaseHiveFetchResults extends DatabaseHiveEvent {}

class DatabaseHiveInsertResult extends DatabaseHiveEvent {
  final String detectedText;
  final String result;

  DatabaseHiveInsertResult({required this.detectedText, required this.result});
}
