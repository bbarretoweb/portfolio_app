import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_app/core/theme/theme_notifier.dart';

/// Minimalist bar that allows switching active brand and brightness.
///
/// Refactored to use elegant popup menus and icon buttons.
class ThemeSwitcherBar extends ConsumerWidget {
  /// Creates the theme switcher bar.
  const ThemeSwitcherBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Brand picker as a sophisticated PopupMenuButton
        Semantics(
          label: 'Select brand theme',
          child: PopupMenuButton<String>(
            initialValue: state.brandId,
            tooltip: 'Brand Theme',
            icon: Icon(Icons.palette_outlined, color: colorScheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            position: PopupMenuPosition.under,
            onSelected: notifier.selectBrand,
            itemBuilder: (context) => brandLabels.entries
                .map(
                  (e) => PopupMenuItem(
                    value: e.key,
                    child: Text(
                      e.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: e.key == state.brandId
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: e.key == state.brandId
                                ? colorScheme.primary
                                : null,
                          ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(width: 8),
        // Brightness toggle with whimsical Morph & Hover effects
        _ThemeToggleIcon(
          isDark: state.brightness == Brightness.dark,
          color: colorScheme.primary,
          onPressed: () {
            SystemSound.play(SystemSoundType.click);
            notifier.toggleBrightness();
          },
        ),
      ],
    );
  }
}

class _ThemeToggleIcon extends StatefulWidget {
  const _ThemeToggleIcon({
    required this.isDark,
    required this.onPressed,
    required this.color,
  });

  final bool isDark;
  final VoidCallback onPressed;
  final Color color;

  @override
  State<_ThemeToggleIcon> createState() => _ThemeToggleIconState();
}

class _ThemeToggleIconState extends State<_ThemeToggleIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: widget.color.withAlpha(60),
                blurRadius: 16,
                spreadRadius: 2,
              ),
          ],
        ),
        child: IconButton(
          tooltip: 'Toggle dark mode',
          icon: AnimatedSwitcher(
            duration: disableAnimations
                ? Duration.zero
                : const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              // Create a delightful spinning morph effect
              return RotationTransition(
                turns: Tween<double>(begin: -0.5, end: 0).animate(animation),
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              widget.isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              key: ValueKey(widget.isDark ? 'dark' : 'light'),
              color: widget.color,
            ),
          ),
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
