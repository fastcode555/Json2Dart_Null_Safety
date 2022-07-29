import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gesound/common/config/image_loader_config.dart';
import 'package:gesound/res/index.dart';

class AppImageConfig extends ImageLoaderConfigInterface {
  @override
  LoadingErrorWidgetBuilder getErrorBuilder(double? width, double? height, double? border, Color? borderColor) {
    double? _width = (width ?? 0) > (height ?? 0) ? height : width;
    _width = ((_width ?? 0) / 3.0);
    _width = _width == 0 ? null : _width;
    return (BuildContext context, String url, _) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: border == null || border == 0.0
              ? null
              : Border.all(color: borderColor ?? Colors.transparent, width: border),
          color: Colours.ff1e5d5d,
        ),
        alignment: Alignment.center,
        child: SizedBox(
          width: _width ?? 60,
          height: _width ?? 60,
          child: const PinSvg(R.icDefaultMusic),
        ),
      );
    };
  }

  @override
  PlaceholderWidgetBuilder getPlaceBuilder(double? width, double? height, double? border, Color? borderColor) {
    double? _width = (width ?? 0) > (height ?? 0) ? height : width;
    _width = ((_width ?? 0) / 3.0);
    _width = _width == 0 ? null : _width;
    return (BuildContext context, String url) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: border == null || border == 0.0
              ? null
              : Border.all(color: borderColor ?? Colors.transparent, width: border),
          color: Colours.ff1e5d5d,
        ),
        alignment: Alignment.center,
        child: SizedBox(
          width: _width ?? 60,
          height: _width ?? 60,
          child: const PinSvg(R.icDefaultMusic),
        ),
      );
    };
  }

  @override
  getCircleErrorBuilder(double? radius, double? border, Color? borderColor) {
    double? _width = radius == null ? null : radius * 2 / 2.0;
    return (BuildContext context, String url, _) {
      return ClipOval(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: border == null || border == 0.0
                ? null
                : Border.all(color: borderColor ?? Colors.transparent, width: border),
            color: Colours.ff1e5d5d,
          ),
          width: radius! * 2,
          height: radius * 2,
          alignment: Alignment.center,
          child: SizedBox(
            width: _width ?? 60,
            height: _width ?? 60,
            child: const PinSvg(R.icDefaultMusic),
          ),
        ),
      );
    };
  }

  @override
  PlaceholderWidgetBuilder getCirclePlaceBuilder(double? radius, double? border, Color? borderColor) {
    double? _width = radius == null ? null : radius * 2 / 2.0;
    return (BuildContext context, String url) {
      return ClipOval(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: border == null || border == 0.0
                ? null
                : Border.all(color: borderColor ?? Colors.transparent, width: border),
            color: Colours.ff1e5d5d,
          ),
          width: radius! * 2,
          height: radius * 2,
          alignment: Alignment.center,
          child: SizedBox(
            width: _width ?? 60,
            height: _width ?? 60,
            child: const PinSvg(R.icDefaultMusic),
          ),
        ),
      );
    };
  }
}
