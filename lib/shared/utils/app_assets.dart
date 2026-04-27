/// [AppAssets] provides a centralized access point for all image assets.
/// Using a class instead of hardcoded strings prevents typos and simplifies
/// maintenance.
abstract final class AppAssets {
  static const String _basePath = 'assets/images';

  /// Profile picture used in Hero section and Shell.
  static const String meHD = '$_basePath/meHD.webp';

  /// Profile picture with a smile used in the About section.
  static const String meSmiling = '$_basePath/meSmiling.webp';

  /// Project thumbnail for the Design Kit.
  static const String designKitThumbnail = '$_basePath/design_kit_sml.webp';

  /// Project thumbnail for the Portfolio App.
  static const String portfolioThumbnail = '$_basePath/portfolio.webp';

  /// Project thumbnail for the Dev Tools.
  static const String devToolsThumbnail = '$_basePath/dev_tools.webp';

  /// Fav icon.
  static const String favicon = '$_basePath/favicon.webp';
}
