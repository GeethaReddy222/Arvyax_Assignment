import 'package:flutter/material.dart';
import 'package:yoga_flow/models/segment.dart';
import '../models/yoga_flow.dart';
import 'flow_screen.dart';

class PreviewScreen extends StatelessWidget {
  final YogaFlow flow;

  const PreviewScreen({super.key, required this.flow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${flow.title} Preview')),
      body: Column(
        children: [
          ListTile(
            title: Text('Category: ${flow.category}'),
            subtitle: Text('Tempo: ${flow.tempo}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: flow.sequence.length,
              itemBuilder: (context, index) {
                final segment = flow.sequence[index];
                return Card(
                  child: ListTile(
                    title: Text(segment.name),
                    subtitle: Text(
                      '${segment.durationSec} seconds'
                      '${segment.loopable ? ' (${segment.iterations == "{{loopCount}}" ? flow.defaultLoopCount : segment.iterations} loops)' : ''}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showSegmentDetails(context, segment);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlowScreen(flow: flow),
                  ),
                );
              },
              child: const Text('Start Flow'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSegmentDetails(BuildContext context, FlowSegment segment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(segment.name),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: segment.script.length,
            itemBuilder: (context, index) {
              final script = segment.script[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    flow.assets.getImagePath(script.imageRef),
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(script.text),
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}