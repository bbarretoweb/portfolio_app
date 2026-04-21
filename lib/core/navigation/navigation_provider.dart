import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier that manages section keys for scrolling within the SPA.
class NavigationNotifier extends Notifier<void> {
  final Map<String, GlobalKey> _keys = {
    'hero': GlobalKey(debugLabel: 'hero'),
    'about': GlobalKey(debugLabel: 'about'),
    'projects': GlobalKey(debugLabel: 'projects'),
    'themeshow': GlobalKey(debugLabel: 'themeshow'),
    'showcase': GlobalKey(debugLabel: 'showcase'),
    'contact': GlobalKey(debugLabel: 'contact'),
  };

  @override
  void build() {}

  /// Returns the GlobalKey associated with a section ID.
  GlobalKey? getKey(String id) => _keys[id];

  /// Scrolls to the specified section with a smooth animation and
  /// header offset.
  void scrollTo(String id, {double headerOffset = 64.0}) {
    final key = _keys[id];
    if (key == null) return;

    final context = key.currentContext;
    if (context == null) return;

    // We use a custom scrolling logic to account for the sticky header offset.
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final position = box.localToGlobal(Offset.zero);
    final scrollable = Scrollable.of(context);
    
    // Calculate the jump taking the header into account.
    final currentOffset = scrollable.position.pixels;
    final targetOffset = currentOffset + position.dy - headerOffset;

    scrollable.position.animateTo(
      targetOffset.clamp(0, scrollable.position.maxScrollExtent),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }
}

/// Provider for the [NavigationNotifier].
final navigationProvider = NotifierProvider<NavigationNotifier, void>(
  NavigationNotifier.new,
);
