import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'firebase_options.dart';
import 'logic/lesson_provider.dart';
import 'data/models/lesson_model.dart';
import 'data/models/question_model.dart';
import 'ui/screens/lesson_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase Initialized Successfully");
  } catch (e) {
    print("Firebase Initialization failed: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => LessonProvider(
        lesson: Lesson(
          id: 'lesson_1',
          title: 'Basic Colors',
          description: 'Learn simple colors!',
          questions: List.generate(5, (i) => Question.mock(i)),
        ),
      ),
      child: const GrowingBeansApp(),
    ),
  );
}

class GrowingBeansApp extends StatelessWidget {
  const GrowingBeansApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrowingBeans',
      theme: AppTheme.lightTheme,
      home: const MainMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GrowingBeans 🌱'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.stars_rounded,
              size: 100,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              '안녕! 영어 공부할 준비 됐니?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LessonScreen()),
                );
              },
              child: const Text('공부 시작하기'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Navigate to profile/items
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('내 가방 보기'),
            ),
          ],
        ),
      ),
    );
  }
}
