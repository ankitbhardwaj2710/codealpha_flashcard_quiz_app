import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/flashcard_provider.dart';
import '../../providers/score_provider.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/flashcard_widget.dart';
import '../../widgets/search_bar_widget.dart';
import '../add_edit_card/add_edit_card_screen.dart';
import '../quiz/quiz_screen.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flashcardProvider = context.watch<FlashcardProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcards"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditCardScreen(),
            ),
          );

          if (context.mounted) {
            context.read<FlashcardProvider>().loadFlashcards();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Card"),
      ),

      body: RefreshIndicator(
        onRefresh: flashcardProvider.refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "Search Flashcards",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 10),

            SearchBarWidget(
              controller: _searchController,
              onChanged: (value) {
                flashcardProvider.searchFlashcards(value);
              },
            ),

            const SizedBox(height: 20),

            Text(
              "Categories",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 10),

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
              "All Flashcards",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),
                        if (flashcardProvider.isLoading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (flashcardProvider.flashcards.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.style_outlined,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "No Flashcards Found",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Tap the Add Card button to create your first flashcard.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: flashcardProvider.flashcards.length,
                itemBuilder: (context, index) {
                  final flashcard =
                      flashcardProvider.flashcards[index];

                  return FlashcardWidget(
                    flashcard: flashcard,

                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            flashcards: flashcardProvider.flashcards,
                            initialIndex: index,
                          ),
                        ),
                      );

                      if (context.mounted) {
                        context.read<ScoreProvider>().loadScores();
                      }
                    },

                    onEdit: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditCardScreen(
                            flashcard: flashcard,
                          ),
                        ),
                      );

                      if (context.mounted) {
                        context
                            .read<FlashcardProvider>()
                            .loadFlashcards();
                      }
                    },

                    onDelete: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Delete Flashcard"),
                          content: const Text(
                            "Are you sure you want to delete this flashcard?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true &&
                          flashcard.id != null) {
                        await flashcardProvider.deleteFlashcard(
                          flashcard.id!,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
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