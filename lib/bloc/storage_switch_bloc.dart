import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'storage_switch_event.dart';
part 'storage_switch_state.dart';

class StorageSwitchBloc extends Bloc<StorageSwitchEvent, StorageSwitchState> {
  StorageSwitchBloc() : super(StorageUsingSQLite()) {
    on<SwitchToSQLite>((event, emit) {
      emit(StorageSwitchLoading());

      emit(StorageUsingSQLite());
    });

    on<SwitchToHive>((event, emit) {
      emit(StorageSwitchLoading());

      emit(StorageUsingHive());
    });
  }
}
