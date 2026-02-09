import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/theme_notifier.dart';
import '../settings/color_theme.dart';
import '../settings/app_themes.dart';

class HistoryFilterDropdown extends StatelessWidget {
  final List<String> filters;
  final String value;
  final ValueChanged<String> onChanged;

  const HistoryFilterDropdown({
    super.key,
    required this.filters,
    required this.value,
    required this.onChanged,
  });

  void _showDropdown(BuildContext context, GlobalKey key) {
    final RenderBox row =
    key.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset position =
    row.localToGlobal(Offset.zero, ancestor: overlay);

    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final currentTheme = themeNotifier.currentTheme;

    Color popupBackground;
    Color textColor;

    if (currentTheme == AppTheme.light) {
      popupBackground = LightThemeColors.appBarBackground;
      textColor = LightThemeColors.primaryText;
    } else if (currentTheme == AppTheme.dark) {
      popupBackground = DarkThemeColors.appBarBackground;
      textColor = DarkThemeColors.primaryText;
    } else {
      popupBackground = DefaultThemeColors.lightPink;
      textColor = DefaultThemeColors.primaryText;
    }

    showMenu<String>(
      context: context,
      color: popupBackground,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + row.size.height,
        overlay.size.width - position.dx - row.size.width,
        overlay.size.height - position.dy,
      ),
      items: filters.map((f) {
        return PopupMenuItem<String>(
          value: f,
          child: Text(f, style: TextStyle(color: textColor)),
        );
      }).toList(),
    ).then((selected) {
      if (selected != null) {
        onChanged(selected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final currentTheme = themeNotifier.currentTheme;

    Color displayColor;
    Color displayTextColor;

    if (currentTheme == AppTheme.light) {
      displayColor = LightThemeColors.appBarBackground;
      displayTextColor = LightThemeColors.primaryText;
    } else if (currentTheme == AppTheme.dark) {
      displayColor = DarkThemeColors.appBarBackground;
      displayTextColor = DarkThemeColors.primaryText;
    } else {
      displayColor = DefaultThemeColors.lightPink;
      displayTextColor = DefaultThemeColors.primaryText;
    }

    final GlobalKey dropdownKey = GlobalKey();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: displayColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: displayTextColor),
      ),
      child: Row(
        key: dropdownKey,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(color: displayTextColor)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _showDropdown(context, dropdownKey),
            child: Icon(Icons.keyboard_arrow_down, color: displayTextColor),
          ),
        ],
      ),
    );
  }
}
