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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "👋 Welcome Back",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Ready to Learn?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Master your knowledge with flashcards every day.",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        "${flashcardProvider.totalCards} Flashcards",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Statistics
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFEDE9FE),
                        child: Icon(Icons.style, color: Color(0xFF6C63FF)),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Flashcards",
                              style: TextStyle(color: Colors.grey),
                            ),

                            Text(
                              flashcardProvider.totalCards.toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              color: Colors.orange,
                            ),

                            const SizedBox(height: 6),

                            Text(
                              "${scoreProvider.highestScore.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const Text("Best Score"),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            const Icon(Icons.quiz, color: Colors.green),

                            const SizedBox(height: 6),

                            Text(
                              scoreProvider.totalAttempts.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            const Text("Attempts"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                        await flashcardProvider.deleteFlashcard(flashcard.id!);

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Flashcard deleted successfully"),
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
