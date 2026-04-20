import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/core/theme/theme_notifier.dart';
import 'package:portfolio_app/shared/widgets/theme_switcher_bar.dart';

/// Section showcasing the live brand/brightness switching capability.
class ThemeshowSection extends StatelessWidget {
  /// Creates the themeshow section.
  const ThemeshowSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.primaryContainer.withAlpha(30),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DkSectionHeader(
            title: 'Live Theme Switching',
            subtitle: 'Themes',
            showDivider: true,
          ),
          const SizedBox(height: 24),
          Text(
            'Every visual on this page is driven by a DkBrandTheme — an abstract '
            'contract that lets any brand inject its colour palette, typography, '
            'radii, and spacing without touching the design_kit source.\n\n'
            'Try switching between the three registered brands below. '
            'The entire app re-renders instantly via AnimatedTheme interpolation.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          // Registered brands list
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: brandLabels.entries.map((e) {
              return DkChip(
                variant: DkChipVariant.filter,
                label: Text(e.value),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: const ThemeSwitcherBar(),
          ),
        ],
      ),
    );
  }
}
