import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool backgroundMusic;
  final ValueChanged<bool> onMusicChanged;

  const SettingsScreen({
    super.key,
    required this.backgroundMusic,
    required this.onMusicChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Background Music'),
              value: backgroundMusic,
              onChanged: onMusicChanged,
            ),
          ],
        ),
      ),
    );
  }
}
