import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Personal brand theme for the portfolio owner.
///
/// Electric violet communicates creativity and technical sophistication.
/// Generous radii (8/16/24) feel modern and approachable without being playful.
final class PortfolioBrandTheme implements DkBrandTheme {
  /// Creates the personal portfolio brand theme.
  const PortfolioBrandTheme();

  static const Color _seed = Color(0xFF6C63FF);
  static const Color _darkBg = Color(0xFF0F0F1A);
  static const Color _lightBg = Color(0xFFF8F8FF);

  static const DkRadii _radii = DkRadii(
    sm: BorderRadius.all(Radius.circular(8)),
    md: BorderRadius.all(Radius.circular(16)),
    lg: BorderRadius.all(Radius.circular(24)),
    pill: BorderRadius.all(Radius.circular(999)),
  );

  static TextTheme _textTheme(Color display, Color body) {
    final base = DkTypography.buildTextTheme(
      fontFamily: GoogleFonts.inter().fontFamily ?? 'Inter',
      displayColor: display,
      bodyColor: body,
    );
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(fontWeight: FontWeight.w700),
      displayMedium: base.displayMedium?.copyWith(fontWeight: FontWeight.w700),
      displaySmall: base.displaySmall?.copyWith(fontWeight: FontWeight.w600),
      headlineLarge: base.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
      headlineMedium: base.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
      headlineSmall: base.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  @override
  ThemeData light() => DkTheme.build(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          surface: _lightBg,
        ),
        textTheme: _textTheme(
          const Color(0xFF1A1A2E),
          const Color(0xFF3D3D5C),
        ),
        radii: _radii,
      );

  @override
  ThemeData dark() => DkTheme.build(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
          surface: _darkBg,
        ),
        textTheme: _textTheme(
          const Color(0xFFE8E5FF),
          const Color(0xFFB0ACCC),
        ),
        radii: _radii,
      );
}
