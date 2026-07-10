import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/score_provider.dart';
import '../../models/flashcard_model.dart';

class QuizScreen extends StatefulWidget {
  final List<FlashcardModel> flashcards;
  final int initialIndex;

  const QuizScreen({
    super.key,
    required this.flashcards,
    this.initialIndex = 0,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final GlobalKey<FlipCardState> _flipCardKey =
      GlobalKey<FlipCardState>();

  late int currentIndex;

  int correctAnswers = 0;
  int wrongAnswers = 0;

  bool isAnswerShown = false;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;
  }

  FlashcardModel get currentCard =>
      widget.flashcards[currentIndex];

  void showAnswer() {
    if (!isAnswerShown) {
      _flipCardKey.currentState?.toggleCard();

      setState(() {
        isAnswerShown = true;
      });
    }
  }

  void nextCard() {
    if (currentIndex < widget.flashcards.length - 1) {
      setState(() {
        currentIndex++;
        isAnswerShown = false;
      });
    } else {
      finishQuiz();
    }
  }

  void previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        isAnswerShown = false;
      });
    }
  }

  void markCorrect() {
    correctAnswers++;
    nextCard();
  }

  void markWrong() {
    wrongAnswers++;
    nextCard();
  }

  Future<void> finishQuiz() async {
  await context.read<ScoreProvider>().saveScore(
    correct: correctAnswers,
    wrong: wrongAnswers,
  );

  if (!mounted) return;

  final total = correctAnswers + wrongAnswers;
  final percentage =
      total == 0 ? 0 : (correctAnswers / total) * 100;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        title: const Text("🎉 Quiz Completed"),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              "Correct : $correctAnswers",
            ),

            const SizedBox(height: 8),

            Text(
              "Wrong : $wrongAnswers",
            ),

            const SizedBox(height: 8),

            Text(
              "Score : ${percentage.toStringAsFixed(0)}%",
            ),

          ],
        ),

        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Done"),
          ),

        ],
      );
    },
  );
}
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Mode"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            LinearProgressIndicator(
              value: (currentIndex + 1) / widget.flashcards.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 10),

            Text(
              "${currentIndex + 1} of ${widget.flashcards.length}",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 25),

            Expanded(
              child: FlipCard(
                key: _flipCardKey,
                flipOnTouch: false,
                front: _buildFront(currentCard),
                back: _buildBack(currentCard),
              ),
            ),

            const SizedBox(height: 25),

            if (!isAnswerShown)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: showAnswer,
                  icon: const Icon(Icons.visibility),
                  label: const Text("Show Answer"),
                ),
              )
            else
              Row(
                children: [

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: markWrong,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.close),
                      label: const Text("Wrong"),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: markCorrect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text("Correct"),
                    ),
                  ),

                ],
              ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: previousCard,
              icon: const Icon(Icons.arrow_back),
              label: const Text("Previous"),
            ),

          ],
        ),
      ),
    );
  }
    Widget _buildFront(FlashcardModel card) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.quiz_rounded,
              size: 60,
              color: Color(0xFF6C63FF),
            ),

            const SizedBox(height: 24),

            Text(
              card.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Chip(
              label: Text(card.category),
            ),

            const SizedBox(height: 30),

            const Text(
              "Press 'Show Answer' to reveal the answer",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBack(FlashcardModel card) {
    return Card(
      color: const Color(0xFF6C63FF),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 60,
                color: Colors.white,
              ),

              const SizedBox(height: 24),

              const Text(
                "Answer",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                card.answer,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}