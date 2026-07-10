import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/score_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final scoreProvider = context.read<ScoreProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),

      body: ListView(
        children: [

          SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Enable dark theme"),
            value: themeProvider.isDarkMode,
            onChanged: (_) {
              themeProvider.toggleTheme();
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.delete_outline,color: Colors.red),
            title: const Text("Reset Quiz History"),
            subtitle: const Text("Delete all saved scores"),
            onTap: () async {

              await scoreProvider.clearScores();

              if(context.mounted){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Quiz history cleared"),
                  ),
                );
              }

            },
          ),

          const Divider(),

          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: "CodeAlpha Flashcard Quiz",
            applicationVersion: "1.0.0",
            applicationLegalese: "Made with Flutter",
          ),

        ],
      ),
    );
  }
}