import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/yoga_flow.dart';

class AssetsLoader {
  static Future<YogaFlow> loadFlow() async {
    final String response = await rootBundle.loadString('assets/poses.json');
    final data = await json.decode(response);
    return YogaFlow.fromJson(data);
  }
}