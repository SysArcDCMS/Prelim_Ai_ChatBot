import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/chat_screen.dart';
import '../settings/theme_notifier.dart';
import '../settings/color_theme.dart';
import '../settings/app_themes.dart';

class HistoryItem extends StatelessWidget {
  final String chatId;
  final String title;
  final String name;
  final int cardBackground;
  final int cardCircleBg;
  final IconData icon;
  final int botIndex;
  final String prompt;
  final String titleKey;

  const HistoryItem({
    super.key,
    required this.chatId,
    required this.title,
    required this.titleKey,
    required this.name,
    required this.cardBackground,
    required this.cardCircleBg,
    required this.icon,
    required this.prompt,
    required this.botIndex
  });

  @override
  Widget build(BuildContext context) {
    // Access current theme
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentTheme = themeNotifier.currentTheme;

    // Determine colors based on theme
    late Color cardBackground;
    late Color cardCircleBg;
    late Color iconColor;
    late Color nametxt;
    late Color primarytxt;


    if (currentTheme == AppTheme.light) {
      cardBackground = LightThemeColors.cardBackground;
      cardCircleBg = LightThemeColors.cardCircleBg;
      iconColor = LightThemeColors.activeIcon;
      nametxt = LightThemeColors.nameText;
      primarytxt = LightThemeColors.primaryText;
    } else if (currentTheme == AppTheme.dark) {
      cardBackground = DarkThemeColors.cardBackground;
      cardCircleBg = DarkThemeColors.cardCircleBg;
      iconColor = DarkThemeColors.activeIcon;
      nametxt = DarkThemeColors.nameText;
      primarytxt = DarkThemeColors.primaryText;
    } else {
      final botColors = AppThemes.botColors(botIndex);
      cardBackground = botColors.cardBackground;
      cardCircleBg = botColors.cardCircleBg;
      iconColor = DefaultThemeColors.activeIcon;
      nametxt = DefaultThemeColors.nameText;
      primarytxt = DefaultThemeColors.primaryText;
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('chats').doc(chatId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox();
        }

        final data = snapshot.data!;
        final int botIndex = data['botIndex'] as int;

        String createdTime = '';
        final ts = data['createdAt'] as Timestamp?;
        if (ts != null) {
          final d = ts.toDate();
          createdTime =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
              '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  title: title,
                  name: name,
                  titleKey: titleKey,
                  systemPrompt: prompt,
                  chatId: chatId,
                  botIndex: botIndex,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: cardCircleBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarytxt,
                      ),
                    ),
                    if (createdTime.isNotEmpty)
                      Text(
                        createdTime,
                        style: TextStyle(
                          color: nametxt,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
