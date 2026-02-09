import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../data/bots.dart';
import '../screens/chat_screen.dart';
import '../settings/app_themes.dart';
import '../settings/json_localizations.dart';
import '../widgets/chat_bot_card.dart';
import '../widgets/history_item.dart';
import '../widgets/side_menu.dart';
import '../widgets/history_filter_dropdown.dart';
import '../settings/theme_notifier.dart';

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  String selectedFilter = 'all'; // store the key, not label

  // Check if chat matches selected filter
  bool _chatMatchesFilter(String botTitleKey) {
    if (selectedFilter == 'all') return true;
    return botTitleKey == selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Access localization
    final t = context.watch<JsonLocalizations>();
    final currentLang = t.currentLangCode;

    // Filter options localized
    final filterOptions = [
      {'key': 'all', 'label': t.t('all')},
      {'key': 'legal_counsel', 'label': t.t('legal_counsel')},
      {'key': 'mental_health', 'label': t.t('mental_health')},
      {'key': 'financial_advisor', 'label': t.t('financial_advisor')},
      {'key': 'travel_planner', 'label': t.t('travel_planner')},
      {'key': 'baking_specialist', 'label': t.t('baking_specialist')},
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '🌸  S M A R T   M O C H I  🌸',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontStyle: FontStyle.italic,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Provider.of<ThemeNotifier>(context).currentTheme ==
            AppTheme.defaultTheme
            ? Colors.transparent
            : Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        flexibleSpace: Provider.of<ThemeNotifier>(context).currentTheme ==
            AppTheme.defaultTheme
            ? Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFB9C5),
                const Color(0xFFFF5976),
              ],
            ),
          ),
        )
            : null,
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => openSideMenu(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Who to talk" header
            Text(
              t.t('who_to_talk'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),

            // Bot cards
            SizedBox(
              height: 240,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: true,
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: defaultBots.length,
                  itemBuilder: (context, index) {
                    final bot = defaultBots[index];
                    final botTitle =
                        bot.titles[currentLang] ?? bot.titles['en']!;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ChatBotCard(
                        name: bot.name,
                        title: botTitle,
                        icon: bot.icon,
                        botIndex: bot.index,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                title: botTitle,
                                titleKey: bot.titleKey,
                                name: bot.name,
                                systemPrompt: bot.prompt,
                                botIndex: bot.index,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // History header and filter dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.t('history'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),

                // Filter Dropdown
                HistoryFilterDropdown(
                  filters: filterOptions.map((f) => f['label']!).toList(),
                  value: filterOptions
                      .firstWhere((f) => f['key'] == selectedFilter)['label']!,
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = filterOptions
                          .firstWhere((f) => f['label'] == value)['key']!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // History list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).iconTheme.color,
                      ),
                    );
                  }

                  final chats = snapshot.data!.docs;

                  // Filter by selected titleKey
                  final filteredChats = chats.where((doc) {
                    final botTitleKey = doc['botTitleKey'] ?? '';
                    return _chatMatchesFilter(botTitleKey);
                  }).toList();

                  if (filteredChats.isEmpty) {
                    return Center(
                      child: Text(
                        t.t('no_history'),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    );
                  }

                  return ListView(
                    children: filteredChats.map((doc) {
                      final bot = defaultBots
                          .firstWhere((b) => b.name == doc['botName']);
                      final botTitle =
                          bot.titles[currentLang] ?? bot.titles['en']!;
                      return HistoryItem(
                        chatId: doc.id,
                        title: botTitle,
                        name: bot.name,
                        icon: bot.icon,
                        prompt: bot.prompt,
                        botIndex: bot.index,
                        titleKey: bot.titleKey,
                        cardBackground: bot.cardBackground,
                        cardCircleBg: bot.cardCircleBg,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}