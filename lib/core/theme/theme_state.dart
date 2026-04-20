import 'package:flutter/material.dart';

/// Immutable state for the active theme configuration.
final class ThemeState {
  /// Creates a [ThemeState] with defaults: personal brand in dark mode.
  const ThemeState({
    this.brandId = 'portfolio',
    this.brightness = Brightness.dark,
  });

  /// The key in [brandRegistry] that identifies the active brand.
  final String brandId;

  /// Whether the UI uses [Brightness.light] or [Brightness.dark].
  final Brightness brightness;

  /// Returns a copy with one or both fields replaced.
  ThemeState copyWith({String? brandId, Brightness? brightness}) => ThemeState(
        brandId: brandId ?? this.brandId,
        brightness: brightness ?? this.brightness,
      );
}
