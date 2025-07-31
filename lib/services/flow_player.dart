import 'dart:async';
import 'package:flutter/material.dart';
import '../models/segment.dart';
import '../models/yoga_flow.dart';
import '../services/audio_service.dart';

class FlowPlayer with ChangeNotifier {
  final YogaFlow flow;
  final AudioService audioService;
  
  // Playback state
  int _currentSegmentIndex = 0;
  int _currentLoopIteration = 0;
  int _currentScriptIndex = 0;
  bool _isPlaying = false;
  bool _isCompleted = false;
  bool _isInitialized = false;
  
  // Timers
  Timer? _segmentTimer;
  Timer? _scriptTimer;
  Stopwatch _segmentStopwatch = Stopwatch();

  FlowPlayer({required this.flow, required this.audioService}) {
    _initialize();
  }

  Future<void> _initialize() async {
    await audioService.init();
    _isInitialized = true;
    notifyListeners();
  }

  // Getters
  int get currentLoopIteration => _currentLoopIteration;
  int get currentScriptIndex => _currentScriptIndex;
  bool get isPlaying => _isPlaying;
  bool get isCompleted => _isCompleted;
  bool get isInitialized => _isInitialized;
  Duration get elapsedTime => _segmentStopwatch.elapsed;

  FlowSegment get currentSegment => flow.sequence[_currentSegmentIndex];
  SegmentScript get currentScript => currentSegment.script[_currentScriptIndex];
  String get currentImageRef => currentScript.imageRef;
  String get currentBreathPattern => currentScript.breath;

  int get loopCount => currentSegment.iterations == "{{loopCount}}"
      ? flow.defaultLoopCount
      : int.tryParse(currentSegment.iterations.toString()) ?? flow.defaultLoopCount;

  double get progress => (_currentSegmentIndex + 1) / flow.sequence.length;
  double get segmentProgress => _segmentStopwatch.elapsed.inMilliseconds / (currentSegment.durationSec * 1000);

  // Playback control
  Future<void> play() async {
    if (_isPlaying || !_isInitialized) return;
    
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
    await audioService.stopAll();
    notifyListeners();
  }

  void _updateScriptTimer() {
    _scriptTimer?.cancel();

    if (_currentScriptIndex >= currentSegment.script.length) return;

    final script = currentSegment.script[_currentScriptIndex];
    
    final displayDuration = Duration(seconds: script.endSec - script.startSec);
    
    _scriptTimer = Timer(displayDuration, () {
      if (!_isPlaying) return;
      
      if (_currentScriptIndex < currentSegment.script.length - 1) {
        _currentScriptIndex++;
        notifyListeners();
        _updateScriptTimer();
      }
    });
  }

  Future<void> _playCurrentSegment() async {
    if (!_isPlaying || !_isInitialized) return;
    _cancelTimers();

    try {
      switch (currentSegment.name) {
        case 'intro':
          await audioService.playIntro();
          break;
        case 'breath_cycle':
          await audioService.playLoop();
          break;
        case 'outro':
          await audioService.playOutro();
          break;
      }
    } catch (e) {
      print('Error playing segment audio: $e');
    }

    _startScriptProgression();
    _segmentTimer = Timer(
      Duration(seconds: currentSegment.durationSec),
      _nextSegment,
    );
  }

  void _startScriptProgression() {
    _currentScriptIndex = 0;
    notifyListeners();
    _updateScriptTimer();
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

  void reset() {
    _cancelTimers();
    _segmentStopwatch.reset();
    _currentSegmentIndex = 0;
    _currentLoopIteration = 0;
    _currentScriptIndex = 0;
    _isPlaying = false;
    _isCompleted = false;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    _cancelTimers();
    _segmentStopwatch.stop();
    await audioService.dispose();
    super.dispose();
  }
}