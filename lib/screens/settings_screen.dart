import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_flow/models/settings_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F5FF)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Consumer<SettingsModel>(
                    builder: (context, settings, child) {
                      return Column(
                        children: [
                          SwitchListTile(
                            title: const Text('Background Music'),
                            value: settings.backgroundMusicEnabled,
                            onChanged: settings.toggleBackgroundMusic,
                            activeColor: Colors.deepPurple,
                          ),
                          const SizedBox(height: 16),
                          const Text('Music Volume'),
                          Slider(
                            value: settings.backgroundVolume,
                            onChanged: (value) {
                              settings.setBackgroundVolume(value);
                            },
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            activeColor: Colors.deepPurple,
                            inactiveColor: Colors.deepPurple[100],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}