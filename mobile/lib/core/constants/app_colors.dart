import 'package:flutter/material.dart';

/// Smriti Design Tokens — Sunrise warmth & Assamese earthy tones.
/// Palette: Golden orange, warm amber, deep brown — familiar, dignified, non-clinical.
/// High contrast for elder accessibility. Every color earns its place.
class AppColors {
  AppColors._();

  // Backgrounds — warm sunrise dawn
  static const Color backgroundWarm = Color(0xFFFFF8F0); // Warm cream — morning light
  static const Color surfaceWarm = Color(0xFFFFF0DC);    // Soft amber tint
  static const Color cardSurface = Color(0xFFFFFFFF);    // Pure white for crisp cards
  static const Color surfaceElevated = Color(0xFFFFFAF4); // Gentle elevated warm tint

  // Primary Action & Brand — deep warm amber / turmeric gold
  static const Color forestPrimary = Color(0xFFB45309);  // Deep amber-brown (turmeric)
  static const Color forestDark = Color(0xFF8B3E04);     // Darker pressed amber
  static const Color forestLight = Color(0xFFD97706);    // Warm gold highlight

  // Warm Support & Calm — muted terracotta/apricot
  static const Color sage = Color(0xFFC2793A);           // Warm terracotta
  static const Color sageLight = Color(0xFFFFEDD8);      // Soft apricot tint
  static const Color sageDark = Color(0xFF9A5A25);

  // Warm Highlights & Accents — marigold & saffron
  static const Color peach = Color(0xFFF59E0B);          // Marigold yellow
  static const Color peachLight = Color(0xFFFEF3C7);     // Soft marigold tint
  static const Color peachDark = Color(0xFFD97706);

  // Text Colors — warm, high contrast, never clinical cold grey
  static const Color textPrimary = Color(0xFF2D1A06);    // Deep warm brown
  static const Color textSecondary = Color(0xFF5C3A1E);  // Warm medium brown
  static const Color textTertiary = Color(0xFF8B5A2B);   // Softer warm brown
  static const Color textOnPrimary = Color(0xFFFFFFFF);  // White on dark buttons

  // Neutral Borders & Dividers — warm tones
  static const Color borderSoft = Color(0xFFE8D5B7);     // Warm biscuit border
  static const Color divider = Color(0xFFF0E0C4);

  // States (Warm, grounded)
  static const Color successSage = Color(0xFF15803D);    // Earthy green success
  static const Color warningWarm = Color(0xFFEA580C);    // Deep orange warning
  static const Color errorGentle = Color(0xFFDC2626);    // Red — still gentle
  static const Color infoBlueSoft = Color(0xFF0369A1);
  static const Color offlineAmber = Color(0xFFB45309);

  // Cognitive Domain Accent Colors (Warm differentiation)
  static const Color domainMemory = Color(0xFFB45309);       // Amber
  static const Color domainAttention = Color(0xFFC2793A);    // Terracotta
  static const Color domainLanguage = Color(0xFF9B6A3A);     // Warm Sienna
  static const Color domainExecutive = Color(0xFF7C4A1E);    // Deep Brown
  static const Color domainOrientation = Color(0xFFF59E0B);  // Marigold
  static const Color domainVisuospatial = Color(0xFFD97706); // Gold
}
