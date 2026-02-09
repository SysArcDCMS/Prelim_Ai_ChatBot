import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'services/firebase_options.dart';
import 'screens/choice_screen.dart';
import 'settings/theme_notifier.dart';
import 'settings/json_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final jsonLocale = JsonLocalizations();
  await jsonLocale.loadJson();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => jsonLocale),
      ],
      child: const ChatApp(),
    ),
  );
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();
    final localeProvider = context.watch<JsonLocalizations>();

    return MaterialApp(
      title: '🌸SMART MOCHI🌸',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.themeData,

      // Use JSON locale system
      locale: Locale(localeProvider.currentLangCode),

      home: const ChoiceScreen(),
    );
  }
}