import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/flashcard_model.dart';
import '../../providers/flashcard_provider.dart';

class AddEditCardScreen extends StatefulWidget {
  final FlashcardModel? flashcard;

  const AddEditCardScreen({
    super.key,
    this.flashcard,
  });

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final _formKey = GlobalKey<FormState>();

  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  final List<String> _categories = [
    "General",
    "Programming",
    "Science",
    "Mathematics",
    "English",
  ];

  String _selectedCategory = "General";

  bool get isEdit => widget.flashcard != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      _questionController.text = widget.flashcard!.question;
      _answerController.text = widget.flashcard!.answer;
      _selectedCategory = widget.flashcard!.category;
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<FlashcardProvider>();

    final flashcard = FlashcardModel(
      id: isEdit ? widget.flashcard!.id : null,
      question: _questionController.text.trim(),
      answer: _answerController.text.trim(),
      category: _selectedCategory,
      createdAt:
          isEdit ? widget.flashcard!.createdAt : DateTime.now(),
    );

    if (isEdit) {
      await provider.updateFlashcard(flashcard);
    } else {
      await provider.addFlashcard(flashcard);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEdit
              ? "Flashcard Updated Successfully"
              : "Flashcard Added Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? "Edit Flashcard"
              : "Add Flashcard",
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            TextFormField(
              controller: _questionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Question",
                hintText: "Enter your question",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Question is required";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: _answerController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Answer",
                hintText: "Enter answer",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Answer is required";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: "Category",
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 35),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _saveCard,
                icon: Icon(
                  isEdit ? Icons.save : Icons.add,
                ),
                label: Text(
                  isEdit
                      ? "Update Flashcard"
                      : "Save Flashcard",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}