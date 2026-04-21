import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_app/core/theme/portfolio_brand_theme.dart';
import 'package:portfolio_app/core/theme/theme_state.dart';

/// All registered brand themes. Add a new brand here — nothing else changes.
const Map<String, DkBrandTheme> brandRegistry = {
  'portfolio': PortfolioBrandTheme(),
  'acme': AcmeBrandTheme(),
  'betacorp': BetaCorpBrandTheme(),
};

/// Human-readable labels for the brand dropdown.
const Map<String, String> brandLabels = {
  'portfolio': "✦ Bruno's Brand",
  'acme': '⬛ Acme Corp',
  'betacorp': '◆ BetaCorp',
};

/// Notifier that owns and mutates [ThemeState].
final class ThemeNotifier extends StateNotifier<ThemeState> {
  /// Creates the notifier with default state.
  ThemeNotifier() : super(const ThemeState());

  /// Switches the active brand to [brandId].
  void selectBrand(String brandId) {
    assert(
      brandRegistry.containsKey(brandId),
      'Brand "$brandId" not found in registry.',
    );
    state = state.copyWith(brandId: brandId);
  }

  /// Toggles between [Brightness.light] and [Brightness.dark].
  void toggleBrightness() {
    final next = state.brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
    state = state.copyWith(brightness: next);
  }
}

/// Global provider for [ThemeNotifier] and [ThemeState].
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>(
  (ref) => ThemeNotifier(),
);

/// Convenience provider that resolves the active [ThemeData].
final activeThemeProvider = Provider<ThemeData>((ref) {
  final state = ref.watch(themeProvider);
  final brand = brandRegistry[state.brandId]!;
  return switch (state.brightness) {
    Brightness.light => brand.light(),
    Brightness.dark => brand.dark(),
  };
});
