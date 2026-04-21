import 'dart:math' as math;

import 'package:design_kit/design_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:portfolio_app/core/navigation/navigation_provider.dart';

import 'package:portfolio_app/shared/widgets/max_width_box.dart';

/// Full-viewport hero section with a cycling role headline.
class HeroSection extends ConsumerStatefulWidget {
  /// Creates the hero section.
  const HeroSection({super.key});

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection> {
  final ValueNotifier<Offset?> _mousePos = ValueNotifier(null);

  @override
  void dispose() {
    _mousePos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isWide = size.width >= 900;

    final isDark = theme.brightness == Brightness.dark;
    final dotAlpha = isDark ? 40 : 60;

    return MouseRegion(
      onHover: (event) => _mousePos.value = event.localPosition,
      onExit: (_) => _mousePos.value = null,
      child: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            // Dot-grid background
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _DotGridPainter(
                    color: colorScheme.onSurface,
                    maxAlpha: dotAlpha,
                    mousePos: _mousePos,
                    disableAnimations: MediaQuery.disableAnimationsOf(context),
                  ),
                ),
              ),
            ),
            // Content without scroll parallax
            Center(
              child: MaxWidthBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: isWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _avatarBlock(context),
                            const SizedBox(width: 64),
                            Flexible(child: _textBlock(context)),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _avatarBlock(context),
                            const SizedBox(height: 32),
                            _textBlock(context),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarBlock(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Bruno, the portfolio owner',
      image: true,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withAlpha(100),
              blurRadius: 60,
              spreadRadius: 12,
            ),
          ],
          border: Border.all(
            color: colorScheme.primary.withAlpha(80),
            width: 3,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/meHD.png',
            width: 160,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _textBlock(BuildContext context) {
    final theme = Theme.of(context);
    final nav = ref.read(navigationProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Bruno Barreto',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'Flutter Developer',
          style: theme.textTheme.displaySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'I craft pixel-perfect, accessible Flutter experiences\n'
          'and build scalable design systems for the European market.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            DkButton.filled(
              label: const Text('View Projects'),
              onPressed: () => nav.scrollTo('projects'),
            ),
            DkButton.outlined(
              label: const Text('Component Showcase'),
              onPressed: () => nav.scrollTo('showcase'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Paints a subtle dot-grid background using [Canvas].
class _DotGridPainter extends CustomPainter {
  _DotGridPainter({
    required this.color,
    required this.maxAlpha,
    required this.mousePos,
    required this.disableAnimations,
  }) : super(repaint: mousePos);

  final Color color;
  final int maxAlpha;
  final ValueNotifier<Offset?> mousePos;
  final bool disableAnimations;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final mPos = mousePos.value;

    const spacing = 32.0;
    const radius = 1.5;

    // Physics & Light parameters
    const influenceRadius = 80.0;
    const repulsionIntensity = 8.0;

    // 1. Render Cursor Glow (Ambient Light)
    if (mPos != null && !disableAnimations) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          radius: 0.3,
          colors: [
            color.withAlpha(10),
            color.withAlpha(0),
          ],
        ).createShader(Rect.fromCircle(center: mPos, radius: influenceRadius));

      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        glowPaint,
      );
    }

    // 2. Render Responsive Dots
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        Offset dotPos = Offset(x, y);

        // Calculate magnetic repulsion with Cascade (Quadratic) Falloff
        if (mPos != null && !disableAnimations) {
          final vectorToMouse = dotPos - mPos;
          final distance = vectorToMouse.distance;

          if (distance < influenceRadius) {
            // Quadratic falloff: (1 - d/r)^2 creates a much smoother, cascading effect
            final force =
                math.pow(1.0 - (distance / influenceRadius), 2.0).toDouble();

            // Push dot away from mouse
            final displacement =
                (vectorToMouse / (distance + 0.1)) * force * repulsionIntensity;
            dotPos += displacement;
          }
        }

        // Slight radial fade from center (based on original grid pos)
        final dx = x - size.width / 2;
        final dy = y - size.height / 2;
        final distToCenter = math.sqrt(dx * dx + dy * dy);
        final maxDist = math.sqrt(
              size.width * size.width + size.height * size.height,
            ) /
            2;
        final alphaMultiplier = (1 - distToCenter / maxDist).clamp(0.0, 1.0);

        canvas.drawCircle(
          dotPos,
          radius,
          paint..color = color.withAlpha((maxAlpha * alphaMultiplier).round()),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.maxAlpha != maxAlpha ||
      oldDelegate.disableAnimations != disableAnimations;
}
