import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_app/features/home/sections/about_section.dart';
import 'package:design_kit/design_kit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('AboutSection renders with improved layout and icons', (tester) async {
    // Set screen size to desktop to ensure 3-column grid
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: AboutSection(),
          ),
        ),
      ),
    );

    // Verify Tech Stack icons are present
    expect(find.byType(DkTag), findsAtLeast(10));
    expect(find.descendant(
      of: find.byType(DkTag),
      matching: find.byType(Icon),
    ), findsAtLeast(6));

    expect(find.descendant(
      of: find.byType(DkTag),
      matching: find.byType(SvgPicture),
    ), findsAtLeast(4));

    // Verify Stat Cards are centered
    final statLabel = find.text('Years of Experience');
    final textWidget = tester.widget<Text>(statLabel);
    expect(textWidget.textAlign, TextAlign.center);

    // Reset view
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
