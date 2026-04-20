import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/shared/widgets/max_width_box.dart';

/// About section: bio, tech-stack tags, and horizontal divider.
class AboutSection extends StatelessWidget {
  /// Creates the about section.
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MaxWidthBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DkSectionHeader(
              title: 'About Me',
              subtitle: 'Who I am',
              showDivider: true,
            ),
            const SizedBox(height: 40),
            DkGrid(
              children: [
                // Bio card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color:
                        theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                    borderRadius: Theme.of(context).extension<DkRadii>()?.lg ??
                        BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Senior Flutter Engineer based in Europe, specialized in '
                    'design systems, performance optimization, and accessible '
                    'mobile experiences.\n\n'
                    'I build components that adhere to EAA / WCAG 2.1 AA '
                    'standards, architect clean packages with explicit dependency '
                    'injection, and obsess over the details that make an interface '
                    'feel truly premium.',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                // Stat cards
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatCard(
                      label: 'Years of Experience',
                      value: '6+',
                    ),
                    const SizedBox(height: 16),
                    _StatCard(
                      label: 'Apps Shipped',
                      value: '20+',
                    ),
                    const SizedBox(height: 16),
                    _StatCard(
                      label: 'Design Systems Built',
                      value: '4',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            const DkDivider(label: Text('Tech Stack')),
            const SizedBox(height: 24),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                DkTag(label: 'Flutter'),
                DkTag(label: 'Dart 3+'),
                DkTag(label: 'Riverpod'),
                DkTag(label: 'go_router'),
                DkTag(label: 'WCAG 2.1 AA'),
                DkTag(label: 'CI/CD'),
                DkTag(label: 'Firebase'),
                DkTag(label: 'REST / GraphQL'),
                DkTag(label: 'Design Systems'),
                DkTag(label: 'Unit & Golden Tests'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(60),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Text(
            value,
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
