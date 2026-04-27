import 'dart:convert';

import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// Contact section with a form and social links.
class ContactSection extends StatefulWidget {
  /// Creates the contact section.
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        DkSnackbar.show(
          context: context,
          message: '❌ Could not launch $url',
          variant: DkSnackbarVariant.error,
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final formspreeEndpointId = dotenv.env['FORMSPREE_ENDPOINT'];
    if (formspreeEndpointId == null || formspreeEndpointId.trim().isEmpty) {
      debugPrint(
        '❌ Erro: FORMSPREE_ENDPOINT não está configurado no arquivo .env',
      );
      if (mounted) {
        DkSnackbar.show(
          context: context,
          message: '❌ Configuração ausente. Verifique os logs.',
          variant: DkSnackbarVariant.error,
        );
        setState(() => _isLoading = false);
      }
      return;
    }

    final url = Uri.parse('https://formspree.io/f/$formspreeEndpointId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'message': _messageController.text,
        }),
      );

      if (mounted) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          DkSnackbar.show(
            context: context,
            message: "✅ Message sent! I'll be in touch shortly.",
            variant: DkSnackbarVariant.success,
          );
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
        } else {
          DkSnackbar.show(
            context: context,
            message: '❌ Failed to send message. Please try again.',
            variant: DkSnackbarVariant.error,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        DkSnackbar.show(
          context: context,
          message: '❌ Connection error. Please check your internet.',
          variant: DkSnackbarVariant.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surfaceContainerHighest.withAlpha(20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
      child: Column(
        children: [
          const DkSectionHeader(
            title: 'Get In Touch',
            subtitle: 'Contact',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Let's build something amazing together.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    DkTextField(
                      controller: _nameController,
                      hintText: 'Your Name',
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DkTextField(
                      controller: _emailController,
                      hintText: 'Your Email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email.';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DkTextField(
                      controller: _messageController,
                      hintText: 'Your Message',
                      maxLines: 5,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your message.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    DkButton.filled(
                      label: const Text('Send Message'),
                      isLoading: _isLoading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 64),
          const DkDivider(label: Text('Connect'), indent: 64, endIndent: 64),
          const SizedBox(height: 32),
          // Social links centered
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              DkButton.text(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.github,
                      size: 20,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    const SizedBox(width: 8),
                    const Text('GitHub'),
                  ],
                ),
                onPressed: () => _launchURL('https://github.com/bbarretoweb'),
              ),
              DkButton.text(
                label: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.linkedin,
                      size: 20,
                      color: Color(0xFF0A66C2), // LinkedIn Official Blue
                    ),
                    SizedBox(width: 8),
                    Text('LinkedIn'),
                  ],
                ),
                onPressed: () =>
                    _launchURL('https://www.linkedin.com/in/bbarretoweb/'),
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
