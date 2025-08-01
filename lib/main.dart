import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_flow/services/audio_service.dart';
import 'package:yoga_flow/models/settings_model.dart';
import 'package:yoga_flow/screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AudioService()),
        ChangeNotifierProxyProvider<AudioService, SettingsModel>(
          create: (context) => SettingsModel(
            audioService: Provider.of<AudioService>(context, listen: false),  
          ),
          update: (context, audioService, previous) => SettingsModel(
            audioService: audioService, 
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YogaFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}