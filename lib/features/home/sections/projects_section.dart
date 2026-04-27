import 'package:design_kit/design_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/shared/utils/app_assets.dart';
import 'package:url_launcher/url_launcher.dart';

const _projects = [
  _Project(
    image: ResizeImage(
      AssetImage(AppAssets.designKitThumbnail),
      width: 1100,
    ),
    title: 'Design kit',
    subtitle: 'Component Library',
    description:
        'A fully accessible, brand-agnostic Flutter design system built to EAA / WCAG 2.1 AA standards. '
        'Implements inversion of control for all theme and asset injection.',
    tags: ['Web', 'Mobile', 'Desktop', 'Material 3', ' WCAG 2.1 AA'],
    imageLabel: 'Screenshot of the design_kit component showcase',
    url: 'https://github.com/bbarretoweb/design_kit',
  ),
  _Project(
    image: ResizeImage(
      AssetImage(AppAssets.portfolioThumbnail),
      width: 1100,
    ),
    title: 'Portfolio App',
    subtitle: 'This very app',
    description:
        'A modern Flutter portfolio with live brand and brightness switching, '
        'fluid scroll animations, and a full component showcase — built '
        'on design_kit.',
    tags: ['go_router', 'flutter_riverpod', 'design_kit', 'GitHub CI/CD'],
    imageLabel: 'Portfolio app hero screenshot',
    url: 'https://github.com/bbarretoweb/portfolio_app',
  ),
  _Project(
    image: ResizeImage(
      AssetImage(AppAssets.devToolsThumbnail),
      width: 1100,
    ),
    title: 'My Dev Tools',
    subtitle: 'Set of tools for developers',
    description: 'A helpful set of tools for developers',
    tags: ['python', 'image optimization'],
    imageLabel: 'Placeholder for dev tools screenshot',
    url: 'https://github.com/bbarretoweb/my-dev-tools',
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: DkSectionHeader(
              title: 'Projects',
              subtitle: 'My Work',
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
                      // Max width of 600 for cards so they don't stretch in
                      // ultrawide
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
          1,
        ),
        transformAlignment: Alignment.center,
        child: AnimatedBuilder(
          animation: widget.scrollController,
          builder: (context, child) {
            double alignmentX = 0;

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

                // Lógica: Conforme o card se move de -1 a 1 na tela, o
                // Alignment.x vai de -0.5 a 0.5.
                alignmentX = (difference * 0.5).clamp(-1, 1);
              }
            }

            return DkProjectCard(
              heroImage: widget.project.image,
              imageSemanticLabel: widget.project.imageLabel,
              imageAlignment: Alignment(alignmentX, 0),
              title: widget.project.title,
              subtitle: widget.project.subtitle,
              description: widget.project.description,
              tags: widget.project.tags.map((t) => DkTag(label: t)).toList(),
              // callToAction: DkButton.outlined(
              //   label: const Text('Case Study'),
              // ),
              onPressed: () async {
                final uri = Uri.parse(widget.project.url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
            );
          },
        ),
      ),
    );
  }
}

final class _Project {
  const _Project({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
    required this.imageLabel,
    required this.url,
  });

  final ImageProvider<Object> image;
  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final String imageLabel;
  final String url;
}
