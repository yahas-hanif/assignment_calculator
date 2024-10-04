import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum AppFlavor { redCamera, redGallery, greenCamera, greenGallery }

class FlavorConfig {
  final AppFlavor flavor;
  final String name;
  final ThemeData theme;
  var imageSource;

  FlavorConfig._internal(this.flavor, this.name, this.theme, this.imageSource);

  static FlavorConfig? _instance;

  static void initialize(AppFlavor flavor) {
    ThemeData theme;
    String flavorName;
    var imageSource;

    ColorScheme colorScheme;

    switch (flavor) {
      case AppFlavor.redCamera:
        colorScheme = ColorScheme(
          brightness: Brightness.light,
          primary: Colors.red,
          onPrimary: Colors.white,
          secondary: Colors.redAccent,
          onSecondary: Colors.white,
          error: Colors.red[700]!,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        );
        flavorName = 'Red Theme - Camera';
        imageSource = ImageSource.camera;
        break;

      case AppFlavor.redGallery:
        colorScheme = ColorScheme(
          brightness: Brightness.light,
          primary: Colors.red,
          onPrimary: Colors.white,
          secondary: Colors.redAccent,
          onSecondary: Colors.white,
          error: Colors.red[700]!,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        );
        flavorName = 'Red Theme - Gallery';
        imageSource = ImageSource.gallery;
       
        break;

      case AppFlavor.greenCamera:
        colorScheme = ColorScheme(
          brightness: Brightness.light,
          primary: Colors.green,
          onPrimary: Colors.white,
          secondary: Colors.greenAccent,
          onSecondary: Colors.white,
          error: Colors.red[700]!,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        );
        flavorName = 'Green Theme - File System';
       imageSource = "File";
        break;

      case AppFlavor.greenGallery:
        colorScheme = ColorScheme(
          brightness: Brightness.light,
          primary: Colors.green,
          onPrimary: Colors.white,
          secondary: Colors.greenAccent,
          onSecondary: Colors.white,
          error: Colors.red[700]!,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        );
        flavorName = 'Green Theme - Gallery';
        imageSource = ImageSource.gallery;
        break;
      default:
        colorScheme = ColorScheme(
          brightness: Brightness.light,
          primary: Colors.red,
          onPrimary: Colors.white,
          secondary: Colors.redAccent,
          onSecondary: Colors.white,
          error: Colors.red[700]!,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        );
        flavorName = 'Red Theme - Camera';
        imageSource = ImageSource.camera;
        break;
    }

    theme = ThemeData(
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,
    );

    _instance = FlavorConfig._internal(flavor, flavorName, theme, imageSource);
  }

  static FlavorConfig get instance => _instance!;
}
