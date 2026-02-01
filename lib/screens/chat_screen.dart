import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';
import '../services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final String name;
  final String systemPrompt;
  final int background1;
  final int background2;
  final int bubbleuser;
  final int bubbleai;
  final String? chatId;

  const ChatScreen({
    super.key,
    required this.title,
    required this.name,
    required this.systemPrompt,
    required this.background1,
    required this.background2,
    required this.bubbleuser,
    required this.bubbleai,
    this.chatId,
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
        'botTitle': widget.title,
        'background1': widget.background1,
        'background2': widget.background2,
        'bubbleai': widget.bubbleai,
        'bubbleuser': widget.bubbleuser,
        'createdAt': FieldValue.serverTimestamp(),
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

  // 🔥 MULTI-TURN HANDLER
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Color(widget.background1) ,
      ),
      backgroundColor: Color(widget.background2),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Start chatting!'),
                  Text(
                    'Keep the chat going — Gemini remembers 🧠',
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
                return MessageBubble(message: msg, bubbleuser: widget.bubbleuser, bubbleai: widget.bubbleai,);
              },
            ),
          ),

          // Loading
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 12),
                  Text('🤖 Thinking with context...'),
                ],
              ),
            ),

          // Input
          InputBar(onSendMessage: handleSend),
        ],
      ),
    );
  }
}