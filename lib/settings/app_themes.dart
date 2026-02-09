import 'package:flutter/material.dart';
import 'color_theme.dart'; // import your DarkThemeColors, LightThemeColors, DefaultThemeColors

enum AppTheme {
  defaultTheme,
  light,
  dark,
}

class AppThemes {
  /// Core Themes for ThemeNotifier
  static final ThemeData defaultTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: DefaultThemeColors.botThemes[0].background,
    appBarTheme: AppBarTheme(
      backgroundColor: DefaultThemeColors.botThemes[0].appBar,
      elevation: 0,
      foregroundColor: DefaultThemeColors.pureBlack,
      centerTitle: true,
    ),
    iconTheme: const IconThemeData(color: DefaultThemeColors.darkGray),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: DefaultThemeColors.pureBlack),
    ),
    useMaterial3: true,
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: LightThemeColors.mainBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: LightThemeColors.appBarBackground,
      foregroundColor: LightThemeColors.appBarText,
      elevation: 0,
      centerTitle: true,
    ),
    iconTheme: const IconThemeData(color: LightThemeColors.appBarIcon),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: LightThemeColors.primaryText),
      bodyMedium: TextStyle(color: LightThemeColors.primaryText),
      bodySmall: TextStyle(color: LightThemeColors.primaryText),
    ),
    cardColor: LightThemeColors.cardBackground,
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DarkThemeColors.mainBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkThemeColors.appBarBackground,
      foregroundColor: DarkThemeColors.appBarText,
      elevation: 0,
      centerTitle: true,
    ),
    iconTheme: const IconThemeData(color: DarkThemeColors.appBarIcon),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: DarkThemeColors.primaryText),
      bodyMedium: TextStyle(color: DarkThemeColors.primaryText),
      bodySmall: TextStyle(color: DarkThemeColors.primaryText),
    ),
    cardColor: DarkThemeColors.cardBackground,
    useMaterial3: true,
  );

  /// Get the bot colors by index (Default theme)
  static BotTheme botColors(int botIndex) {
    return DefaultThemeColors.botThemes[botIndex];
  }

  /// Return theme colors for Light / Dark overrides
  static BotTheme themeColors(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return BotTheme(
          appBar: LightThemeColors.appBarBackground,
          background: LightThemeColors.mainBackground,
          cardBackground: LightThemeColors.cardBackground,
          cardCircleBg: LightThemeColors.cardCircleBg,
          userBubble: LightThemeColors.myBubble,
          aiBubble: LightThemeColors.aiBubble,
        );
      case AppTheme.dark:
        return BotTheme(
          appBar: DarkThemeColors.appBarBackground,
          background: DarkThemeColors.mainBackground,
          cardBackground: DarkThemeColors.cardBackground,
          cardCircleBg: DarkThemeColors.cardCircleBg,
          userBubble: DarkThemeColors.myBubble,
          aiBubble: DarkThemeColors.aiBubble,
        );
      case AppTheme.defaultTheme:
      default:
        return DefaultThemeColors.botThemes[0]; // fallback
    }
  }
}
