import 'package:flutter/services.dart';

class ScriptRepository {
  /// Loads a script file from assets and returns its content.
  Future<String> loadScript(String assetPath) async {
    try {
      return await rootBundle.loadString(assetPath);
    } catch (e) {
      print('Error loading script: $e');
      // Return empty string or rethrow depending on needs.
      // For now, return empty to prevent crash, but log error.
      return '';
    }
  }

  /// Returns list of available script paths.
  /// Ideally this would be dynamic, but for now we list them.
  List<Map<String, String>> getAvailableScripts() {
    return [
      {
        'title': 'Lesson 1: Nature',
        'path': 'assets/scripts/lesson_01.txt',
      },
    ];
  }
}
