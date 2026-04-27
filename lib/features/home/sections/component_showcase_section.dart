import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/shared/widgets/max_width_box.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Full component showcase — rendered via lazy loading with tabs.
class ComponentShowcaseSection extends StatefulWidget {
  /// Creates the component showcase section.
  const ComponentShowcaseSection({super.key});

  @override
  State<ComponentShowcaseSection> createState() =>
      _ComponentShowcaseSectionState();
}

class _ComponentShowcaseSectionState extends State<ComponentShowcaseSection>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  late final TabController _tabController;
  bool _switchValue = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_isVisible && info.visibleFraction > 0.1) {
      if (mounted) setState(() => _isVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('component-showcase-visibility'),
      onVisibilityChanged: _onVisibilityChanged,
      child: MaxWidthBox(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 32, right: 32, top: 120, bottom: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DkSectionHeader(
                title: 'Component Showcase',
                subtitle: 'Design Kit in action',
              ),
              const SizedBox(height: 40),
              if (!_isVisible)
                const SizedBox(height: 400) // Placeholder for lazy rendering
              else ...[
                // Storybook TabBar
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerColor: Theme.of(context).dividerColor.withAlpha(30),
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  tabs: const [
                    Tab(icon: Icon(Icons.touch_app_outlined), text: 'Actions'),
                    Tab(icon: Icon(Icons.input_outlined), text: 'Forms'),
                    Tab(
                      icon: Icon(Icons.chat_bubble_outline),
                      text: 'Feedback',
                    ),
                    Tab(
                      icon: Icon(Icons.dashboard_outlined),
                      text: 'Data Display',
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Content Gallery
                AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    Widget activeTab;
                    switch (_tabController.index) {
                      case 0:
                        activeTab = _ActionsShowcase();
                      case 1:
                        activeTab = _FormsShowcase(
                          switchValue: _switchValue,
                          onSwitchChanged: (v) =>
                              setState(() => _switchValue = v),
                        );
                      case 2:
                        activeTab = _FeedbackShowcase();
                      case 3:
                      default:
                        activeTab = _DisplayShowcase();
                    }

                    // Key ensures that the widget tree is rebuilt on tab
                    // change, triggering the EntranceFader animations.
                    return KeyedSubtree(
                      key: ValueKey(_tabController.index),
                      child: activeTab,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ComponentPreview extends StatelessWidget {
  const _ComponentPreview({
    required this.className,
    required this.child,
  });

  final String className;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<DkRadii>() ?? const DkRadii();

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border.all(color: theme.dividerColor.withAlpha(30)),
        borderRadius: radii.md,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Technical Annotation Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.dividerColor.withAlpha(30)),
              ),
              color: theme.colorScheme.surface,
            ),
            child: Text(
              className,
              style: theme.textTheme.labelMedium?.copyWith(
                fontFamily: 'monospace',
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Interactive Preview Area
          Container(
            padding: const EdgeInsets.all(32),
            alignment: Alignment.center,
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ActionsShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _ComponentPreview(
        className: 'DkButton.filled',
        child: DkButton.filled(
          label: const Text('Filled'),
          onPressed: () {},
        ),
      ),
      _ComponentPreview(
        className: 'DkButton.outlined',
        child: DkButton.outlined(
          label: const Text('Outlined'),
          onPressed: () {},
        ),
      ),
      _ComponentPreview(
        className: 'DkButton.text',
        child: DkButton.text(label: const Text('Text'), onPressed: () {}),
      ),
      const _ComponentPreview(
        className: 'DkButton.filled (Disabled)',
        child: DkButton.filled(label: Text('Disabled')),
      ),
    ];

    return _SubSection(
      label: 'Buttons',
      child: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(items.length, (index) {
            return EntranceFader(
              delay: Duration(milliseconds: 100 * index),
              child: items[index],
            );
          }),
        ),
      ),
    );
  }
}

class _FormsShowcase extends StatelessWidget {
  const _FormsShowcase({
    required this.switchValue,
    required this.onSwitchChanged,
  });

  final bool switchValue;
  final ValueChanged<bool> onSwitchChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      const _ComponentPreview(
        className: 'DkTextField',
        child: DkTextField(hintText: 'Normal text field'),
      ),
      const _ComponentPreview(
        className: 'DkTextField (Error)',
        child: DkTextField(
          hintText: 'Error state',
          errorText: 'This field is required',
        ),
      ),
      _ComponentPreview(
        className: 'DkSwitch',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DkSwitch(
              value: switchValue,
              onChanged: onSwitchChanged,
              semanticLabel: 'Example switch',
            ),
            const SizedBox(width: 12),
            Text(
              switchValue ? 'On' : 'Off',
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
      ),
    ];

    return _SubSection(
      label: 'Inputs',
      child: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(items.length, (index) {
            return EntranceFader(
              delay: Duration(milliseconds: 100 * index),
              child: items[index],
            );
          }),
        ),
      ),
    );
  }
}

