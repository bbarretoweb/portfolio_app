import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_app/features/home/home_page.dart';
import 'package:portfolio_app/shared/widgets/app_shell.dart';

/// Named route constants.
abstract final class AppRoutes {
  static const home = '/';
}

/// Application router using a [ShellRoute] so the [AppShell] persists.
/// In SPA mode, we only have one main route.
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) => _fadePage(
            key: state.pageKey,
            child: const HomePage(),
          ),
        ),
      ],
    ),
  ],
);

/// Produces a [CustomTransitionPage] with a [FadeTransition] (350 ms).
CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) =>
    CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
        child: child,
      ),
    );
