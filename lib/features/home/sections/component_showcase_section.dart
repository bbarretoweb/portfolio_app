import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/shared/widgets/max_width_box.dart';

/// Full component showcase — every design_kit widget rendered at least once.
class ComponentShowcaseSection extends StatefulWidget {
  /// Creates the component showcase section.
  const ComponentShowcaseSection({super.key});

  @override
  State<ComponentShowcaseSection> createState() =>
      _ComponentShowcaseSectionState();
}

class _ComponentShowcaseSectionState extends State<ComponentShowcaseSection> {
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MaxWidthBox(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 32, right: 32, top: 120, bottom: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DkSectionHeader(
              title: 'Component Showcase',
              subtitle: 'Design Kit in action',
              showDivider: true,
            ),
            const SizedBox(height: 40),
            // --- Buttons ---
            _SubSection(
              label: 'Buttons',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  DkButton.filled(
                      label: const Text('Filled'), onPressed: () {}),
                  DkButton.outlined(
                    label: const Text('Outlined'),
                    onPressed: () {},
                  ),
                  DkButton.text(label: const Text('Text'), onPressed: () {}),
                  DkButton.filled(label: const Text('Disabled')),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // --- Chips ---
            _SubSection(
              label: 'Chips',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  DkChip(
                    variant: DkChipVariant.filter,
                    label: const Text('Filter Chip'),
                  ),
                  DkChip(
                    variant: DkChipVariant.input,
                    label: const Text('Input Chip'),
                    onDeleted: () {},
                  ),
                  DkChip(
                    variant: DkChipVariant.suggestion,
                    label: const Text('Suggestion'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // --- Inputs ---
            _SubSection(
              label: 'Inputs',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DkTextField(hintText: 'Normal text field'),
                  const SizedBox(height: 12),
                  const DkTextField(
                    hintText: 'Error state',
                    errorText: 'This field is required',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      DkSwitch(
                        value: _switchValue,
                        onChanged: (v) => setState(() => _switchValue = v),
                        semanticLabel: 'Example switch',
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _switchValue ? 'On' : 'Off',
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // --- Feedback ---
            _SubSection(
              label: 'Feedback',
              child: Wrap(
                spacing: 24,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Badge — dot
                  DkBadge(
                    child: const Icon(Icons.notifications_outlined),
                  ),
                  // Badge — count
                  DkBadge(
                    count: 7,
                    child: const Icon(Icons.mail_outline_rounded),
                  ),
                  // Snackbar trigger buttons
                  DkButton.outlined(
                    label: const Text('Info Snackbar'),
                    onPressed: () => DkSnackbar.show(
                      context: context,
                      message: 'ℹ️ This is an informational message.',
                      variant: DkSnackbarVariant.info,
                    ),
                  ),
                  DkButton.outlined(
                    label: const Text('Success Snackbar'),
                    onPressed: () => DkSnackbar.show(
                      context: context,
                      message: '✅ Operation completed successfully!',
                      variant: DkSnackbarVariant.success,
                    ),
                  ),
                  DkButton.outlined(
                    label: const Text('Warning Snackbar'),
                    onPressed: () => DkSnackbar.show(
                      context: context,
                      message: '⚠️ Proceed with caution.',
                      variant: DkSnackbarVariant.warning,
                    ),
                  ),
                  DkButton.outlined(
                    label: const Text('Error Snackbar'),
                    onPressed: () => DkSnackbar.show(
                      context: context,
                      message: '❌ Something went wrong.',
                      variant: DkSnackbarVariant.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // --- Display ---
            _SubSection(
              label: 'Display',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatars
                  Wrap(
                    spacing: 16,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const DkAvatar(
                        size: DkAvatarSize.sm,
                        imageProvider: NetworkImage(
                          'https://picsum.photos/seed/av1/48/48',
                        ),
                        semanticLabel: 'Small avatar',
                      ),
                      const DkAvatar(
                        size: DkAvatarSize.md,
                        imageProvider: NetworkImage(
                          'https://picsum.photos/seed/av1/72/72',
                        ),
                        semanticLabel: 'Medium avatar',
                      ),
                      const DkAvatar(
                        size: DkAvatarSize.lg,
                        imageProvider: NetworkImage(
                          'https://picsum.photos/seed/av1/120/120',
                        ),
                        semanticLabel: 'Large avatar',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tags with custom colours
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      const DkTag(label: 'Default Tag'),
                      DkTag(
                        label: 'Success',
                        backgroundColor: Colors.green.withAlpha(30),
                        textColor: Colors.green.shade700,
                      ),
                      DkTag(
                        label: 'Warning',
                        backgroundColor: Colors.orange.withAlpha(30),
                        textColor: Colors.orange.shade700,
                      ),
                      DkTag(
                        label: 'Danger',
                        backgroundColor: Colors.red.withAlpha(30),
                        textColor: Colors.red.shade700,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // --- Layout ---
            _SubSection(
              label: 'Layout',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  DkDivider(),
                  SizedBox(height: 12),
                  DkDivider(label: Text('With Label')),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Text('Left'),
                        SizedBox(width: 16),
                        DkDivider(axis: Axis.vertical),
                        SizedBox(width: 16),
                        Text('Right'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple subsection with a [DkDivider] label header.
class _SubSection extends StatelessWidget {
  const _SubSection({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DkDivider(label: Text(label)),
        const SizedBox(height: 20),
        child,
      ],
    );
  }
}
