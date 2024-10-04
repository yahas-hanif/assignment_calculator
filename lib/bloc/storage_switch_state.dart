part of 'storage_switch_bloc.dart';

@immutable
abstract class StorageSwitchState {}

class StorageSwitchInitial extends StorageSwitchState {}
class StorageSwitchLoading extends StorageSwitchState {}

class StorageUsingSQLite extends StorageSwitchState {}

class StorageUsingHive extends StorageSwitchState {}
