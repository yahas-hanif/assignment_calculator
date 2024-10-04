part of 'database_bloc.dart';

@immutable
abstract class DatabaseState {}

class DatabaseInitial extends DatabaseState {}

class DatabaseLoading extends DatabaseState {}

class DatabaseResultsLoaded extends DatabaseState {
  final List<Map<String, String>> results;

  DatabaseResultsLoaded(this.results);
}

class DatabaseError extends DatabaseState {
  final String message;

  DatabaseError(this.message);
}
