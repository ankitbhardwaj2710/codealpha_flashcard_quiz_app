import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcard Quiz"),
        actions: [
          IconButton(
            onPressed: () {
              // Settings Screen (Later)
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add Card Screen (Later)
        },
        child: const Icon(Icons.add),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.style_rounded,
                size: 90,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 24),

              Text(
                "No Flashcards Yet",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Tap the + button to create your first flashcard.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: 220,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add Card Screen (Later)
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Create Flashcard"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}