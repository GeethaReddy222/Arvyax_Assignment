import 'package:yoga_flow/models/segment.dart';

class YogaFlow {
  final String id;
  final String title;
  final String category;
  final int defaultLoopCount;
  final String tempo;
  final FlowAssets assets;
  final List<FlowSegment> sequence;

  YogaFlow({
    required this.id,
    required this.title,
    required this.category,
    required this.defaultLoopCount,
    required this.tempo,
    required this.assets,
    required this.sequence,
  });

  factory YogaFlow.fromJson(Map<String, dynamic> json) {
    return YogaFlow(
      id: json['metadata']['id'],
      title: json['metadata']['title'],
      category: json['metadata']['category'],
      defaultLoopCount: json['metadata']['defaultLoopCount'],
      tempo: json['metadata']['tempo'],
      assets: FlowAssets.fromJson(json['assets']),
      sequence: (json['sequence'] as List)
          .map((seg) => FlowSegment.fromJson(seg))
          .toList(),
    );
  }
}

class FlowAssets {
  final Map<String, String> images;
  final Map<String, String> audio;

  FlowAssets({required this.images, required this.audio});

  factory FlowAssets.fromJson(Map<String, dynamic> json) {
    return FlowAssets(
      images: Map<String, String>.from(json['images']),
      audio: Map<String, String>.from(json['audio']),
    );
  }

  String getImagePath(String key) => 'assets/images/${images[key]}';
  String getAudioPath(String key) => 'assets/audio/${audio[key]}';
}