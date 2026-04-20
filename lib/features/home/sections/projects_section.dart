import 'package:design_kit/design_kit.dart';
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
];

/// Projects section with responsive DkGrid of DkProjectCard widgets.
class ProjectsSection extends StatelessWidget {
  /// Creates the projects section.
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DkSectionHeader(
            title: 'Projects',
            subtitle: 'My Work',
            showDivider: true,
            trailingAction: DkButton.text(label: const Text('View All')),
          ),
          const SizedBox(height: 40),
          DkGrid(
            children:
                _projects.map((p) => _HoverProjectCard(project: p)).toList(),
          ),
        ],
      ),
    );
  }
}

class _HoverProjectCard extends StatefulWidget {
  const _HoverProjectCard({required this.project});
  final _Project project;

  @override
  State<_HoverProjectCard> createState() => _HoverProjectCardState();
}

class _HoverProjectCardState extends State<_HoverProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _hovered ? 1.02 : 1.0,
          _hovered ? 1.02 : 1.0,
          1.0,
        ),
        transformAlignment: Alignment.center,
        child: DkProjectCard(
          heroImage: NetworkImage(widget.project.imageUrl),
          imageSemanticLabel: widget.project.imageLabel,
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
        ),
      ),
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
  });

  final String imageUrl;
  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final String imageLabel;
}
