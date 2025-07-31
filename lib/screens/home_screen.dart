import 'package:flutter/material.dart';
import 'package:yoga_flow/models/yoga_flow.dart';
import 'package:yoga_flow/screens/preview_screen.dart';
import 'package:yoga_flow/utils/assets_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<YogaFlow> _flowFuture;

  @override
  void initState() {
    super.initState();
    _flowFuture = AssetsLoader.loadFlow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YogaFlow')),
      body: FutureBuilder<YogaFlow>(
        future: _flowFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No yoga flow found'));
          } else {
            return _buildFlowContent(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildFlowContent(YogaFlow flow) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            flow.assets.getImagePath('base'),
            height: 150,
          ),
          const SizedBox(height: 20),
          Text(
            flow.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewScreen(flow: flow),
                ),
              );
            },
            child: const Text('Start Session'),
          ),
        ],
      ),
    );
  }
}