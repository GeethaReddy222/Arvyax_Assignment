import 'package:flutter/material.dart';
import 'package:yoga_flow/models/segment.dart';
import '../models/yoga_flow.dart';
import 'package:yoga_flow/screens/flow_screen.dart';

class PreviewScreen extends StatelessWidget {
  final YogaFlow flow;

  const PreviewScreen({super.key, required this.flow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${flow.title} Preview',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.deepPurple[900],
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.deepPurple[800]),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF8F5FF)],
            stops: [0.1, 0.9],
          ),
        ),
        child: Column(
          children: [
            // Info Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildInfoColumn(
                    label: 'CATEGORY',
                    value: flow.category.replaceAll('_', ' ').toUpperCase(),
                  ),
                  const Spacer(),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.deepPurple[100],
                  ),
                  const Spacer(),
                  _buildInfoColumn(
                    label: 'TEMPO',
                    value: flow.tempo.toUpperCase(),
                  ),
                ],
              ),
            ),
            
            // Segments List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: flow.sequence.length,
                itemBuilder: (context, index) {
                  final segment = flow.sequence[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: Colors.white,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _showSegmentDetails(context, segment),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    segment.name.replaceAll('_', ' ').toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.deepPurple[900],
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${segment.durationSec} seconds'
                                    '${segment.loopable ? ' • ${segment.iterations == "{{loopCount}}" ? flow.defaultLoopCount : segment.iterations} rounds' : ''}',
                                    style: TextStyle(
                                      color: Colors.deepPurple[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.deepPurple[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Start Button
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[800],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                  shadowColor: Colors.deepPurple.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FlowScreen(flow: flow),
                    ),
                  );
                },
                child: const Text(
                  'START FLOW',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.deepPurple[400],
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.deepPurple[900],
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _showSegmentDetails(BuildContext context, FlowSegment segment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                segment.name.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.deepPurple[900],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: segment.script.length,
                    itemBuilder: (context, index) {
                      final script = segment.script[index];
                      return Column(
                        children: [
                          Container(
                            height: 180,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(
                                  flow.assets.getImagePath(script.imageRef),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                            child: Text(
                              script.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.deepPurple[800],
                                height: 1.5,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (index < segment.script.length - 1)
                            Divider(
                              color: Colors.deepPurple[100],
                              thickness: 1,
                              height: 24,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'CLOSE',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}