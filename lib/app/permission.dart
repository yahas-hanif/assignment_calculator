import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  var cameraStatus = await Permission.camera.request();
  if (cameraStatus.isGranted) {
    print("Izin kamera diberikan");
  } else if (cameraStatus.isDenied) {
    print("Izin kamera ditolak");
  } else if (cameraStatus.isPermanentlyDenied) {
    openAppSettings();
  }

  var storageStatus = await Permission.storage.request();
  if (storageStatus.isGranted) {
    print("Izin penyimpanan diberikan");
  } else if (storageStatus.isDenied) {
    print("Izin penyimpanan ditolak");
  } else if (storageStatus.isPermanentlyDenied) {
    openAppSettings();
  }
}