class _FeedbackShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      const _ComponentPreview(
        className: 'DkBadge',
        child: DkBadge(
          child: Icon(Icons.notifications_outlined),
        ),
      ),
      const _ComponentPreview(
        className: 'DkBadge (Count)',
        child: DkBadge(
          count: 7,
          child: Icon(Icons.mail_outline_rounded),
        ),
      ),
      _ComponentPreview(
        className: 'DkSnackbar (Info)',
        child: DkButton.outlined(
          label: const Text('Show Info'),
          onPressed: () => DkSnackbar.show(
            context: context,
            message: 'ℹ️ This is an informational message.',
          ),
        ),
      ),
      _ComponentPreview(
        className: 'DkSnackbar (Success)',
        child: DkButton.outlined(
          label: const Text('Show Success'),
          onPressed: () => DkSnackbar.show(
            context: context,
            message: '✅ Operation completed successfully!',
            variant: DkSnackbarVariant.success,
          ),
        ),
      ),
      _ComponentPreview(
        className: 'DkSnackbar (Error)',
        child: DkButton.outlined(
          label: const Text('Show Error'),
          onPressed: () => DkSnackbar.show(
            context: context,
            message: '❌ Something went wrong.',
            variant: DkSnackbarVariant.error,
          ),
        ),
      ),
    ];

    return _SubSection(
      label: 'Feedback',
      child: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(items.length, (index) {
            return EntranceFader(
              delay: Duration(milliseconds: 100 * index),
              child: items[index],
            );
          }),
        ),
      ),
    );
  }
}

class _DisplayShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EntranceFader(
          child: _SubSection(
            label: 'Chips & Tags',
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  const _ComponentPreview(
                    className: 'DkChip.filter',
                    child: DkChip(
                      variant: DkChipVariant.filter,
                      label: Text('Filter Chip'),
                    ),
                  ),
                  _ComponentPreview(
                    className: 'DkChip.input',
                    child: DkChip(
                      variant: DkChipVariant.input,
                      label: const Text('Input Chip'),
                      onDeleted: () {},
                    ),
                  ),
                  _ComponentPreview(
                    className: 'DkTag',
                    child: Wrap(
                      spacing: 8,
                      children: [
                        const DkTag(label: 'Default'),
                        DkTag(
                          label: 'Success',
                          backgroundColor: Colors.green.withAlpha(30),
                          textColor: Colors.green.shade700,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const EntranceFader(
          delay: Duration(milliseconds: 100),
          child: _SubSection(
            label: 'Avatars',
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _ComponentPreview(
                    className: 'DkAvatar.sm',
                    child: DkAvatar(
                      size: DkAvatarSize.sm,
                      imageProvider: NetworkImage(
                        'https://picsum.photos/seed/av1/48/48',
                      ),
                      semanticLabel: 'Small avatar',
                    ),
                  ),
                  _ComponentPreview(
                    className: 'DkAvatar.lg',
                    child: DkAvatar(
                      size: DkAvatarSize.lg,
                      imageProvider: NetworkImage(
                        'https://picsum.photos/seed/av1/120/120',
                      ),
                      semanticLabel: 'Large avatar',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const EntranceFader(
          delay: Duration(milliseconds: 200),
          child: _SubSection(
            label: 'Layout',
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _ComponentPreview(
                    className: 'DkDivider',
                    child: DkDivider(),
                  ),
                  _ComponentPreview(
                    className: 'DkDivider (With Label)',
                    child: DkDivider(label: Text('Label')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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

/// A wrapper that applies a staggered slide and fade entrance animation.
class EntranceFader extends StatefulWidget {
  /// Creates an entrance fader.
  const EntranceFader({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.offset = const Offset(0, 30),
    super.key,
  });

  /// The widget to animate.
  final Widget child;

  /// Delay before the animation starts.
  final Duration delay;

  /// Duration of the animation.
  final Duration duration;

  /// Starting offset for the slide transition.
  final Offset offset;

  @override
  State<EntranceFader> createState() => _EntranceFaderState();
}

class _EntranceFaderState extends State<EntranceFader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(curve);
    _slideAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(curve);

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child, // Prevents unnecessary rebuilds of the child tree
    );
  }
}
