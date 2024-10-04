part of 'database_hive_bloc.dart';

@immutable
abstract class DatabaseHiveState {}

class DatabaseHiveInitial extends DatabaseHiveState {}

class DatabaseHiveLoading extends DatabaseHiveState {}

class DatabaseHiveResultsLoaded extends DatabaseHiveState {
  final List<Map<String, dynamic>> results;

  DatabaseHiveResultsLoaded(this.results);
}

class DatabaseHiveResultInserted extends DatabaseHiveState {}

class DatabaseHiveError extends DatabaseHiveState {
  final String message;

  DatabaseHiveError(this.message);
}
