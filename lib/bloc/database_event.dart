part of 'database_bloc.dart';

@immutable
abstract class DatabaseEvent {}

class DatabaseFetchResults extends DatabaseEvent {} 

class DatabaseInsertResult extends DatabaseEvent {
  final String detectedText;
  final String result;

  DatabaseInsertResult(this.detectedText, this.result); 
}
