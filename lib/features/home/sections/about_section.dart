import 'dart:ui';
import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
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
                showDivider: true,
              ),
              const SizedBox(height: 40),
              DkGrid(
                children: [
                  // Pop-out Image
                  Align(
                    alignment: Alignment.center,
                    child: _PopOutAvatar(isVisible: _isVisible),
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
                      'Senior Flutter Engineer based in Europe, specialized in '
                      'design systems, performance optimization, and accessible '
                      'mobile experiences.\n\n'
                      'I build components that adhere to EAA / WCAG 2.1 AA '
                      'standards, architect clean packages with explicit dependency '
                      'injection, and obsess over the details that make an interface '
                      'feel truly premium.',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  // Stat cards
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AnimatedStatCard(
                        label: 'Years of Experience',
                        targetValue: 6,
                        suffix: '+',
                        isVisible: _isVisible,
                      ),
                      const SizedBox(height: 16),
                      _AnimatedStatCard(
                        label: 'Apps Shipped',
                        targetValue: 20,
                        suffix: '+',
                        isVisible: _isVisible,
                      ),
                      const SizedBox(height: 16),
                      _AnimatedStatCard(
                        label: 'Design Systems Built',
                        targetValue: 4,
                        suffix: '',
                        isVisible: _isVisible,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const DkDivider(label: Text('Tech Stack')),
              const SizedBox(height: 24),
              const Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  DkTag(label: 'Flutter'),
                  DkTag(label: 'Dart 3+'),
                  DkTag(label: 'Riverpod'),
                  DkTag(label: 'go_router'),
                  DkTag(label: 'WCAG 2.1 AA'),
                  DkTag(label: 'CI/CD'),
                  DkTag(label: 'Firebase'),
                  DkTag(label: 'REST / GraphQL'),
                  DkTag(label: 'Design Systems'),
                  DkTag(label: 'Unit & Golden Tests'),
                ],
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
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withAlpha(60),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.primary.withAlpha(40),
                    ),
                  ),
                  child: Row(
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
                          return SizedBox(
                            width: 60,
                            child: Text(
                              '${val.toInt()}${widget.suffix}',
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(widget.label,
                            style: theme.textTheme.bodyMedium),
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
        center: Alignment.center,
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

class _PopOutAvatar extends StatefulWidget {
  const _PopOutAvatar({required this.isVisible});
  final bool isVisible;

  @override
  State<_PopOutAvatar> createState() => _PopOutAvatarState();
}

class _PopOutAvatarState extends State<_PopOutAvatar> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final theme = Theme.of(context);

    // Color matrix for grayscale
    const List<double> grayscaleMatrix = <double>[
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
    const List<double> colorMatrix = <double>[
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
          tween: Tween(begin: 0.0, end: widget.isVisible ? 1.0 : 0.0),
          duration: disableAnimations
              ? Duration.zero
              : const Duration(milliseconds: 1000),
          curve: Curves.easeOutBack,
          builder: (context, val, child) {
            return Opacity(
              opacity: val.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 0.8 + (0.2 * val),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: disableAnimations ? 0 : 10 * (1 - val),
                    sigmaY: disableAnimations ? 0 : 10 * (1 - val),
                  ),
                  child: child,
                ),
              ),
            );
          },
          child: SizedBox(
            width: 250,
            height: 300,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                // Background Frame (Circle)
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primaryContainer.withAlpha(50),
                    border: Border.all(
                      color: theme.colorScheme.primary.withAlpha(40),
                      width: 2,
                    ),
                  ),
                ),
                // Overflowing image (Pop-out effect)
                Positioned(
                  bottom: 0,
                  child: TweenAnimationBuilder<List<double>>(
                    tween: ColorMatrixTween(
                      begin: grayscaleMatrix,
                      end: showColor ? colorMatrix : grayscaleMatrix,
                    ),
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, matrix, child) {
                      return ColorFiltered(
                        colorFilter: ColorFilter.matrix(matrix),
                        child: Image.asset(
                          'assets/images/meSmiling.jpg',
                          height: 320,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.medium,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColorMatrixTween extends Tween<List<double>> {
  ColorMatrixTween({required super.begin, required super.end});

  @override
  List<double> lerp(double t) {
    return List<double>.generate(begin!.length, (i) {
      return lerpDouble(begin![i], end![i], t) ?? begin![i];
    });
  }
}
