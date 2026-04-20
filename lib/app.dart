import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_app/core/router/app_router.dart';
import 'package:portfolio_app/core/theme/theme_notifier.dart';

/// Root application widget.
///
/// Consumes [activeThemeProvider] so every brand/brightness change propagates
/// through [AnimatedTheme], giving smooth colour interpolation across the app.
class App extends ConsumerWidget {
  /// Creates the root app widget.
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(activeThemeProvider);

    return MaterialApp.router(
      title: 'Bruno — Flutter Engineer',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routerConfig: appRouter,
    );
  }
}
