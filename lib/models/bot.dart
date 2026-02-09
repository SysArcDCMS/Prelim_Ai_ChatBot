import 'package:flutter/material.dart';

class Bot {
  final int index;
  final String name;
  final Map<String, String> titles;
  final String prompt;
  final IconData icon;
  final int background;
  final int appbar;
  final int cardBackground;
  final int cardCircleBg;
  final int bubbleuser;
  final int bubbleai;
  final String titleKey;

  Bot({
    required this.index,
    required this.name,
    required this.titles,
    required this.prompt,
    required this.icon,
    required this.background,
    required this.appbar,
    required this.cardBackground,
    required this.cardCircleBg,
    required this.bubbleuser,
    required this.bubbleai,
    required this.titleKey,
  });

  // Getter to simulate dynamic prompt name: e.g., "HavenPrompt"
  String get promptName => '${name}Prompt';
}
