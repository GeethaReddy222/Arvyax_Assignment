import 'package:flutter/foundation.dart';
import 'package:yoga_flow/services/audio_service.dart';

class SettingsModel with ChangeNotifier {
  bool _backgroundMusicEnabled = false;
  final AudioService _audioService;

  SettingsModel({required AudioService audioService}) 
      : _audioService = audioService {
    _init();
  }

  Future<void> _init() async {
    _backgroundMusicEnabled = _audioService.isBackgroundMusicPlaying;
  }

  bool get backgroundMusicEnabled => _backgroundMusicEnabled;

  Future<void> toggleBackgroundMusic(bool value) async {
    if (_backgroundMusicEnabled == value) return;
    
    _backgroundMusicEnabled = value;
    
    if (_backgroundMusicEnabled) {
      await _audioService.playBackgroundMusic();
    } else {
      await _audioService.stopBackgroundMusic();
    }
    
    notifyListeners();
  }

  Future<void> setBackgroundVolume(double volume) async {
    await _audioService.setBackgroundVolume(volume);
    notifyListeners();
  }

  double get backgroundVolume => _audioService.backgroundVolume;
}