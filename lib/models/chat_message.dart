class ChatMessage {
  final String text;
  final String role;
  final DateTime timestamp;
  final String senderName;

  ChatMessage({
    required this.text,
    required this.role,
    required this.timestamp,
    required this.senderName,
  });

  bool get isUserMessage => role == "user";
}