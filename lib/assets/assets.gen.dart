/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************
import 'package:flutter/widgets.dart';

class $LibGen {
  const $LibGen();

  /// File path: lib/shop.png
  AssetGenImage get shop => const AssetGenImage('lib/shop.png');

  /// List of all assets
  List<AssetGenImage> get values => [shop];
}

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/burger.png
  AssetGenImage get burger => const AssetGenImage('assets/png/burger.png');

  /// File path: assets/png/detergent.png
  AssetGenImage get detergent =>
      const AssetGenImage('assets/png/detergent.png');

  /// File path: assets/png/donut.png
  AssetGenImage get donut => const AssetGenImage('assets/png/donut.png');

  /// File path: assets/png/groceries.png
  AssetGenImage get groceries =>
      const AssetGenImage('assets/png/groceries.png');

  /// File path: assets/png/ham.png
  AssetGenImage get ham => const AssetGenImage('assets/png/ham.png');

  /// File path: assets/png/heartbeat.png
  AssetGenImage get heartbeat =>
      const AssetGenImage('assets/png/heartbeat.png');

  /// File path: assets/png/ice.png
  AssetGenImage get ice => const AssetGenImage('assets/png/ice.png');

  /// File path: assets/png/ladybug.png
  AssetGenImage get ladybug => const AssetGenImage('assets/png/ladybug.png');

  /// File path: assets/png/ramen.png
  AssetGenImage get ramen => const AssetGenImage('assets/png/ramen.png');

  /// File path: assets/png/shopping-bag.png
  AssetGenImage get shoppingBag =>
      const AssetGenImage('assets/png/shopping-bag.png');

  /// File path: assets/png/soft-drink.png
  AssetGenImage get softDrink =>
      const AssetGenImage('assets/png/soft-drink.png');

  /// File path: assets/png/toothbrush.png
  AssetGenImage get toothbrush =>
      const AssetGenImage('assets/png/toothbrush.png');

  /// File path: assets/png/vegetable.png
  AssetGenImage get vegetable =>
      const AssetGenImage('assets/png/vegetable.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        burger,
        detergent,
        donut,
        groceries,
        ham,
        heartbeat,
        ice,
        ladybug,
        ramen,
        shoppingBag,
        softDrink,
        toothbrush,
        vegetable
      ];
}

class Assets {
  Assets._();

  static const $AssetsPngGen png = $AssetsPngGen();
  static const $LibGen lib = $LibGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

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
    bool gaplessPlayback = false,
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

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
