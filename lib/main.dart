import 'package:camera/camera.dart';
import 'package:carpio_boardingbuddy/auth/auth.dart';
import 'package:carpio_boardingbuddy/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BoardingBuddy());
}

class BoardingBuddy extends StatelessWidget {
  const BoardingBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authentication(),
    );
  }
}
