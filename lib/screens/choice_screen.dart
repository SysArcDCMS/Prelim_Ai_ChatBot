import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';
import '../services/prompts.dart';


class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  final List<String> filters = [
    'All',
    'Legal Counsel',
    'Mental Health Assistant',
    'Travel Planner',
    'Financial Advisor',
    'Baking Specialist',
  ];

  String selectedFilter = 'All';

  bool _chatMatchesFilter(String botTitle) {
    if (selectedFilter == 'All') return true;

    switch (selectedFilter) {
      case 'Legal Counsel':
        return botTitle == 'Legal Counsel';
      case 'Mental Health Assistant':
        return botTitle == 'Mental Health Assistant';
      case 'Travel Planner':
        return botTitle == 'Travel Planner';
      case 'Financial Advisor':
        return botTitle == 'Financial Advisor';
      case 'Baking Specialist':
        return botTitle == 'Baking Specialist';
      default:
        return true;
    }
  }

  final List<Map<String, dynamic>> bots = [
    {
      'name': 'Verdict',
      'title': 'Legal Counsel',
      'prompt': Prompts.verdictPrompt,
      'icon' : Icons.gavel,
      'background1' : 0xFFFFC2CC , // APP BAR
      'background2' : 0xFFFFECEF , // BACKGROUND
      'bubbleuser' : 0xFFE89AB0 , // USER BUBBLE
      'bubbleai' : 0xFFFFDDE6 , // AI BUBBLE
    },
    {
      'name': 'Haven',
      'title': 'Mental Health Assistant',
      'prompt': Prompts.havenPrompt,
      'icon' : Icons.favorite,
      'background1' : 0xFFFCA9B7,
      'background2' : 0xFFFFE6EA ,
      'bubbleuser' : 0xFFEFB9CC ,
      'bubbleai' : 0xFFFFE8F0 ,
    },
    {
      'name': 'Compass',
      'title': 'Travel Planner',
      'prompt': Prompts.compassPrompt,
      'icon' : Icons.explore,
      'background1' : 0xFFFF869B ,
      'background2' : 0xFFFFDFE5 ,
      'bubbleuser' : 0xFFFF99BD ,
      'bubbleai' : 0xFFFFDFEB ,
    },
    {
      'name': 'Ledger',
      'title': 'Financial Advisor',
      'prompt': Prompts.ledgerPrompt,
      'icon' : Icons.account_balance,
      'background1' : 0xFFFF738B ,
      'background2' : 0xFFFFD9DF ,
      'bubbleuser' : 0xFFE689B0 ,
      'bubbleai' : 0xFFFFDBE6 ,
    },
    {
      'name': 'Glaze',
      'title': 'Baking Specialist',
      'prompt': Prompts.glazePrompt,
      'icon' : Icons.bakery_dining,
      'background1' : 0xFFFF5976 ,
      'background2' : 0xFFFFD2DA ,
      'bubbleuser' : 0xFFF28CB5 ,
      'bubbleai' : 0xFFFFDFE9 ,
    },
  ];

  final GlobalKey _dropdownKey = GlobalKey();

  void _showBotDropdown() {
    final RenderBox row =
    _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset position = row.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + row.size.height,
        overlay.size.width - position.dx - row.size.width,
        overlay.size.height - position.dy,
      ),
      items: filters.map((filter) {
        return PopupMenuItem<String>(
          value: filter,
          child: Text(filter),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedFilter = value;
        });
      }
    });
  }



  Map<String, dynamic> getBotByRole(String name) {
    return bots.firstWhere(
          (bot) => bot['name'] == name,
      orElse: () => {
        'name': 'Unknown',
        'title': 'Unknown',
        'prompt': '',
        'icon': Icons.chat_bubble_outline,
      },
    );
  }

  String getPromptForBot(String role) {
    switch (role) {
      case 'Verdict':
        return Prompts.verdictPrompt;
      case 'Haven':
        return Prompts.havenPrompt;
      case 'Compass':
        return Prompts.compassPrompt;
      case 'Ledger':
        return Prompts.ledgerPrompt;
      case 'Glaze':
        return Prompts.glazePrompt;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDE4F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFB9C5),
                      Color(0xFFFF5976)
                    ]
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    '🌸  S M A R T   M O C H I  🌸',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'WHO DO YOU FEEL LIKE TALKING TO?',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

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
                    itemCount: bots.length,
                    itemBuilder: (context, index) {
                      final bot = bots[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _chatBotCard(
                          name: bot['name']!,
                          title: bot['title']!,
                          icon: bot['icon'],
                          background1 : bot['background1'],
                          background2 : bot['background2'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  systemPrompt: bot['prompt'],
                                  title: bot['title'],
                                  name: bot['name'],
                                  background1 : bot['background1'],
                                  background2 : bot['background2'],
                                  bubbleuser : bot['bubbleuser'],
                                  bubbleai : bot['bubbleai']
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    key: _dropdownKey,
                    children: [
                      Text(selectedFilter),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: _showBotDropdown,
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  )
                ],
              ),

              const SizedBox(height: 12),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final chats = snapshot.data!.docs.where((doc) {
                      final botTitle = doc['botTitle'] ?? '';
                      return _chatMatchesFilter(botTitle);
                    }).toList();

                    if (chats.isEmpty) {
                      return const Center(child: Text('No chat history yet'));
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        return _historyItem(
                          title: chat['botTitle'] ?? 'Unknown Bot',
                          name: chat['botName'] ?? '',
                          chatId: chat.id,
                          background1: chat['background1'],
                          background2: chat['background2'],
                          bubbleuser: chat['bubbleuser'],
                          bubbleai: chat['bubbleai'],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chatBotCard({
    required String name,
    required String title,
    required IconData icon,
    required int background1,
    required int background2,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(background1),
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
                color: Color(background2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 140,
            height: 45,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 140,
            height: 18,
            child: Text(
              name,
              style: const TextStyle(
                color: Color(0xFF54684A),
                fontStyle: FontStyle.italic,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap to chat →',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Color(background2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _historyItem({
    required String title,
    required String name,
    required String chatId,
    required int background1,
    required int background2,
    required int bubbleuser,
    required int bubbleai
  }) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('chats').doc(chatId).get(),
      builder: (context, snapshot) {
        String createdTime = '';
        if (snapshot.hasData && snapshot.data!.exists) {
          final timestamp = snapshot.data!['createdAt'] as Timestamp?;
          if (timestamp != null) {
            final dateTime = timestamp.toDate();
            createdTime =
            '${dateTime.year}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')} ${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}';
          }
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  title: title,
                  systemPrompt: getPromptForBot(name),
                  chatId: chatId,
                  name: name,
                  background1 : background1,
                  background2: background2,
                  bubbleuser: bubbleuser,
                  bubbleai: bubbleai
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(background1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(background2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getBotByRole(name)['icon'],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (createdTime.isNotEmpty)
                      Text(createdTime, style: const TextStyle(color: Color(0xFF54684A), fontSize: 12)),
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
