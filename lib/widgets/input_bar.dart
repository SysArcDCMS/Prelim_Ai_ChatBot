import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/color_theme.dart';
import '../settings/json_localizations.dart';
import '../settings/theme_notifier.dart';
import '../settings/app_themes.dart';

class InputBar extends StatefulWidget {
  final Function(String) onSendMessage;

  const InputBar({Key? key, required this.onSendMessage}) : super(key: key);

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) {
        final theme = themeNotifier.currentTheme;
        final t = context.watch<JsonLocalizations>();

        late Color textColor;
        late Color sendButtonColor;

        if (theme == AppTheme.dark) {
          textColor = DarkThemeColors.primaryText;
          sendButtonColor = DarkThemeColors.appBarBackground;
        } else if (theme == AppTheme.light) {
          textColor = LightThemeColors.primaryText;
          sendButtonColor = LightThemeColors.appBarBackground;
        } else {
          final botColors = AppThemes.botColors(0);
          textColor = DefaultThemeColors.defaultIcon;
          sendButtonColor = botColors.appBar;
        }

        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: t.t('whats_mind'),
                    hintStyle: TextStyle(color: textColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: textColor,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: textColor,
                        width: 2,
                      ),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (value) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: _sendMessage,
                mini: true,
                backgroundColor: sendButtonColor,
                child: Icon(
                  Icons.send,
                  color: textColor,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
