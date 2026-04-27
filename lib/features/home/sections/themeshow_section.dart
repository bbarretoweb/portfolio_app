import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_app/core/theme/theme_notifier.dart';
import 'package:portfolio_app/core/theme/theme_state.dart';

/// Section showcasing the live brand/brightness switching capability.
///
/// Wired to [themeProvider] so every selector card and toggle mutates the
/// global [ThemeState] and instantly re-renders the entire app via
/// [AnimatedTheme].
class ThemeshowSection extends ConsumerWidget {
  /// Creates the themeshow section.
  const ThemeshowSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(20),
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withAlpha(80)),
          bottom: BorderSide(color: colorScheme.outlineVariant.withAlpha(80)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            children: [
              const DkSectionHeader(
                title: 'Live Theme Switching',
                subtitle: 'Design System',
              ),
              const SizedBox(height: 16),
              Text(
                'Every visual on this page is driven by a DkBrandTheme — an '
                'abstract contract that lets any brand inject its colour '
                'palette, typography, and radii without modifying the '
                'design_kit source.\n'
                'Pick a brand below and watch the entire app re-render '
                'instantly.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withAlpha(180),
                ),
              ),
              const SizedBox(height: 48),

              // ── Brand selector cards ────────────────────────────────────
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: brandRegistry.entries.map((entry) {
                  final isSelected = themeState.brandId == entry.key;
                  final label = brandLabels[entry.key] ?? entry.key;
                  return _BrandCard(
                    label: label,
                    brandTheme: entry.value,
                    isSelected: isSelected,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      notifier.selectBrand(entry.key);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // ── Brightness toggle ────────────────────────────────────────
              _BrightnessToggle(
                brightness: themeState.brightness,
                onToggle: () {
                  HapticFeedback.lightImpact();
                  notifier.toggleBrightness();
                },
              ),
              const SizedBox(height: 56),

              // ── Live component preview ───────────────────────────────────
              _LivePreviewPanel(themeState: themeState),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Brand Card
// ─────────────────────────────────────────────────────────────────────────────

class _BrandCard extends StatefulWidget {
  const _BrandCard({
    required this.label,
    required this.brandTheme,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final DkBrandTheme brandTheme;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<_BrandCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    // Render the card's color swatch using its own dark theme so the preview
    // is always legible regardless of the current app brightness.
    final preview = widget.brandTheme.dark();
    final previewScheme = preview.colorScheme;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Semantics(
      button: true,
      label: 'Switch to ${widget.label} brand',
      selected: widget.isSelected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: 200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? cs.primaryContainer.withAlpha(120)
                  : cs.surface.withAlpha(60),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isSelected
                    ? cs.primary
                    : (_hovering
                        ? cs.primary.withAlpha(120)
                        : cs.outlineVariant.withAlpha(80)),
                width: widget.isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (widget.isSelected || _hovering)
                  BoxShadow(
                    color: cs.primary.withAlpha(widget.isSelected ? 60 : 30),
                    blurRadius: 24,
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Color swatch row — shows the brand's palette at a glance
                Row(
                  children: [
                    _Swatch(color: previewScheme.primary),
                    const SizedBox(width: 6),
                    _Swatch(color: previewScheme.secondary),
                    const SizedBox(width: 6),
                    _Swatch(color: previewScheme.tertiary),
                    const SizedBox(width: 6),
                    _Swatch(color: previewScheme.onSurface),
                    const SizedBox(width: 6),
                    _Swatch(color: previewScheme.onSurfaceVariant),
                    const Spacer(),
                    if (widget.isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: cs.primary,
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  widget.label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: widget.isSelected ? cs.primary : cs.onSurface,
                    fontWeight:
                        widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color.withAlpha(120), blurRadius: 6),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Brightness Toggle
// ─────────────────────────────────────────────────────────────────────────────

class _BrightnessToggle extends StatelessWidget {
  const _BrightnessToggle({
    required this.brightness,
    required this.onToggle,
  });

  final Brightness brightness;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withAlpha(80),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: cs.primary.withAlpha(80)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeOutBack,
                  transitionBuilder: (child, anim) => RotationTransition(
                    turns: Tween<double>(begin: -0.25, end: 0).animate(anim),
                    child: ScaleTransition(scale: anim, child: child),
                  ),
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    key: ValueKey(isDark),
                    color: cs.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  isDark ? 'Dark Mode' : 'Light Mode',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '— tap to switch',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withAlpha(120),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Live Preview Panel
// ─────────────────────────────────────────────────────────────────────────────

class _LivePreviewPanel extends StatelessWidget {
  const _LivePreviewPanel({required this.themeState});
  final ThemeState themeState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final brandLabel = brandLabels[themeState.brandId] ?? themeState.brandId;
    final modeLabel =
        themeState.brightness == Brightness.dark ? 'Dark' : 'Light';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cs.surface.withAlpha(60),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 16, color: cs.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Live Component Preview',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: cs.primary,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: cs.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$brandLabel · $modeLabel',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 16,
            runSpacing: 20,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Buttons
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.rocket_launch_rounded, size: 16),
                label: const Text('Primary'),
              ),
              FilledButton.tonal(
                onPressed: () {},
                child: const Text('Secondary'),
              ),
              OutlinedButton(
                onPressed: () {},
                child: const Text('Outlined'),
              ),
              // Tags
              const DkTag(
                label: 'Flutter',
                icon: Icon(Icons.bolt_rounded, size: 14),
              ),
              const DkTag(
                label: 'Dart 3+',
                icon: Icon(Icons.code_rounded, size: 14),
              ),
              // Chip
              DkChip(
                label: const Text('Design Systems'),
                variant: DkChipVariant.filter,
                onDeleted: () {},
              ),
              // Badge
              DkBadge(
                count: 42,
                color: cs.primary,
                textColor: cs.onPrimary,
                child: const Icon(Icons.notifications_outlined, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Color chips
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ColorChip(label: 'Primary', color: cs.primary),
              _ColorChip(label: 'Secondary', color: cs.secondary),
              _ColorChip(label: 'Tertiary', color: cs.tertiary),
              _ColorChip(label: 'Surface', color: cs.surface),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Compute a contrasting text color for readability on any background
    final foreground =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
            ? Colors.white
            : Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
