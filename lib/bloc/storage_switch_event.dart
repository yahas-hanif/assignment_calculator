part of 'storage_switch_bloc.dart';

@immutable
abstract class StorageSwitchEvent {}

class SwitchToSQLite extends StorageSwitchEvent {}

class SwitchToHive extends StorageSwitchEvent {}
