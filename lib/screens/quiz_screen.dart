import 'package:animal_explorer/providers/animal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_model.dart';
import '../data/animal_data.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  int? _selectedAnswerIndex;

  late List<QuizQuestion> _questions;

  @override
  void initState() {
    super.initState();
    _questions = List.from(AnimalData.quizQuestions)..shuffle();
    _questions = _questions.take(10).toList(); // 10 questions per quiz
  }

  void _answerQuestion(int index) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswerIndex = index;
      if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _answered = false;
          _selectedAnswerIndex = null;
        });
      } else {
        // Save score to provider
        context.read<AnimalProvider>().updateBestScore(_score);
        _showResults();
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Quiz Completed!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars_rounded, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'Your Score: $_score / ${_questions.length}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _score >= 8
                  ? 'Amazing! You\'re an Expert!'
                  : 'Well done! Keep learning!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back home
              },
              child: const Text('Great!'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return const Scaffold();

    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Quiz'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 40),
            ...List.generate(question.options.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildOptionCard(index, question.options[index]),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index, String text) {
    Color? color = Colors.white;
    Color? textColor = Colors.black87;
    IconData? icon;

    if (_answered) {
      if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
        color = Colors.green[100];
        textColor = Colors.green[900];
        icon = Icons.check_circle_rounded;
      } else if (index == _selectedAnswerIndex) {
        color = Colors.red[100];
        textColor = Colors.red[900];
        icon = Icons.cancel_rounded;
      } else {
        color = Colors.grey[100];
        textColor = Colors.grey[400];
      }
    }

    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                _answered &&
                    index ==
                        _questions[_currentQuestionIndex].correctAnswerIndex
                ? Colors.green
                : (_answered && index == _selectedAnswerIndex
                      ? Colors.red
                      : Colors.grey[200]!),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(
              String.fromCharCode(65 + index), // A, B, C, D
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _answered
                    ? textColor
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (icon != null) Icon(icon, color: textColor),
          ],
        ),
      ),
    );
  }
}
