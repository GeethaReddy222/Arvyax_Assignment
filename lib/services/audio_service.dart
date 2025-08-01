import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool _isDisposed = false;
  bool _isInitialized = false;
  bool _hasError = false;

  AudioService() {
    _init();
  }

  Future<void> _init() async {
    if (_isDisposed) return;
    
    try {
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setVolume(1.0);
      _isInitialized = true;
      _hasError = false;
      notifyListeners();
    } catch (e) {
      debugPrint('AudioService initialization error: $e');
      _hasError = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      if (!_isDisposed) await _init(); 
    }
  }

  Future<void> play(String audioPath) async {
    if (_isDisposed || !_isInitialized) return;
    
    try {
      await _player.stop();
      await _player.play(AssetSource(audioPath));
      _hasError = false;
    } catch (e) {
      debugPrint('Audio play error: $e');
      _hasError = true;
      notifyListeners();
      throw e;
    }
  }

  Future<void> stop() async {
    if (_isDisposed) return;
    try {
      await _player.stop();
    } catch (e) {
      debugPrint('Audio stop error: $e');
    }
  }

  bool get hasError => _hasError;
  bool get isInitialized => _isInitialized;

  @override
  Future<void> dispose() async {
    _isDisposed = true;
    await _player.dispose();
    super.dispose();
  }
}