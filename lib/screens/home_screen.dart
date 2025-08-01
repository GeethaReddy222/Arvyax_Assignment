import 'package:flutter/material.dart';
import 'package:yoga_flow/models/yoga_flow.dart';
import 'package:yoga_flow/screens/preview_screen.dart';
import 'package:yoga_flow/screens/settings_screen.dart'; // Import settings screen
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/yoga.png', height: 28),
            const SizedBox(width: 10),
            const Text(
              'YogaFlow',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: Colors.deepPurple,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.deepPurple),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F5FF)],
          ),
        ),
        child: FutureBuilder<YogaFlow>(
          future: _flowFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.deepPurple[800]),
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'No yoga flow found',
                  style: TextStyle(color: Colors.deepPurple[800]),
                ),
              );
            } else {
              return _buildFlowContent(snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildFlowContent(YogaFlow flow) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 180,
            width: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(flow.assets.getImagePath('base')),
                fit: BoxFit.contain,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            flow.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            flow.category.replaceAll('_', ' ').toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.deepPurple[400],
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewScreen(flow: flow),
                ),
              );
            },
            child: const Text(
              'START SESSION',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}