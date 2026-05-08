import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const _ui   = 'Inter';
  static const _mono = 'JetBrainsMono';

  static const h1 = TextStyle(fontFamily: _ui, fontSize: 32, fontWeight: FontWeight.w700,
      letterSpacing: -0.02, height: 1.3);
  static const h2 = TextStyle(fontFamily: _ui, fontSize: 24, fontWeight: FontWeight.w600,
      letterSpacing: -0.01, height: 1.3);
  static const h3 = TextStyle(fontFamily: _ui, fontSize: 20, fontWeight: FontWeight.w600,
      letterSpacing: -0.01, height: 1.3);
  static const h4 = TextStyle(fontFamily: _ui, fontSize: 16, fontWeight: FontWeight.w600,
      height: 1.3);

  static const body    = TextStyle(fontFamily: _ui, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static const bodyMd  = TextStyle(fontFamily: _ui, fontSize: 14, fontWeight: FontWeight.w500, height: 1.5);
  static const bodySm  = TextStyle(fontFamily: _ui, fontSize: 13, fontWeight: FontWeight.w400, height: 1.5);
  static const caption = TextStyle(fontFamily: _ui, fontSize: 12, fontWeight: FontWeight.w400, height: 1.4);

  static const codeBody = TextStyle(fontFamily: _mono, fontSize: 13, fontWeight: FontWeight.w400,
      height: 1.6, fontFeatures: [FontFeature.enable('liga'), FontFeature.enable('calt')]);
  static const codeSm   = TextStyle(fontFamily: _mono, fontSize: 12, fontWeight: FontWeight.w400, height: 1.6);
}