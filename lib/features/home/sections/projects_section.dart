import 'package:design_kit/design_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const _projects = [
  _Project(
    imageUrl: 'https://picsum.photos/seed/proj1/600/400',
    title: 'design_kit',
    subtitle: 'Component Library',
    description:
        'A fully accessible, brand-agnostic Flutter design system built to EAA / WCAG 2.1 AA standards. '
        'Implements inversion of control for all theme and asset injection.',
    tags: ['Flutter', 'Dart 3+', 'WCAG'],
    imageLabel: 'Screenshot of the design_kit component showcase',
  ),
  _Project(
    imageUrl: 'https://picsum.photos/seed/proj2/600/400',
    title: 'Monorepo Workspace',
    subtitle: 'Architecture',
    description: 'Production-grade Flutter monorepo separating design package '
        'from showcase app with strict build boundaries and CI/CD pipelines.',
    tags: ['Architecture', 'CI/CD', 'Riverpod'],
    imageLabel: 'Monorepo architecture diagram',
  ),
  _Project(
    imageUrl: 'https://picsum.photos/seed/proj3/600/400',
    title: 'Portfolio App',
    subtitle: 'This very app',
    description:
        'A modern Flutter portfolio with live brand and brightness switching, '
        'fluid scroll animations, and a full component showcase — built on design_kit.',
    tags: ['go_router', 'Riverpod', 'Animation'],
    imageLabel: 'Portfolio app hero screenshot',
  ),
  // Placeholders
  _Project(
    imageUrl: '',
    title: 'Coming Soon',
    subtitle: 'Next Big Thing',
    description:
        'Currently working on a secret project involving game engines and 3D rendering.',
    tags: ['Secret', '3D'],
    imageLabel: 'Placeholder',
    isPlaceholder: true,
  ),
  _Project(
    imageUrl: '',
    title: 'Coming Soon',
    subtitle: 'WIP',
    description:
        'Exploring WebAssembly and high-performance rust integrations.',
    tags: ['WASM', 'Rust'],
    imageLabel: 'Placeholder',
    isPlaceholder: true,
  ),
];

/// Projects section with a horizontal parallax carousel.
class ProjectsSection extends StatefulWidget {
  /// Creates the projects section.
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: DkSectionHeader(
              title: 'Projects',
              subtitle: 'My Work',
              showDivider: true,
            ),
          ),
          const SizedBox(height: 40),
          // Parallax Carousel
          // Parallax Carousel
          Align(
            alignment: Alignment.centerLeft,
            child: RepaintBoundary(
              child: SizedBox(
                height: 450,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                    },
                  ),
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _projects.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 32),
                    itemBuilder: (context, index) {
                      final screenWidth = MediaQuery.sizeOf(context).width;
                      // Max width of 600 for cards so they don't stretch in ultrawide
                      final cardWidth =
                          screenWidth > 800 ? 550.0 : screenWidth * 0.85;

                      return SizedBox(
                        width: cardWidth,
                        child: RepaintBoundary(
                          child: _ParallaxProjectCard(
                            project: _projects[index],
                            scrollController: _scrollController,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParallaxProjectCard extends StatefulWidget {
  const _ParallaxProjectCard({
    required this.project,
    required this.scrollController,
  });

  final _Project project;
  final ScrollController scrollController;

  @override
  State<_ParallaxProjectCard> createState() => _ParallaxProjectCardState();
}

class _ParallaxProjectCardState extends State<_ParallaxProjectCard> {
  bool _hovered = false;
  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (widget.project.isPlaceholder) {
      return _buildSkeleton(context);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        key: _cardKey,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _hovered ? 1.02 : 1.0,
          _hovered ? 1.02 : 1.0,
          1.0,
        ),
        transformAlignment: Alignment.center,
        child: AnimatedBuilder(
          animation: widget.scrollController,
          builder: (context, child) {
            double alignmentX = 0.0;

            if (widget.scrollController.hasClients &&
                _cardKey.currentContext != null) {
              final renderBox =
                  _cardKey.currentContext!.findRenderObject() as RenderBox?;
              if (renderBox != null) {
                final offset = renderBox.localToGlobal(Offset.zero);
                final screenWidth = MediaQuery.sizeOf(context).width;

                // Calculate center of the card relative to the screen
                final cardCenter = offset.dx + renderBox.size.width / 2;

                // Normalize from -1 to 1 where 0 is center of screen
                final difference =
                    (cardCenter - screenWidth / 2) / (screenWidth / 2);

                // Lógica: Conforme o card se move de -1 a 1 na tela, o Alignment.x vai de -0.5 a 0.5.
                alignmentX = (difference * 0.5).clamp(-1.0, 1.0);
              }
            }

            return DkProjectCard(
              heroImage: NetworkImage(widget.project.imageUrl),
              imageSemanticLabel: widget.project.imageLabel,
              imageAlignment: Alignment(alignmentX, 0),
              title: widget.project.title,
              subtitle: widget.project.subtitle,
              description: widget.project.description,
              tags: widget.project.tags.map((t) => DkTag(label: t)).toList(),
              callToAction: DkButton.outlined(label: const Text('Case Study')),
              onPressed: () {
                DkSnackbar.show(
                  context: context,
                  message: '📂 Opening ${widget.project.title}…',
                  variant: DkSnackbarVariant.info,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOutSine,
      builder: (context, val, _) {
        final shimmerColor = theme.colorScheme.surfaceContainerHighest
            .withAlpha((val * 100).round());
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: theme.colorScheme.outlineVariant.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image skeleton
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 24, width: 150, color: shimmerColor),
                    const SizedBox(height: 12),
                    Container(height: 16, width: 100, color: shimmerColor),
                    const SizedBox(height: 24),
                    Container(
                        height: 16,
                        width: double.infinity,
                        color: shimmerColor),
                    const SizedBox(height: 8),
                    Container(
                        height: 16,
                        width: double.infinity,
                        color: shimmerColor),
                    const SizedBox(height: 8),
                    Container(height: 16, width: 200, color: shimmerColor),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      onEnd: () {
        // Reverse animation trick in stateful widgets requires more logic,
        // for simplicity we use a looping approach or just a slow one-way that looks good.
        // In a real scenario we could use an AnimationController on repeat.
      },
    );
  }
}

final class _Project {
  const _Project({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
    required this.imageLabel,
    this.isPlaceholder = false,
  });

  final String imageUrl;
  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final String imageLabel;
  final bool isPlaceholder;
}
