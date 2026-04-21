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
                showDivider: true,
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
                  unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                  tabs: const [
                    Tab(icon: Icon(Icons.touch_app_outlined), text: 'Actions'),
                    Tab(icon: Icon(Icons.input_outlined), text: 'Forms'),
                    Tab(icon: Icon(Icons.chat_bubble_outline), text: 'Feedback'),
                    Tab(icon: Icon(Icons.dashboard_outlined), text: 'Data Display'),
                  ],
                ),
                const SizedBox(height: 40),
                
                // Content Gallery
                AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, child) {
                    return IndexedStack(
                      index: _tabController.index,
                      children: [
                        _ActionsShowcase(),
                        _FormsShowcase(
                          switchValue: _switchValue,
                          onSwitchChanged: (v) => setState(() => _switchValue = v),
                        ),
                        _FeedbackShowcase(),
                        _DisplayShowcase(),
                      ],
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
              border: Border(bottom: BorderSide(color: theme.dividerColor.withAlpha(30))),
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
    return _SubSection(
      label: 'Buttons',
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _ComponentPreview(
            className: 'DkButton.filled',
            child: DkButton.filled(
                label: const Text('Filled'), onPressed: () {}),
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
          _ComponentPreview(
            className: 'DkButton.filled (Disabled)',
            child: DkButton.filled(label: const Text('Disabled')),
          ),
        ],
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
    return _SubSection(
      label: 'Inputs',
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
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
        ],
      ),
    );
  }
}

class _FeedbackShowcase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SubSection(
      label: 'Feedback',
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _ComponentPreview(
            className: 'DkBadge',
            child: DkBadge(
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          _ComponentPreview(
            className: 'DkBadge (Count)',
            child: DkBadge(
              count: 7,
              child: const Icon(Icons.mail_outline_rounded),
            ),
          ),
          _ComponentPreview(
            className: 'DkSnackbar (Info)',
            child: DkButton.outlined(
              label: const Text('Show Info'),
              onPressed: () => DkSnackbar.show(
                context: context,
                message: 'ℹ️ This is an informational message.',
                variant: DkSnackbarVariant.info,
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
        ],
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
        _SubSection(
          label: 'Chips & Tags',
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _ComponentPreview(
                className: 'DkChip.filter',
                child: DkChip(
                  variant: DkChipVariant.filter,
                  label: const Text('Filter Chip'),
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
        const SizedBox(height: 32),
        _SubSection(
          label: 'Avatars',
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
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
        const SizedBox(height: 32),
        _SubSection(
          label: 'Layout',
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
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
