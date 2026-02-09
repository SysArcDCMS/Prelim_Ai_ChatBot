import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/color_theme.dart';
import '../settings/json_localizations.dart';
import '../settings/theme_notifier.dart';
import '../settings/app_themes.dart';


void openSideMenu(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Side Menu",
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, _) {
              final currentTheme = themeNotifier.currentTheme;
              final t = context.watch<JsonLocalizations>();

              // Determine menu colors dynamically
              late Color backgroundColor;
              late Color textColor;
              late Color iconColor;

              if (currentTheme == AppTheme.dark) {
                backgroundColor = DarkThemeColors.cardBackground;
                textColor = DarkThemeColors.primaryText;
                iconColor = DarkThemeColors.activeIcon;
              } else if (currentTheme == AppTheme.light) {
                backgroundColor = LightThemeColors.cardBackground;
                textColor = LightThemeColors.primaryText;
                iconColor = LightThemeColors.activeIcon;
              } else {
                // Default: use first bot theme
                final botColors = AppThemes.botColors(0);
                backgroundColor = botColors.cardBackground;
                textColor = DefaultThemeColors.primaryText;
                iconColor = DefaultThemeColors.defaultIcon;
              }

              return Container(
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(24),
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            t.t('main_menu'),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              color: textColor,
                            ),
                          ),
                        ),
                        Divider(color: textColor.withOpacity(0.5)),

                        // Theme selection
                        ExpansionTile(
                          leading: Icon(Icons.palette, color: iconColor),
                          title: Text(t.t('theme'), style: TextStyle(color: textColor)),
                          children: [
                            ListTile(
                              title: const Text('🌸 Default'),
                              onTap: () => themeNotifier.setTheme(AppTheme.defaultTheme),
                            ),
                            ListTile(
                              title: const Text('☀️ Light'),
                              onTap: () => themeNotifier.setTheme(AppTheme.light),
                            ),
                            ListTile(
                              title: const Text('🌙 Dark'),
                              onTap: () => themeNotifier.setTheme(AppTheme.dark),
                            ),
                          ],
                        ),


                        // Language selection
                        ExpansionTile(
                          leading: Icon(Icons.language, color: iconColor),
                          title: Text(t.t('language'), style: TextStyle(color: textColor)),
                          children: [
                            ListTile(
                              title: const Text('English'),
                              onTap: () {
                                context.read<JsonLocalizations>().setLanguage('en');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Tagalog'),
                              onTap: () {
                                context.read<JsonLocalizations>().setLanguage('tl');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Spanish'),
                              onTap: () {
                                context.read<JsonLocalizations>().setLanguage('es');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Japanese'),
                              onTap: () {
                                context.read<JsonLocalizations>().setLanguage('ja');
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Korean'),
                              onTap: () {
                                context.read<JsonLocalizations>().setLanguage('ko');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),

                        // Add Bot
                        ListTile(
                          leading: Icon(Icons.person_add, color: iconColor),
                          title: Text(
                            t.t('add_bot'),
                            style:
                            TextStyle(
                              color: textColor
                            )
                          ),
                          onTap: () {
                          }
                        ),
                      ],
                    ),
                  ),ggf
                ),
              );
            },
          ),
        ),
      );
    },
    transitionBuilder: (_, animation, __, child) {
      final tween = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      );
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}


