/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/auth-header.png
  AssetGenImage get authHeader =>
      const AssetGenImage('assets/images/auth-header.png');

  /// File path: assets/images/bw-splash.png
  AssetGenImage get bwSplash =>
      const AssetGenImage('assets/images/bw-splash.png');

  /// File path: assets/images/custom-logo.png
  AssetGenImage get customLogo =>
      const AssetGenImage('assets/images/custom-logo.png');

  /// File path: assets/images/forward-icon.png
  AssetGenImage get forwardIcon =>
      const AssetGenImage('assets/images/forward-icon.png');

  /// File path: assets/images/gua-tempurung.jpg
  AssetGenImage get guaTempurung =>
      const AssetGenImage('assets/images/gua-tempurung.jpg');

  /// File path: assets/images/kfc.jpg
  AssetGenImage get kfc => const AssetGenImage('assets/images/kfc.jpg');

  /// File path: assets/images/nasi-lemak.jpg
  AssetGenImage get nasiLemak =>
      const AssetGenImage('assets/images/nasi-lemak.jpg');

  /// File path: assets/images/onBoarding1.png
  AssetGenImage get onBoarding1 =>
      const AssetGenImage('assets/images/onBoarding1.png');

  /// File path: assets/images/onBoarding2.png
  AssetGenImage get onBoarding2 =>
      const AssetGenImage('assets/images/onBoarding2.png');

  /// File path: assets/images/onBoarding3.png
  AssetGenImage get onBoarding3 =>
      const AssetGenImage('assets/images/onBoarding3.png');

  /// File path: assets/images/people.png
  AssetGenImage get people => const AssetGenImage('assets/images/people.png');

  /// File path: assets/images/splash-shape.png
  AssetGenImage get splashShape =>
      const AssetGenImage('assets/images/splash-shape.png');

  /// File path: assets/images/travel-logo.png
  AssetGenImage get travelLogo =>
      const AssetGenImage('assets/images/travel-logo.png');

  /// File path: assets/images/user-default.jpg
  AssetGenImage get userDefault =>
      const AssetGenImage('assets/images/user-default.jpg');

  /// File path: assets/images/welcome-logo.png
  AssetGenImage get welcomeLogo =>
      const AssetGenImage('assets/images/welcome-logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        authHeader,
        bwSplash,
        customLogo,
        forwardIcon,
        guaTempurung,
        kfc,
        nasiLemak,
        onBoarding1,
        onBoarding2,
        onBoarding3,
        people,
        splashShape,
        travelLogo,
        userDefault,
        welcomeLogo
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
