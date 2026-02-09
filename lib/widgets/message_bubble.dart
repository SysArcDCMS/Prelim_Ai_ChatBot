import 'package:flutter/material.dart';
import '/models/chat_message.dart';


class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final int bubbleai;
  final int bubbleuser;

  const MessageBubble({Key? key,
    required this.message,
    required this.bubbleai,
    required this.bubbleuser

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
      message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.isUserMessage
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              message.senderName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: message.isUserMessage
                  ? Color(bubbleuser)
                  : Color(bubbleai),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              message.text,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}



