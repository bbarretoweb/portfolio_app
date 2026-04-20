import 'package:flutter/material.dart';

/// Constrains its [child] to [maxWidth] and centres it horizontally.
///
/// Ensures a comfortable reading width on ultra-wide displays without
/// hard-coding padding into every section.
class MaxWidthBox extends StatelessWidget {
  /// Creates a centred maxWidth constraint box.
  const MaxWidthBox({
    required this.child,
    this.maxWidth = 1200,
    super.key,
  });

  /// The widget to constrain.
  final Widget child;

  /// Maximum logical pixel width. Defaults to 1200px.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
