import 'dart:ui';
import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_app/core/navigation/navigation_provider.dart';
import 'package:portfolio_app/shared/widgets/max_width_box.dart';
import 'package:portfolio_app/shared/widgets/theme_switcher_bar.dart';

/// Persistent shell that wraps every page.
///
/// Implements a sophisticated "Liquid Glass" navigation bar that floats
/// above the underlying content. Now handles anchor scrolling instead of
/// route transitions.
class AppShell extends ConsumerWidget {
  /// Creates the app shell.
  const AppShell({required this.child, super.key});

  /// The current content (typically [HomePage]).
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(navigationProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withAlpha(150),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withAlpha(40),
                  ),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: MaxWidthBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 600;
                        return Row(
                          children: [
                            // Site Logo / Home anchor
                            InkWell(
                              onHover: (_) {}, // Visual consistency
                              onTap: () => nav.scrollTo('hero'),
                              child: Row(
                                children: [
                                  const DkAvatar(
                                    size: DkAvatarSize.sm,
                                    imageProvider: AssetImage(
                                      'assets/images/meHD.png',
                                    ),
                                    semanticLabel: 'Bruno',
                                  ),
                                  if (!isMobile) ...[
                                    const SizedBox(width: 12),
                                    Text(
                                      'Bruno Barreto',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const Spacer(),
                            // Navigation Links
                            if (!isMobile) ...[
                              TextButton(
                                onPressed: () => nav.scrollTo('showcase'),
                                child: const Text('Design Kit'),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () => nav.scrollTo('contact'),
                                child: const Text('Contact'),
                              ),
                              const SizedBox(width: 16),
                            ] else ...[
                              PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.menu,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                tooltip: 'Navigation menu',
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                position: PopupMenuPosition.under,
                                onSelected: (id) => nav.scrollTo(id),
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'showcase',
                                    child: Text('Design Kit'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'contact',
                                    child: Text('Contact'),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                            ],
                            // Theme Controls
                            const ThemeSwitcherBar(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: child,
    );
  }
}
