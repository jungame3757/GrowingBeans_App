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

  runApp(const GrowingBeansApp());
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

  void _navigateToLesson(BuildContext context, String title, List<Question> questions) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => LessonProvider(
            lesson: Lesson(
              id: 'lesson_${DateTime.now().millisecondsSinceEpoch}',
              title: title,
              description: 'Happy Learning!',
              questions: questions,
            ),
          ),
          child: const LessonScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GrowingBeans 🌱'),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _MenuButton(
                label: '퀴즈 풀기',
                icon: Icons.quiz_rounded,
                color: AppTheme.secondaryColor,
                onPressed: () => _navigateToLesson(context, 'Basic Quiz', Question.mockQuiz()),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                label: '단어조합 하기',
                icon: Icons.abc_rounded,
                color: AppTheme.primaryColor,
                onPressed: () => _navigateToLesson(context, 'Word Scramble', Question.mockScramble()),
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
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
