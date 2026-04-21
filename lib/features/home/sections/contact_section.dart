import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';

/// Contact section with a form and social links.
class ContactSection extends StatefulWidget {
  /// Creates the contact section.
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    DkSnackbar.show(
      context: context,
      message: '✅ Message sent! I\'ll be in touch shortly.',
      variant: DkSnackbarVariant.success,
    );
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surfaceContainerHighest.withAlpha(20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const DkSectionHeader(
            title: 'Get In Touch',
            subtitle: 'Contact',
            showDivider: true,
            alignment: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 56),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.light
                    ? Colors.white
                    : colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.outline.withAlpha(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Let\'s build something amazing together.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  DkTextField(
                    controller: _nameController,
                    hintText: 'Your Name',
                  ),
                  const SizedBox(height: 16),
                  DkTextField(
                    controller: _emailController,
                    hintText: 'Your Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  DkTextField(
                    controller: _messageController,
                    hintText: 'Your Message',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 32),
                  DkButton.filled(
                    label: const Text('Send Message'),
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 64),
          DkDivider(label: Text('Connect'), indent: 64, endIndent: 64),
          const SizedBox(height: 32),
          // Social links centered
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              DkButton.text(
                label: const Text('GitHub'),
                onPressed: () {},
              ),
              DkButton.text(
                label: const Text('LinkedIn'),
                onPressed: () {},
              ),
              DkButton.text(
                label: const Text('X (Twitter)'),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 80),
          Opacity(
            opacity: 0.6,
            child: Text(
              'Built with Flutter & design_kit  ·  © 2026 Bruno',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
