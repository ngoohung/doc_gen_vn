// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

class DocGenApp extends ConsumerWidget {
  const DocGenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'DocGen VN',
      debugShowCheckedModeBanner: false,

      // ── Theme ──────────────────────────────────────────────────────────────
      theme:      AppTheme.light(),
      darkTheme:  AppTheme.dark(),
      themeMode:  themeMode,

      // ── Routing ────────────────────────────────────────────────────────────
      routerConfig: router,

      // ── Locale & Localizations (Sửa lỗi TextField) ─────────────────────────
      locale: const Locale('vi', 'VN'),
      supportedLocales: const [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}