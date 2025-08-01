import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_flow/services/audio_service.dart';
import '../models/yoga_flow.dart';
import '../services/flow_player.dart';

class FlowScreen extends StatefulWidget {
  final YogaFlow flow;

  const FlowScreen({super.key, required this.flow});

  @override
  State<FlowScreen> createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> {
  late FlowPlayer _flowPlayer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    final audioService = Provider.of<AudioService>(context, listen: false);
    _flowPlayer = FlowPlayer(flow: widget.flow, audioService: audioService)
      ..addListener(_updateState);
  }

  void _updateState() {
    if (!_isDisposed && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentScript = _flowPlayer.currentScript;
    final currentImageRef = _flowPlayer.currentImageRef;
    

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flow.title),
        actions: [
          IconButton(
            icon: Icon(_flowPlayer.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: () async {
              if (_flowPlayer.isPlaying) {
                await _flowPlayer.pause();
              } else {
                await _flowPlayer.play();
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              LinearProgressIndicator(value: _flowPlayer.progress),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${_flowPlayer.currentSegment.name} '
                  '${_flowPlayer.currentSegment.loopable ? '(${_flowPlayer.currentLoopIteration + 1}/${_flowPlayer.loopCount})' : ''}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            widget.flow.assets.getImagePath(currentImageRef),
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        currentScript.text,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _flowPlayer.removeListener(_updateState);
    _flowPlayer.dispose();
    super.dispose();
  }
}
