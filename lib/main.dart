import 'package:assignment_calculator/app.dart';
import 'package:flutter/material.dart';

import 'app/flavor_config.dart';
import 'services/database_helper_hive.dart';

void main() async{
   const flavor = String.fromEnvironment('flavor', defaultValue: 'redCamera');

  AppFlavor selectedFlavor;

  switch (flavor) {
    case 'greenGallery':
      selectedFlavor = AppFlavor.greenGallery;
      break;
    case 'greenFile':
      selectedFlavor = AppFlavor.greenCamera;
      break;
    case 'redGallery':
      selectedFlavor = AppFlavor.redGallery;
      break;
    case 'redCamera':
    default:
      selectedFlavor = AppFlavor.redCamera;
      break;
  }

   WidgetsFlutterBinding.ensureInitialized();
  
  final dbHelper = DatabaseHelperHive();
  await dbHelper.init();

  FlavorConfig.initialize(selectedFlavor);

  
  runApp(const App());
}