import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_app/core/navigation/navigation_provider.dart';
import 'package:portfolio_app/features/home/sections/about_section.dart';
import 'package:portfolio_app/features/home/sections/component_showcase_section.dart';
import 'package:portfolio_app/features/home/sections/contact_section.dart';
import 'package:portfolio_app/features/home/sections/hero_section.dart';
import 'package:portfolio_app/features/home/sections/projects_section.dart';
import 'package:portfolio_app/features/home/sections/themeshow_section.dart';
import 'package:portfolio_app/shared/widgets/animated_section.dart';

/// The single-page scrolling portfolio home.
class HomePage extends ConsumerStatefulWidget {
  /// Creates the home page.
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late ScrollController _scrollController;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  void _scrollListener() {
    final offset = _scrollController.offset;

    if (offset > 400 && !_showBackToTop) {
      setState(() => _showBackToTop = true);
    } else if (offset <= 400 && _showBackToTop) {
      setState(() => _showBackToTop = false);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final nav = ref.read(navigationProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: AnimatedSection(
                  key: nav.getKey('hero'),
                  sectionKey: 'hero',
                  child: const HeroSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSection(
                  key: nav.getKey('about'),
                  sectionKey: 'about',
                  delay: const Duration(milliseconds: 100),
                  child: const AboutSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSection(
                  key: nav.getKey('projects'),
                  sectionKey: 'projects',
                  delay: const Duration(milliseconds: 100),
                  child: const ProjectsSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSection(
                  key: nav.getKey('themeshow'),
                  sectionKey: 'themeshow',
                  delay: const Duration(milliseconds: 100),
                  child: const ThemeshowSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSection(
                  key: nav.getKey('showcase'),
                  sectionKey: 'showcase',
                  delay: const Duration(milliseconds: 100),
                  child: const ComponentShowcaseSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSection(
                  key: nav.getKey('contact'),
                  sectionKey: 'contact',
                  delay: const Duration(milliseconds: 100),
                  child: const ContactSection(),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 32,
            right: 32,
            child: AnimatedScale(
              scale: _showBackToTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                opacity: _showBackToTop ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: DkGlassIconButton(
                  icon: const Icon(Icons.keyboard_arrow_up_rounded),
                  onPressed: _scrollToTop,
                  tooltip: 'Back to top',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
