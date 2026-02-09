import 'package:flutter/material.dart';

class DarkThemeColors {
  // Core Colors
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF121212);
  static const Color darkGray = Color(0xFF1E1E1E);
  static const Color mediumGray = Color(0xFF383838);
  static const Color lightGray = Color(0xFFE5E5E5);
  static const Color softGray = Color(0xFFB3B3B3);
  static const Color dimGray = Color(0xFF666666);
  static const Color mediumDimGray = Color(0xFF999999);

  // AppBar
  static const Color appBarBackground = Color(0xFF181818);
  static const Color appBarText = pureWhite;
  static const Color appBarIcon = softGray;

  // Background
  static const Color mainBackground = pureBlack;
  static const Color chatBackground = pureBlack;
  static const Color cardBackground = darkGray;
  static const Color cardCircleBg = pureBlack;


  // Text
  static const Color primaryText = lightGray;
  static const Color secondaryText = mediumDimGray;
  static const Color placeholderText = dimGray;
  static const Color nameText = lightGray;

  // Chat Bubbles
  static const Color myBubble = mediumGray;
  static const Color myBubbleText = pureWhite;
  static const Color aiBubble = darkGray;
  static const Color aiBubbleText = lightGray;

  // Icons
  static const Color defaultIcon = softGray;
  static const Color activeIcon = lightGray;
}

class LightThemeColors {
  // Core Colors
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFCCCCCC);
  static const Color darkGray = Color(0xFF666666);
  static const Color softGray = Color(0xFF999999);
  static const Color dimGray = Color(0xFFAAAAAA);

  // AppBar
  static const Color appBarBackground = mediumGray;
  static const Color appBarText = pureBlack;
  static const Color appBarIcon = darkGray;

  // Background
  static const Color mainBackground = pureWhite;
  static const Color chatBackground = pureWhite;
  static const Color cardBackground = mediumGray;
  static const Color cardCircleBg = pureWhite;

  // Text
  static const Color primaryText = pureBlack;
  static const Color secondaryText = softGray;
  static const Color placeholderText = dimGray;
  static const Color nameText = pureBlack;

  // Chat Bubbles
  static const Color myBubble = mediumGray;
  static const Color myBubbleText = pureBlack;
  static const Color aiBubble = lightGray;
  static const Color aiBubbleText = pureBlack;

  // Icons
  static const Color defaultIcon = darkGray;
  static const Color activeIcon = pureBlack;
}

class BotTheme {
  final Color appBar;
  final Color background;
  final Color userBubble;
  final Color aiBubble;
  final Color cardBackground;
  final Color cardCircleBg;

  const BotTheme({
    required this.appBar,
    required this.background,
    required this.userBubble,
    required this.aiBubble,
    required this.cardBackground,
    required this.cardCircleBg,
  });


  void operator [](String other) {}
}

class DefaultThemeColors {
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);
  static const Color darkGray = Color(0xFF666666);
  static const Color darkGreen = Color(0xFF54684A);
  static const Color lightPink = Color(0xFFFFC2CC);


  // Text
  static const Color primaryText = pureBlack;
  static const Color nameText = darkGreen;

  // Icons
  static const Color defaultIcon = darkGray;
  static const Color activeIcon = pureBlack;

  // Pink bot themes
  static const List<BotTheme> botThemes = [
    BotTheme(
      appBar: Color(0xFFFFC2CC),
      background: Color(0xFFFFECEF),
      cardBackground: Color(0xFFFFC2CC),
      cardCircleBg: Color(0xFFFFECEF),
      userBubble: Color(0xFFE89AB0),
      aiBubble: Color(0xFFFFDDE6),
    ),
    BotTheme(
      appBar: Color(0xFFFCA9B7),
      background: Color(0xFFFFE6EA),
      cardBackground: Color(0xFFFCA9B7),
      cardCircleBg: Color(0xFFFFE6EA),
      userBubble: Color(0xFFEFB9CC),
      aiBubble: Color(0xFFFFE8F0),
    ),
    BotTheme(
      appBar: Color(0xFFFF869B),
      background: Color(0xFFFFDFE5),
      cardBackground: Color(0xFFFF869B),
      cardCircleBg: Color(0xFFFFDFE5),
      userBubble: Color(0xFFFF99BD),
      aiBubble: Color(0xFFFFDFEB),
    ),
    BotTheme(
      appBar: Color(0xFFFF738B),
      background: Color(0xFFFFD9DF),
      cardBackground: Color(0xFFFF738B),
      cardCircleBg: Color(0xFFFFD9DF),
      userBubble: Color(0xFFE689B0),
      aiBubble: Color(0xFFFFDBE6),
    ),
    BotTheme(
      appBar: Color(0xFFFF5976),
      background: Color(0xFFFFD2DA),
      cardBackground: Color(0xFFFF5976),
      cardCircleBg: Color(0xFFFFD2DA),
      userBubble: Color(0xFFF28CB5),
      aiBubble: Color(0xFFFFDFE9),
    ),
    // repeat for bots 6–10 (can reuse duplicates if needed)
    BotTheme(
      appBar: Color(0xFFFFC2CC),
      background: Color(0xFFFFECEF),
      cardBackground: Color(0xFFFFC2CC),
      cardCircleBg: Color(0xFFFFECEF),
      userBubble: Color(0xFFE89AB0),
      aiBubble: Color(0xFFFFDDE6),
    ),
    BotTheme(
      appBar: Color(0xFFFCA9B7),
      background: Color(0xFFFFE6EA),
      cardBackground: Color(0xFFFCA9B7),
      cardCircleBg: Color(0xFFFFE6EA),
      userBubble: Color(0xFFEFB9CC),
      aiBubble: Color(0xFFFFE8F0),
    ),
    BotTheme(
      appBar: Color(0xFFFF869B),
      background: Color(0xFFFFDFE5),
      cardBackground: Color(0xFFFF869B),
      cardCircleBg: Color(0xFFFFDFE5),
      userBubble: Color(0xFFFF99BD),
      aiBubble: Color(0xFFFFDFEB),
    ),
    BotTheme(
      appBar: Color(0xFFFF738B),
      background: Color(0xFFFFD9DF),
      cardBackground: Color(0xFFFF738B),
      cardCircleBg: Color(0xFFFFD9DF),
      userBubble: Color(0xFFE689B0),
      aiBubble: Color(0xFFFFDBE6),
    ),
    BotTheme(
      appBar: Color(0xFFFF5976),
      background: Color(0xFFFFD2DA),
      cardBackground: Color(0xFFFF5976),
      cardCircleBg: Color(0xFFFFD2DA),
      userBubble: Color(0xFFF28CB5),
      aiBubble: Color(0xFFFFDFE9),
    ),
  ];
}
