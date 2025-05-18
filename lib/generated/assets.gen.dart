/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart' as _lottie;

class $AssetsAnimationsGen {
  const $AssetsAnimationsGen();

  /// File path: assets/animations/disclaimer_animation.json
  LottieGenImage get disclaimerAnimation =>
      const LottieGenImage('assets/animations/disclaimer_animation.json');

  /// Directory path: packages/go_perak/assets/animations
  String get path => 'packages/go_perak/assets/animations';

  /// List of all assets
  List<LottieGenImage> get values => [disclaimerAnimation];
}

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

  /// File path: assets/images/dot.png
  AssetGenImage get dot => const AssetGenImage('assets/images/dot.png');

  /// File path: assets/images/fake-map.jpg
  AssetGenImage get fakeMap =>
      const AssetGenImage('assets/images/fake-map.jpg');

  /// File path: assets/images/filled-dot.png
  AssetGenImage get filledDot =>
      const AssetGenImage('assets/images/filled-dot.png');

  /// File path: assets/images/forward-icon.png
  AssetGenImage get forwardIcon =>
      const AssetGenImage('assets/images/forward-icon.png');

  /// File path: assets/images/gua-tempurung.jpg
  AssetGenImage get guaTempurung =>
      const AssetGenImage('assets/images/gua-tempurung.jpg');

  /// File path: assets/images/ipoh.jpg
  AssetGenImage get ipoh => const AssetGenImage('assets/images/ipoh.jpg');

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

  /// File path: assets/images/scam.png
  AssetGenImage get scam => const AssetGenImage('assets/images/scam.png');

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

  /// Directory path: packages/go_perak/assets/images
  String get path => 'packages/go_perak/assets/images';

  /// List of all assets
  List<AssetGenImage> get values => [
    authHeader,
    bwSplash,
    customLogo,
    dot,
    fakeMap,
    filledDot,
    forwardIcon,
    guaTempurung,
    ipoh,
    kfc,
    nasiLemak,
    onBoarding1,
    onBoarding2,
    onBoarding3,
    people,
    scam,
    splashShape,
    travelLogo,
    userDefault,
    welcomeLogo,
  ];
}

class Assets {
  const Assets._();

  static const String package = 'go_perak';

  static const $AssetsAnimationsGen animations = $AssetsAnimationsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  static const String package = 'go_perak';

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
    @Deprecated('Do not specify package for a generated library asset')
    String? package = package,
    FilterQuality filterQuality = FilterQuality.medium,
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
    @Deprecated('Do not specify package for a generated library asset')
    String? package = package,
  }) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => 'packages/go_perak/$_assetName';
}

class LottieGenImage {
  const LottieGenImage(this._assetName, {this.flavors = const {}});

  final String _assetName;
  final Set<String> flavors;

  static const String package = 'go_perak';

  _lottie.LottieBuilder lottie({
    Animation<double>? controller,
    bool? animate,
    _lottie.FrameRate? frameRate,
    bool? repeat,
    bool? reverse,
    _lottie.LottieDelegates? delegates,
    _lottie.LottieOptions? options,
    void Function(_lottie.LottieComposition)? onLoaded,
    _lottie.LottieImageProviderFactory? imageProviderFactory,
    Key? key,
    AssetBundle? bundle,
    Widget Function(BuildContext, Widget, _lottie.LottieComposition?)?
    frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    @Deprecated('Do not specify package for a generated library asset')
    String? package = package,
    bool? addRepaintBoundary,
    FilterQuality? filterQuality,
    void Function(String)? onWarning,
    _lottie.LottieDecoder? decoder,
    _lottie.RenderCache? renderCache,
    bool? backgroundLoading,
  }) {
    return _lottie.Lottie.asset(
      _assetName,
      controller: controller,
      animate: animate,
      frameRate: frameRate,
      repeat: repeat,
      reverse: reverse,
      delegates: delegates,
      options: options,
      onLoaded: onLoaded,
      imageProviderFactory: imageProviderFactory,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      package: package,
      addRepaintBoundary: addRepaintBoundary,
      filterQuality: filterQuality,
      onWarning: onWarning,
      decoder: decoder,
      renderCache: renderCache,
      backgroundLoading: backgroundLoading,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/go_perak/$_assetName';
}
