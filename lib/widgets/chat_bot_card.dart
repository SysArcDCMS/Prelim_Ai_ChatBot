import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/app_themes.dart';
import '../settings/color_theme.dart';
import '../settings/theme_notifier.dart';

class ChatBotCard extends StatelessWidget {
  final String name;
  final String title;
  final IconData icon;
  final int botIndex;
  final VoidCallback onTap;

  const ChatBotCard({
    super.key,
    required this.name,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.botIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Watch the current theme
    final themeNotifier = context.watch<ThemeNotifier>();
    final currentTheme = themeNotifier.currentTheme;

    // Determine colors based on current theme
    late Color cardBackground;
    late Color cardCircleBg;
    late Color iconColor;
    late Color titleColor;
    late Color nametxt;

    if (currentTheme == AppTheme.dark) {
      cardBackground = DarkThemeColors.cardBackground;
      cardCircleBg = DarkThemeColors.cardCircleBg;
      iconColor = DarkThemeColors.activeIcon;
      titleColor = DarkThemeColors.appBarText;
      nametxt = DarkThemeColors.nameText;
    } else if (currentTheme == AppTheme.light) {
      cardBackground = LightThemeColors.cardBackground;
      cardCircleBg = LightThemeColors.cardCircleBg;
      iconColor = LightThemeColors.activeIcon;
      titleColor = LightThemeColors.appBarText;
      nametxt = LightThemeColors.nameText;
    } else {
      // Default theme: use bot theme
      final botColors = AppThemes.botColors(botIndex);
      cardBackground = botColors.cardBackground;
      cardCircleBg = botColors.cardCircleBg;
      iconColor = DefaultThemeColors.activeIcon;
      titleColor = DefaultThemeColors.primaryText;
      nametxt = DefaultThemeColors.nameText;
    }

    return Container(
      width: 180,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: cardCircleBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 140,
            height: 45,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 140,
            height: 18,
            child: Text(
              name,
              style: TextStyle(
                color: nametxt,
                fontStyle: FontStyle.italic,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cardCircleBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
