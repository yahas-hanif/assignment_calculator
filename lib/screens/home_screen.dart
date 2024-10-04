import 'package:assignment_calculator/app/flavor_config.dart';
import 'package:assignment_calculator/app/permission.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/database_bloc.dart';
import '../bloc/database_hive_bloc.dart';
import '../bloc/ocr_bloc.dart';
import '../bloc/storage_switch_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    requestPermissions();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DatabaseHiveBloc>().add(DatabaseHiveFetchResults());
      context.read<DatabaseBloc>().add(DatabaseFetchResults());
      _fetchResults();
    });
  }

  void _fetchResults() {
    final storageMode = context.read<StorageSwitchBloc>().state;
    print(storageMode);
    if (storageMode is StorageUsingSQLite) {
      context.read<DatabaseBloc>().add(DatabaseFetchResults());
    } else {
      context.read<DatabaseHiveBloc>().add(DatabaseHiveFetchResults());
    }
  }

  @override
  Widget build(BuildContext context) {
    final flavorConfig = FlavorConfig.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(flavorConfig.name),
        actions: [
          PopupMenuButton<StorageSwitchEvent>(
            onSelected: (event) {
              context.read<StorageSwitchBloc>().add(event);
              setState(() {
                _fetchResults();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SwitchToSQLite(),
                child: const Text('Switch to SQLite'),
              ),
              PopupMenuItem(
                value: SwitchToHive(),
                child: const Text('Switch to Hive'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<OcrBloc, OcrState>(
        listener: (context, state) {
          if (state is OcrError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is OcrLoaded) {
            _fetchResults();
          }
        },
        builder: (context, state) {
          if (state is OcrLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildResultsDisplay();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (FlavorConfig.instance.imageSource == "File") {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final pickedFilePath = result.files.single.path;
        if (pickedFilePath != null) {
          context.read<OcrBloc>().add(OcrImagePicked(pickedFilePath));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada gambar yang dipilih.')));
      }
    } else {
      final pickedFile =
          await _picker.pickImage(source: FlavorConfig.instance.imageSource);
      if (pickedFile != null) {
        // ignore: use_build_context_synchronously
        context.read<OcrBloc>().add(OcrImagePicked(pickedFile.path));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No image selected.')));
      }
    }
  }

  Widget _buildResultsDisplay() {
    final storageMode = context.read<StorageSwitchBloc>().state;

    if (storageMode is StorageUsingSQLite) {
      return BlocBuilder<DatabaseBloc, DatabaseState>(
        builder: (context, state) {
          if (state is DatabaseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DatabaseError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is DatabaseResultsLoaded) {
            if (state.results.isEmpty) {
              return const Center(child: Text('No results found.'));
            }
            return ListView(
              children: [
                ...state.results.reversed.map((value) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detected Text: ${value['detectedText']}',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "Result: ${value['result']}",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    } else {
      return BlocBuilder<DatabaseHiveBloc, DatabaseHiveState>(
        builder: (context, state) {
          print(state);
          if (state is DatabaseHiveLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DatabaseHiveError) {
            print(state.message);
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is DatabaseHiveResultsLoaded) {
            if (state.results.isEmpty) {
              return const Center(child: Text('No results found.'));
            }
            return ListView(
              children: [
                ...state.results.reversed.map((value) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detected Text: ${value['detectedText']}',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "Result: ${value['result']}",
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
  }
}
