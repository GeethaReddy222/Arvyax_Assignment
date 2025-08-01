import 'dart:async';
import 'package:flutter/material.dart';
import 'package:yoga_flow/models/segment.dart';
import '../models/yoga_flow.dart';
import '../services/audio_service.dart';

class FlowPlayer with ChangeNotifier {
  final YogaFlow flow;
  final AudioService audioService;

  int _currentSegmentIndex = 0;
  int _currentLoopIteration = 0;
  int _currentScriptIndex = 0;
  bool _isPlaying = false;
  bool _isCompleted = false;
  Timer? _segmentTimer;
  Timer? _scriptTimer;
  Stopwatch _segmentStopwatch = Stopwatch();

  FlowPlayer({required this.flow, required this.audioService});

  int get currentLoopIteration => _currentLoopIteration;
  int get currentScriptIndex => _currentScriptIndex;
  bool get isPlaying => _isPlaying;
  bool get isCompleted => _isCompleted;
  FlowSegment get currentSegment => flow.sequence[_currentSegmentIndex];
  SegmentScript get currentScript => currentSegment.script[_currentScriptIndex];
  String get currentImageRef => currentScript.imageRef;
  String get currentBreathPattern => currentScript.breath;

  int get loopCount => currentSegment.iterations == "{{loopCount}}"
      ? flow.defaultLoopCount
      : int.tryParse(currentSegment.iterations.toString()) ??
            flow.defaultLoopCount;

  double get progress => (_currentSegmentIndex + 1) / flow.sequence.length;
  double get segmentProgress =>
      _segmentStopwatch.elapsed.inMilliseconds /
      (currentSegment.durationSec * 1000);
  Future<void> play() async {
    if (_isPlaying) return;

    _isPlaying = true;
    _segmentStopwatch.start();
    notifyListeners();
    await _playCurrentSegment();
  }

  Future<void> pause() async {
    if (!_isPlaying) return;
    _isPlaying = false;
    _segmentStopwatch.stop();
    _cancelTimers();
    await audioService.stopInstruction();
    notifyListeners();
  }

  Future<void> _playCurrentSegment() async {
    if (!_isPlaying) {
      _cancelTimers();
      return;
    }

    try {
      String audioPath = _getAudioPathForSegment(currentSegment);
      await audioService.playInstruction(audioPath);
    } catch (e) {
      debugPrint('Error playing segment audio: $e');
    }

    // Background music continues playing independently
    notifyListeners();
    _startScriptProgression();

    _segmentTimer = Timer(
      Duration(seconds: currentSegment.durationSec),
      _nextSegment,
    );
  }

  String _getAudioPathForSegment(FlowSegment segment) {
    switch (segment.name) {
      case 'intro':
        return 'audio/cat_cow_intro.mp3';
      case 'breath_cycle':
        return 'audio/cat_cow_loop.mp3';
      case 'outro':
        return 'audio/cat_cow_outro.mp3';
      default:
        return 'audio/cat_cow_loop.mp3';
    }
  }

  void _startScriptProgression() {
    _currentScriptIndex = 0;
    notifyListeners();
    _updateScriptTimer();
  }

  void _updateScriptTimer() {
    _scriptTimer?.cancel();
    if (_currentScriptIndex >= currentSegment.script.length) return;

    final script = currentSegment.script[_currentScriptIndex];
    final duration = Duration(seconds: script.endSec - script.startSec);

    _scriptTimer = Timer(duration, () {
      if (!_isPlaying) return;

      if (_currentScriptIndex < currentSegment.script.length - 1) {
        _currentScriptIndex++;
        notifyListeners();
        _updateScriptTimer();
      }
    });
  }

  void _nextSegment() {
    if (!_isPlaying) return;

    if (currentSegment.loopable && _currentLoopIteration < loopCount - 1) {
      _currentLoopIteration++;
      _currentScriptIndex = 0;
      _segmentStopwatch.reset();
      _segmentStopwatch.start();
      notifyListeners();
      _playCurrentSegment();
      return;
    }

    if (_currentSegmentIndex < flow.sequence.length - 1) {
      _currentSegmentIndex++;
      _currentLoopIteration = 0;
      _currentScriptIndex = 0;
      _segmentStopwatch.reset();
      _segmentStopwatch.start();
      notifyListeners();
      _playCurrentSegment();
    } else {
      _completeFlow();
    }
  }

  void _completeFlow() {
    _isPlaying = false;
    _isCompleted = true;
    _segmentStopwatch.stop();
    _cancelTimers();
    notifyListeners();
  }

  void _cancelTimers() {
    _segmentTimer?.cancel();
    _scriptTimer?.cancel();
    _segmentTimer = null;
    _scriptTimer = null;
  }

  @override
  void dispose() {
    _cancelTimers();
    _segmentStopwatch.stop();
    super.dispose();
  }
}
