// lib/core/theme/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

// ── ThemeMode Notifier ────────────────────────────────────────────────────────
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void setLight()  => state = ThemeMode.light;
  void setDark()   => state = ThemeMode.dark;
  void setSystem() => state = ThemeMode.system;

  /// Chuyển đổi light ↔ dark (dùng cho nút toggle trên TopBar)
  void toggle() =>
      state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

  bool get isDark => state == ThemeMode.dark;
}

final themeModeProvider =
StateNotifierProvider<ThemeNotifier, ThemeMode>(
      (ref) => ThemeNotifier(),
);