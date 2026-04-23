import 'dart:ui';
import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_app/shared/utils/app_assets.dart';
import 'package:portfolio_app/shared/utils/brand_icons.dart';
import 'package:portfolio_app/shared/widgets/max_width_box.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// About section: bio, tech-stack tags, and horizontal divider.
class AboutSection extends StatefulWidget {
  /// Creates the about section.
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  bool _isVisible = false;

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_isVisible && info.visibleFraction > 0.2) {
      if (mounted) setState(() => _isVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VisibilityDetector(
      key: const Key('about-section-visibility'),
      onVisibilityChanged: _onVisibilityChanged,
      child: MaxWidthBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DkSectionHeader(
                title: 'About Me',
                subtitle: 'Who I am',
              ),
              const SizedBox(height: 40),
              DkGrid(
                children: [
                  // Pop-out Image
                  Align(
                    alignment: Alignment.topCenter,
                    child: _ProfileAvatar(isVisible: _isVisible),
                  ),
                  // Bio card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withAlpha(80),
                      borderRadius:
                          Theme.of(context).extension<DkRadii>()?.lg ??
                              BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Flutter Developer with 6 years of expertise, specialized'
                      ' in high-quality mobile & web solutions. Experienced '
                      'electric mobility, container terminals and public '
                      'sector systems.\n\n'
                      'I architect clean, scalable cross-platform apps with '
                      'explicit dependency injection, delivering premium '
                      'interfaces that create real value for complex '
                      'operations.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  // Stat cards
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _AnimatedStatCard(
                        label: 'Years of Experience',
                        targetValue: 6,
                        suffix: '+',
                        isVisible: _isVisible,
                      ),
                      const SizedBox(height: 16),
                      _AnimatedStatCard(
                        label: 'API Integrations',
                        targetValue: 5,
                        suffix: '+',
                        isVisible: _isVisible,
                      ),
                      const SizedBox(height: 16),
                      _AnimatedStatCard(
                        label: 'UI Components',
                        targetValue: 40,
                        suffix: '+',
                        isVisible: _isVisible,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 64),
              const DkDivider(
                label: Text('Tech Stack'),
                indent: 0,
                endIndent: 0,
              ),
              const SizedBox(height: 32),
              Center(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    DkTag(
                      label: 'Flutter',
                      icon: SvgPicture.string(
                        BrandIcons.flutter,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onPrimaryContainer,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    DkTag(
                      label: 'Dart 3+',
                      icon: SvgPicture.string(
                        BrandIcons.dart,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onPrimaryContainer,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const DkTag(
                      label: 'Riverpod',
                      icon: Icon(Icons.water_drop_rounded, size: 16),
                    ),
                    const DkTag(
                      label: 'go_router',
                      icon: Icon(Icons.alt_route_rounded, size: 16),
                    ),
                    const DkTag(
                      label: 'WCAG 2.1 AA',
                      icon: Icon(Icons.accessibility_new_rounded, size: 16),
                    ),
                    const DkTag(
                      label: 'CI/CD',
                      icon: Icon(Icons.loop_rounded, size: 16),
                    ),
                    DkTag(
                      label: 'Firebase',
                      icon: SvgPicture.string(
                        BrandIcons.firebase,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onPrimaryContainer,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    DkTag(
                      label: 'REST / GraphQL',
                      icon: SvgPicture.string(
                        BrandIcons.graphql,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          theme.colorScheme.onPrimaryContainer,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const DkTag(
                      label: 'Design Systems',
                      icon: Icon(Icons.category_rounded, size: 16),
                    ),
                    const DkTag(
                      label: 'Unit & Golden Tests',
                      icon: Icon(Icons.fact_check_rounded, size: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedStatCard extends StatefulWidget {
  const _AnimatedStatCard({
    required this.label,
    required this.targetValue,
    required this.suffix,
    required this.isVisible,
  });

  final String label;
  final int targetValue;
  final String suffix;
  final bool isVisible;

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard> {
  final ValueNotifier<Offset?> _mousePos = ValueNotifier(null);

  @override
  void dispose() {
    _mousePos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return MouseRegion(
      onHover: (e) => _mousePos.value = e.localPosition,
      onExit: (_) => _mousePos.value = null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ValueListenableBuilder<Offset?>(
          valueListenable: _mousePos,
          builder: (context, mousePos, child) {
            return Stack(
              children: [
                // Base background
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withAlpha(60),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary.withAlpha(40),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Number Ticker
                      TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0,
                          end: widget.isVisible
                              ? widget.targetValue.toDouble()
                              : 0,
                        ),
                        duration: disableAnimations
                            ? Duration.zero
                            : const Duration(seconds: 2),
                        curve: Curves.easeOutExpo,
                        builder: (context, val, _) {
                          return Text(
                            '${val.toInt()}${widget.suffix}',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.label,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Glossy Hover Effect
                if (mousePos != null && !disableAnimations)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _GlossyPainter(
                        mousePos: mousePos,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GlossyPainter extends CustomPainter {
  _GlossyPainter({required this.mousePos, required this.color});

  final Offset mousePos;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        radius: 0.8,
        colors: [
          color.withAlpha(40),
          color.withAlpha(0),
        ],
      ).createShader(Rect.fromCircle(center: mousePos, radius: 100));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_GlossyPainter oldDelegate) =>
      oldDelegate.mousePos != mousePos || oldDelegate.color != color;
}

class _ProfileAvatar extends StatefulWidget {
  const _ProfileAvatar({required this.isVisible});
  final bool isVisible;

  @override
  State<_ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<_ProfileAvatar> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    // Color matrix for grayscale
    const grayscaleMatrix = <double>[
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];

    // Identity matrix (full color)
    const colorMatrix = <double>[
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];

    final showColor = widget.isVisible || _isHovering;

    return Semantics(
      label: 'Bruno, the portfolio owner',
      image: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: widget.isVisible ? 1.0 : 0.0),
          duration: disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 1000),
          curve: Curves.easeOutBack,
          builder: (context, val, child) {
            final sigma = disableAnimations ? 0.0 : 10.0 * (1.0 - val);
            final blurred = sigma > 0.001
                ? ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: sigma,
                      sigmaY: sigma,
                      tileMode: TileMode.decal,
                    ),
                    child: child,
                  )
                : child!;

            return Opacity(
              opacity: val.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 0.8 + (0.2 * val),
                child: blurred,
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: TweenAnimationBuilder<List<double>>(
              tween: ColorMatrixTween(
                begin: grayscaleMatrix,
                end: showColor ? colorMatrix : grayscaleMatrix,
              ),
              duration: const Duration(seconds: 5),
              builder: (context, matrix, child) {
                return ColorFiltered(
                  colorFilter: ColorFilter.matrix(matrix),
                  child: const Image(
                    image: ResizeImage(
                      AssetImage(AppAssets.meSmiling),
                      width: 800,
                    ),
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// A tween for interpolating between two color matrix lists.
class ColorMatrixTween extends Tween<List<double>> {
  /// Creates a [ColorMatrixTween].
  ColorMatrixTween({required super.begin, required super.end});

  @override
  List<double> lerp(double t) {
    return List<double>.generate(begin!.length, (i) {
      return lerpDouble(begin![i], end![i], t) ?? begin![i];
    });
  }
}
