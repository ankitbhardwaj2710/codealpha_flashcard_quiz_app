import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../models/flashcard_model.dart';
import '../../providers/flashcard_provider.dart';
import '../../providers/score_provider.dart';
// import '../../widgets/category_chip.dart';
import '../../widgets/flashcard_widget.dart';
// import '../../widgets/score_card.dart';
import '../add_edit_card/add_edit_card_screen.dart';
// import '../../widgets/search_bar_widget.dart';
// import '../settings/settings_screen.dart';
import '../quiz/quiz_screen.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

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
        title: const Text("Flashcards"),
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditCardScreen()),
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
            Text(
              "Your Progress",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            /// Statistics
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: const Color(
                          0xFF6C63FF,
                        ).withValues(alpha: 0.12),
                        child: const Icon(
                          Icons.style,
                          size: 42,
                          color: Color(0xFF6C63FF),
                        ),
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

            const SizedBox(height: 10),
            Text(
              "Recent Flashcards",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            if (flashcardProvider.flashcards.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.style_outlined,
                        size: 70,
                        color: Color(0xFF6C63FF),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "No Flashcards Yet",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Go to the Flashcards tab to create your first flashcard.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...flashcardProvider.flashcards
                  .take(3)
                  .map(
                    (flashcard) => FlashcardWidget(
                      flashcard: flashcard,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              flashcards: flashcardProvider.flashcards,
                              initialIndex: flashcardProvider.flashcards
                                  .indexOf(flashcard),
                            ),
                          ),
                        );

                        if (context.mounted) {
                          context.read<ScoreProvider>().loadScores();
                        }
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
