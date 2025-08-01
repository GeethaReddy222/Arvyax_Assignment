import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService with ChangeNotifier {
  final AudioPlayer _instructionPlayer = AudioPlayer();
  final AudioPlayer _bgPlayer = AudioPlayer();
  bool _bgMusicPlaying = false;
  double _bgVolume = 0.5;

  Future<void> playInstruction(String audioPath) async {
    try {
      // Only manage instruction audio
      await _instructionPlayer.stop();
      await _instructionPlayer.play(AssetSource(audioPath));
    } catch (e) {
      debugPrint('Error playing instruction: $e');
    }
  }

  Future<void> stopInstruction() async {
    try {
      await _instructionPlayer.stop();
    } catch (e) {
      debugPrint('Error stopping instruction: $e');
    }
  }

  Future<void> playBackgroundMusic() async {
    if (_bgMusicPlaying) return;
    try {
      await _bgPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgPlayer.setVolume(_bgVolume);
      await _bgPlayer.play(AssetSource('audio/meditation_music.mp3'));
      _bgMusicPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing background music: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    if (!_bgMusicPlaying) return;
    try {
      await _bgPlayer.stop();
      _bgMusicPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping background music: $e');
    }
  }

  Future<void> setBackgroundVolume(double volume) async {
    _bgVolume = volume.clamp(0.0, 1.0);
    await _bgPlayer.setVolume(_bgVolume);
    notifyListeners();
  }

  bool get isBackgroundMusicPlaying => _bgMusicPlaying;
  double get backgroundVolume => _bgVolume;

  @override
  Future<void> dispose() async {
    await _instructionPlayer.dispose();
    await _bgPlayer.dispose();
    super.dispose();
  }
}