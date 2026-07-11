import 'package:flutter/material.dart';

import '../models/flashcard_model.dart';

class FlashcardWidget extends StatelessWidget {
  final FlashcardModel flashcard;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [

                // Left Accent
                Container(
                  width: 6,
                  height: 165,
                  decoration: const BoxDecoration(
                    color: Color(0xff6C63FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff6C63FF)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                flashcard.category,
                                style: const TextStyle(
                                  color: Color(0xff6C63FF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const Spacer(),

                            IconButton(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit_outlined),
                            ),

                            IconButton(
                              onPressed: onDelete,
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Text(
                          flashcard.question,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Tap to reveal answer",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Divider(),

                        const SizedBox(height: 8),

                        Row(
                          children: [

                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                flashcard.createdAt
                                    .toString()
                                    .split(" ")
                                    .first,
                              ),
                            ),

                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff6C63FF)
                                    .withValues(alpha: 0.10),
                                borderRadius:
                                    BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Color(0xff6C63FF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}