
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class SettingsModel with ChangeNotifier {
  bool _backgroundMusicEnabled = true;
  bool _darkModeEnabled = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  bool get backgroundMusicEnabled => _backgroundMusicEnabled;
  bool get darkModeEnabled => _darkModeEnabled;

  Future<void> toggleBackgroundMusic(bool value) async {
    _backgroundMusicEnabled = value;
    
    if (_backgroundMusicEnabled && !_isPlaying) {
      await _playBackgroundMusic();
    } else if (!_backgroundMusicEnabled && _isPlaying) {
      await _audioPlayer.stop();
      _isPlaying = false;
    }
    
    notifyListeners();
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _audioPlayer.play(AssetSource('audio/meditation_music.mp3'));
      _isPlaying = true;
      _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
    } catch (e) {
      debugPrint('Error playing music: $e');
    }
  }


  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}