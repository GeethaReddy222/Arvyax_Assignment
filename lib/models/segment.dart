class SegmentScript {
  final String text;
  final int startSec;
  final int endSec;
  final String imageRef;
  final String breath;

  SegmentScript({
    required this.text,
    required this.startSec,
    required this.endSec,
    required this.imageRef,
    this.breath = 'neutral',
  });

  factory SegmentScript.fromJson(Map<String, dynamic> json) {
    return SegmentScript(
      text: json['text'],
      startSec: json['startSec'],
      endSec: json['endSec'],
      imageRef: json['imageRef'],
      breath: json['breath'] ?? 'neutral',
    );
  }
}

class FlowSegment {
  final String type;
  final String name;
  final String audioRef;
  final int durationSec;
  final List<SegmentScript> script;
  final dynamic iterations;
  final bool loopable;

  FlowSegment({
    required this.type,
    required this.name,
    required this.audioRef,
    required this.durationSec,
    required this.script,
    this.iterations,
    this.loopable = false,
  });

  factory FlowSegment.fromJson(Map<String, dynamic> json) {
    return FlowSegment(
      type: json['type'],
      name: json['name'],
      audioRef: json['audioRef'],
      durationSec: json['durationSec'],
      script: (json['script'] as List)
          .map((s) => SegmentScript.fromJson(s))
          .toList(),
      iterations: json['iterations'],
      loopable: json['loopable'] ?? false,
    );
  }
}