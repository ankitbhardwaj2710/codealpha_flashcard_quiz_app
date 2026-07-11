import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/flashcard_provider.dart';
import '../../providers/score_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final flashcardProvider = context.watch<FlashcardProvider>();
    final scoreProvider = context.watch<ScoreProvider>();

    final totalCards = flashcardProvider.totalCards;
    final attempts = scoreProvider.totalAttempts;
    final bestScore = scoreProvider.highestScore;

    final latest = scoreProvider.latestScore;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _StatCard(
            title: "Total Flashcards",
            value: totalCards.toString(),
            icon: Icons.style,
            color: Colors.deepPurple,
          ),

          const SizedBox(height: 16),

          _StatCard(
            title: "Best Score",
            value: "${bestScore.toStringAsFixed(0)}%",
            icon: Icons.emoji_events,
            color: Colors.orange,
          ),

          const SizedBox(height: 16),

          _StatCard(
            title: "Quiz Attempts",
            value: attempts.toString(),
            icon: Icons.quiz,
            color: Colors.green,
          ),

          const SizedBox(height: 24),

          Text(
            "Latest Quiz",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 12),

          if (latest == null)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text("No quiz attempts yet."),
                ),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Correct : ${latest['correct']}",
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Wrong : ${latest['wrong']}",
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Score : ${latest['percentage'].toStringAsFixed(0)}%",
                    ),

                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}