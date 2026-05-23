import 'package:flutter/material.dart';

/// Capsule 2.0 Design System - Color Palette
/// Based on the UI/UX Design Specifications
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFFDBEAFE);

  // Neutral Colors
  static const Color gray900 = Color(0xFF111827);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color white = Color(0xFFFFFFFF);

  // Semantic Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Platform Colors
  static const Color windowsBlue = Color(0xFF0078D4);
  static const Color macOSGray = Color(0xFF8E8E93);
  static const Color linuxOrange = Color(0xFFE95420);
}

/// Typography Scale
class AppTypography {
  AppTypography._();

  static const String primaryFont = 'Inter';
  static const String monospaceFont = 'JetBrains Mono';

  // Font Sizes
  static const double displaySize = 32.0;
  static const double h1Size = 24.0;
  static const double h2Size = 20.0;
  static const double h3Size = 18.0;
  static const double bodyLargeSize = 16.0;
  static const double bodySize = 14.0;
  static const double bodySmallSize = 12.0;
  static const double captionSize = 11.0;

  // Line Heights
  static const double displayLineHeight = 40.0;
  static const double h1LineHeight = 32.0;
  static const double h2LineHeight = 28.0;
  static const double h3LineHeight = 24.0;
  static const double bodyLargeLineHeight = 24.0;
  static const double bodyLineHeight = 20.0;
  static const double bodySmallLineHeight = 16.0;
  static const double captionLineHeight = 16.0;
}

/// Spacing System (8px base)
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;   // 0.5 units
  static const double sm = 8.0;   // 1 unit
  static const double md = 16.0;  // 2 units
  static const double lg = 24.0;  // 3 units
  static const double xl = 32.0;  // 4 units
  static const double x2l = 48.0; // 6 units
  static const double x3l = 64.0; // 8 units
}

/// Border Radius Scale
class AppRadius {
  AppRadius._();

  static const double none = 0.0;
  static const double small = 4.0;
  static const double medium = 8.0;
  static const double large = 12.0;
  static const double xLarge = 16.0;
  static const double full = 9999.0;
}

/// Shadow Elevation Levels
class AppShadows {
  AppShadows._();

  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get modal => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 15,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ];
}

/// Custom Theme Extension
extension CapsuleTheme on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  Color get surfaceColor => Theme.of(this).colorScheme.surface;
  Color get primaryColor => Theme.of(this).colorScheme.primary;
  Color get onPrimaryColor => Theme.of(this).colorScheme.onPrimary;
}
