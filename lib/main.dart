import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_flow/screens/home_screen.dart';
import 'services/audio_service.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AudioService>(create: (_) => AudioService()),
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
      title: 'Yoga Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}