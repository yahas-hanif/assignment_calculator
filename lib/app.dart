import 'package:assignment_calculator/bloc/database_bloc.dart';
import 'package:assignment_calculator/bloc/database_hive_bloc.dart';
import 'package:assignment_calculator/screens/home_screen.dart';
import 'package:assignment_calculator/services/ocr_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/flavor_config.dart';
import 'bloc/ocr_bloc.dart';
import 'bloc/storage_switch_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    FlavorConfig flavorConfig = FlavorConfig.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StorageSwitchBloc(),
        ),
        BlocProvider(
          create: (context) => OcrBloc(
            OcrService(),
            BlocProvider.of<StorageSwitchBloc>(context),
          ),
        ),
        BlocProvider(
          create: (context) => DatabaseBloc(),
        ),
        BlocProvider(
          create: (context) => DatabaseHiveBloc(),
        ),
      ],
      child: MaterialApp(
        theme: flavorConfig.theme,
        home: HomeScreen(),
      ),
    );
  }
}
