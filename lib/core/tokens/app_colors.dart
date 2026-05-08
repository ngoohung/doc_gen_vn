import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ───────────────────────────────────────────
  static const primary        = Color(0xFF4F46E5); // Indigo 600
  static const primaryHover   = Color(0xFF4338CA); // Indigo 700
  static const primaryPress   = Color(0xFF3730A3); // Indigo 800
  static const primarySoft    = Color(0xFFEEF2FF); // Indigo 50

  // ── Semantic ─────────────────────────────────────────
  static const success        = Color(0xFF22C55E);
  static const successSoft    = Color(0xFFDCFCE7);
  static const warning        = Color(0xFFF59E0B);
  static const warningSoft    = Color(0xFFFEF3C7);
  static const error          = Color(0xFFEF4444);
  static const errorSoft      = Color(0xFFFEE2E2);
  static const info           = Color(0xFF3B82F6);
  static const infoSoft       = Color(0xFFDBEAFE);

  // ── Light Mode Surfaces ───────────────────────────────
  static const bgLight        = Color(0xFFF8F9FA);
  static const cardLight      = Color(0xFFFFFFFF);
  static const sunkenLight    = Color(0xFFF1F5F9);
  static const borderLight    = Color(0xFFE5E7EB);
  static const borderStrong   = Color(0xFFD1D5DB);

  // ── Light Mode Text ───────────────────────────────────
  static const fgLight        = Color(0xFF111827);
  static const fgMutedLight   = Color(0xFF4B5563);
  static const fgSubtleLight  = Color(0xFF6B7280);
  static const fgDisabledLight= Color(0xFF9CA3AF);

  // ── Dark Mode Surfaces ────────────────────────────────
  static const bgDark         = Color(0xFF0F172A); // true dark, blue-cast
  static const cardDark       = Color(0xFF1E293B);
  static const sunkenDark     = Color(0xFF1E293B);
  static const borderDark     = Color(0xFF1F2937);

  // ── Dark Mode Text ────────────────────────────────────
  static const fgDark         = Color(0xFFF1F5F9);
  static const fgMutedDark    = Color(0xFFCBD5E1);
  static const fgSubtleDark   = Color(0xFF94A3B8);
  static const fgDisabledDark = Color(0xFF64748B);
}