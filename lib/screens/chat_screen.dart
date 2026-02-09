import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../models/chat_message.dart';
import '../screens/choice_screen.dart';
import '../settings/color_theme.dart';
import '../settings/json_localizations.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';
import '../widgets/side_menu.dart';
import '../services/gemini_service.dart';
import '../settings/theme_notifier.dart';
import '../settings/app_themes.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final String name;
  final String systemPrompt;
  final String? chatId;
  final int? botIndex;
  final String titleKey;

  const ChatScreen({
    super.key,
    required this.title,
    required this.titleKey,
    required this.name,
    required this.systemPrompt,
    this.chatId,
    this.botIndex,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final String chatId;
  final List<ChatMessage> messages = [];
  final ScrollController scrollController = ScrollController();
  bool _isLoading = false;
  bool _chatCreated = false;

  @override
  void initState() {
    super.initState();

    if (widget.chatId != null && widget.chatId!.isNotEmpty) {
      chatId = widget.chatId!;
      _chatCreated = true;
      _loadPreviousMessages();
    } else {
      chatId = _firestore.collection('chats').doc().id;
    }
  }

  Future<void> _loadPreviousMessages() async {
    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    final loadedMessages = snapshot.docs.map((doc) {
      final data = doc.data();
      return ChatMessage(
        text: data['text'] ?? '',
        role: data['role'] ?? 'model',
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        senderName: data['senderName'] ?? 'Unknown',
      );
    }).toList();

    setState(() {
      messages.addAll(loadedMessages);
    });

    scrollToBottom();
  }

  void addMessage(String text, String role, String senderName) async {
    setState(() {
      messages.add(ChatMessage(
        text: text,
        role: role,
        timestamp: DateTime.now(),
        senderName: senderName,
      ));
    });

    scrollToBottom();

    final chatRef = _firestore.collection('chats').doc(chatId);

    if (!_chatCreated) {
      await chatRef.set({
        'botName': widget.name,
        'botTitleKey': widget.titleKey,
        'botIndex': widget.botIndex ?? 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await chatRef.collection('language').add({

      });

      _chatCreated = true;
    }

    await chatRef.collection('messages').add({
      'text': text,
      'role': role,
      'timestamp': FieldValue.serverTimestamp(),
      'senderName': senderName,
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> handleSend(String text) async {
    addMessage(text, "user", "You");

    setState(() => _isLoading = true);

    try {
      final aiResponse = await GeminiService.sendMultiTurnMessage(
        messages,
        systemPrompt: widget.systemPrompt,
      );

      addMessage(aiResponse, "model", widget.name);
    } catch (e) {
      addMessage('❌ Error: $e', "model", "model");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        final theme = themeNotifier.currentTheme;
        final t = context.watch<JsonLocalizations>();
        late Color background, appBarColor, bubbleUser, bubbleAI;

        if (theme == AppTheme.dark) {
          background = DarkThemeColors.mainBackground;
          appBarColor = DarkThemeColors.appBarBackground;
          bubbleUser = DarkThemeColors.myBubble;
          bubbleAI = DarkThemeColors.aiBubble;
        } else if (theme == AppTheme.light) {
          background = LightThemeColors.mainBackground;
          appBarColor = LightThemeColors.appBarBackground;
          bubbleUser = LightThemeColors.myBubble;
          bubbleAI = LightThemeColors.aiBubble;
        } else {
          // default bot colors
          final botColors = AppThemes.botColors(widget.botIndex ?? 0);
          background = botColors.background;
          appBarColor = botColors.appBar;
          bubbleUser = botColors.userBubble;
          bubbleAI = botColors.aiBubble;
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChoiceScreen()),
                );
              },
            ),
            title: Consumer<JsonLocalizations>(
              builder: (context, t, _) {
                return Text(t.t(widget.title));
              },
            ),
            backgroundColor: appBarColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => openSideMenu(context),
              ),
            ],
          ),
          backgroundColor: background,
          body: Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat, size: 100, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(t.t('start_chat')),
                      Text(
                        t.t('keep_chat'),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return MessageBubble(
                      message: msg,
                      bubbleuser: bubbleUser.value,
                      bubbleai: bubbleAI.value,
                    );
                  },
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 12),
                      Text(t.t('thinking')),
                    ],
                  ),
                ),
              InputBar(onSendMessage: handleSend),
            ],
          ),
        );
      },
    );
  }
}
