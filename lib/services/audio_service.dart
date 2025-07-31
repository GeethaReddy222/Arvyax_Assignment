import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _introPlayer = AudioPlayer();
  final AudioPlayer _loopPlayer = AudioPlayer();
  final AudioPlayer _outroPlayer = AudioPlayer();
  bool _initialized = false;

  // Audio durations in seconds
  static const introDuration = 31;
  static const loopDuration = 14;
  static const outroDuration = 15;

  Future<void> init() async {
    if (_initialized) return;
    
    await Future.wait([
      _introPlayer.setSource(AssetSource('audio/cat_cow_intro.mp3')),
      _loopPlayer.setSource(AssetSource('audio/cat_cow_loop.mp3')),
      _outroPlayer.setSource(AssetSource('audio/cat_cow_outro.mp3')),
    ]);

    await Future.wait([
      _introPlayer.setReleaseMode(ReleaseMode.stop),
      _loopPlayer.setReleaseMode(ReleaseMode.loop),
      _outroPlayer.setReleaseMode(ReleaseMode.stop),
    ]);

    await Future.wait([
      _introPlayer.setVolume(0.7),
      _loopPlayer.setVolume(0.7),
      _outroPlayer.setVolume(0.7),
    ]);

    _initialized = true;
  }

  Future<void> playIntro() async {
    await _stopAll();
    await _introPlayer.seek(Duration.zero);
    await _introPlayer.resume();
  }

  Future<void> playLoop() async {
    await _stopAll();
    await _loopPlayer.seek(Duration.zero);
    await _loopPlayer.resume();
  }

  Future<void> playOutro() async {
    await _stopAll();
    await _outroPlayer.seek(Duration.zero);
    await _outroPlayer.resume();
  }

  Future<void> _stopAll() async {
    await Future.wait([
      _introPlayer.stop(),
      _loopPlayer.stop(),
      _outroPlayer.stop(),
    ]);
  }

  Future<void> stopAll() async => _stopAll();

  Future<void> dispose() async {
    await _stopAll();
    await Future.wait([
      _introPlayer.dispose(),
      _loopPlayer.dispose(),
      _outroPlayer.dispose(),
    ]);
  }
}