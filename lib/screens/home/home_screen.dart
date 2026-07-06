import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/flashcard_model.dart';
import '../../providers/flashcard_provider.dart';
import '../../providers/score_provider.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/flashcard_widget.dart';
import '../../widgets/score_card.dart';
import '../../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    "All",
    "General",
    "Programming",
    "Science",
    "Mathematics",
    "English",
  ];

  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<FlashcardProvider>().loadFlashcards();
      context.read<ScoreProvider>().loadScores();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    final flashcardProvider = context.watch<FlashcardProvider>();
    final scoreProvider = context.watch<ScoreProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcard Quiz"),
        centerTitle: true,
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
          // Navigate to Add Card Screen (Later)
        },
        child: const Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: flashcardProvider.refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            /// Welcome Header
            Text(
              "Welcome Back 👋",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 6),

            Text(
              "Keep learning with your flashcards.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            /// Statistics
            Row(
              children: [
                ScoreCard(
                  title: "Cards",
                  value: flashcardProvider.totalCards.toString(),
                  icon: Icons.style,
                  color: Colors.deepPurple,
                ),
                ScoreCard(
                  title: "Best",
                  value:
                      "${scoreProvider.highestScore.toStringAsFixed(0)}%",
                  icon: Icons.emoji_events,
                  color: Colors.orange,
                ),
                ScoreCard(
                  title: "Attempts",
                  value: scoreProvider.totalAttempts.toString(),
                  icon: Icons.quiz,
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// Search
            SearchBarWidget(
              controller: _searchController,
              onChanged: (value) {
                flashcardProvider.searchFlashcards(value);
              },
            ),

            const SizedBox(height: 20),

            /// Categories
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return CategoryChip(
                    title: category,
                    isSelected: selectedCategory == category,
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });

                      flashcardProvider.filterByCategory(category);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Flashcards",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),
                        if (flashcardProvider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (flashcardProvider.flashcards.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  children: [
                    Icon(
                      Icons.style_outlined,
                      size: 90,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "No Flashcards Found",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Tap the + button to create your first flashcard.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                itemCount: flashcardProvider.flashcards.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final FlashcardModel flashcard =
                      flashcardProvider.flashcards[index];

                  return FlashcardWidget(
                    flashcard: flashcard,
                    onTap: () {
                      // Quiz Screen (Later)
                    },
                    onEdit: () {
                      // Edit Screen (Later)
                    },
                    onDelete: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete Flashcard"),
                            content: const Text(
                              "Are you sure you want to delete this flashcard?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true && flashcard.id != null) {
                        await flashcardProvider.deleteFlashcard(
                          flashcard.id!,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Flashcard deleted successfully",
                              ),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}