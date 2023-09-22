import 'dart:io' show File;
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'image_loader_config.dart';

bool _isNetUrl(String? url) {
  if (TextUtil.isEmpty(url)) return false;
  return url!.startsWith('http') && !url.endsWith(".mp3") && !url.endsWith(".mp4");
}

//由于tag只能有一个直接子View
_buildHeroWidget(String? heroTag, {required Widget child, bool? transitionOnUserGestures = false}) {
  if (heroTag == null || heroTag.isEmpty) {
    return child;
  }
  return Hero(
    tag: heroTag,
    child: child,
    transitionOnUserGestures: transitionOnUserGestures ?? false,
  );
}

Widget _buildBorderCircleImage(double? border, Color? borderColor, Widget child, {BoxShape shape = BoxShape.circle}) {
  if (borderColor != null && border != null && border > 0) {
    return Container(
      decoration: BoxDecoration(
        shape: shape,
        border: Border.all(color: borderColor, width: border),
        color: borderColor,
      ),
      child: child,
    );
  }
  return child;
}

//作为收集urls的临时存储,release不起作用,主要用于新需求编写测试代码使用
List<String>? _imageUrls;

class ImageLoader extends StatelessWidget {
  //随机获取一个图片的url
  static String getImage() {
    if (_imageUrls != null && _imageUrls!.isNotEmpty) {
      return _imageUrls![Random().nextInt(_imageUrls!.length)];
    }
    return '';
  }

  static Future<File?> getFromCache(String url) async {
    FileInfo? file = await DefaultCacheManager().getFileFromCache(url);
    return file?.file;
  }

  //随机生成对应数量的urls图片
  static List<String> getImages({int count = 5}) {
    List<String> urls = [];
    if (_imageUrls != null) {
      for (int i = 0; i < count; i++) {
        if (_imageUrls!.isEmpty) {
          urls.add('');
        } else if (_imageUrls!.length == 1) {
          urls.add(_imageUrls![0]);
        } else {
          urls.add(_imageUrls![Random().nextInt(_imageUrls!.length - 1)]);
        }
      }
    }
    return urls;
  }

  static ImageProvider? getImageProvider(String? url) {
    if (_isNetUrl(url)) {
      return CachedNetworkImageProvider(url!);
    } else {
      File imageFile = File(url ?? '');
      bool isFile = url != null && url.isNotEmpty && imageFile.existsSync();
      if (isFile) {
        return FileImage(imageFile);
      }
    }
    return null;
  }

  final String? url;
  final PlaceholderWidgetBuilder? placeBuilder;
  final LoadingErrorWidgetBuilder? errorBuilder;
  final BoxFit fit;
  final String? placeHolder;
  final String? errorHolder;

  final String? heroTag;

  //手指滑动关闭页面时,是否也启用共享元素动画
  final bool transitionOnUserGestures;
  Color? _blurColor;

  double? _width;
  double? _height;
  double? _radius;
  double? _sigmaX;
  double? _sigmaY;
  double? border;
  Color? borderColor;
  BorderRadiusGeometry? _borderRadius;
  String? _thumbUrl;
  final Decoration? decoration;

  static ImageLoaderConfigInterface? config;

  //普通图片
  static const int TYPE_NORMAL = 0;

  //圆形图片
  static const int TYPE_CIRCLE = 1;

  //圆角图片
  static const int TYPE_ROUND_CORNER = 2;

  //高斯模糊图片
  static const int TYPE_BLUR = 3;

  int _type = TYPE_NORMAL;

  //使用滚动组件NotificationListener包裹住滚动的view，如果滚动停止，就进行加载
  final Type? notification;

  bool get _canLoadImage => notification == null || notification == ScrollEndNotification;

  //普通图片
  ImageLoader.image(
    this.url, {
    Key? key,
    this.placeBuilder,
    this.errorBuilder,
    this.fit = BoxFit.cover,
    double? width,
    double? height,
    String? thumbUrl,
    this.placeHolder,
    this.errorHolder,
    this.heroTag,
    this.transitionOnUserGestures = false,
    this.decoration,
    this.border,
    this.borderColor,
    this.notification,
  }) : super(key: key) {
    this._width = width;
    this._height = height;
    this._type = TYPE_NORMAL;
    this._thumbUrl = thumbUrl;
  }

  //圆形图片
  ImageLoader.circle(
    this.url, {
    this.placeBuilder,
    this.errorBuilder,
    this.placeHolder,
    this.errorHolder,
    this.heroTag,
    this.fit = BoxFit.cover,
    double? radius,
    this.border = 0.0,
    this.borderColor,
    this.transitionOnUserGestures = false,
    this.decoration,
    this.notification,
  }) {
    this._radius = radius;
    this._type = TYPE_CIRCLE;
  }

  //圆角图片
  ImageLoader.roundCorner(
    this.url, {
    this.placeBuilder,
    this.errorBuilder,
    this.placeHolder,
    this.errorHolder,
    this.heroTag,
    this.fit = BoxFit.cover,
    double? width,
    double? height,
    double? radius = 0,
    String? thumbUrl,
    BorderRadius? borderRadius,
    this.border = 0.0,
    this.borderColor = Colors.white,
    this.transitionOnUserGestures = false,
    this.decoration,
    this.notification,
  }) {
    this._radius = radius;
    this._type = TYPE_ROUND_CORNER;
    this._borderRadius = borderRadius;
    this._width = width;
    this._height = height;
    this._thumbUrl = thumbUrl;
  }

  //高斯模糊图片
  ImageLoader.blur(
    this.url, {
    this.placeBuilder,
    this.errorBuilder,
    this.placeHolder,
    this.errorHolder,
    this.heroTag,
    this.fit = BoxFit.cover,
    double width = double.infinity,
    double height = double.infinity,
    double sigmaX = 8,
    double sigmaY = 8,
    double radius = 0,
    BorderRadius? borderRadius,
    this.transitionOnUserGestures = false,
    Color? blurColor,
    this.decoration,
    this.notification,
  }) {
    this._radius = radius;
    this._type = TYPE_BLUR;
    this._borderRadius = borderRadius ?? BorderRadius.all(Radius.circular(0));
    this._width = width;
    this._height = height;
    this._sigmaX = sigmaX;
    this._sigmaY = sigmaY;
    this._blurColor = blurColor;
  }

  static init(ImageLoaderConfigInterface config) {
    ImageLoader.config = config;
  }

  @override
  Widget build(BuildContext context) {
    if (_radius == null && decoration != null && decoration is BoxDecoration) {
      BoxDecoration boxDecoration = decoration as BoxDecoration;
      if (boxDecoration.shape == BoxShape.circle) {
        _type = TYPE_CIRCLE;
        _radius = _radius ?? ((_width ?? _height ?? 0.0) / 2.0);
      } else if (boxDecoration.borderRadius is BorderRadius) {
        _borderRadius = boxDecoration.borderRadius as BorderRadius;
        _type = TYPE_ROUND_CORNER;
      }
    }

    Widget widget = _buildImage(context);
    if (decoration != null) {
      return Container(child: widget, decoration: decoration);
    }
    return widget;
  }

  Widget _buildImage(BuildContext context) {
    //debugPrint("进行图片重新加载${notification},显示图片：${_canLoadImage ? url : null}");
    if (_type == TYPE_NORMAL) {
      return _Image(
        _canLoadImage ? url : null,
        thumbUrl: _canLoadImage ? _thumbUrl : null,
        placeBuilder: placeBuilder,
        errorBuilder: errorBuilder,
        fit: fit,
        width: _width,
        height: _height,
        borderColor: borderColor,
        border: border,
        placeHolder: placeHolder,
        errorHolder: errorHolder,
        heroTag: heroTag,
      );
    } else if (_type == TYPE_CIRCLE) {
      if (_radius == null || _radius == 0) {
        return LayoutBuilder(
          builder: (ctx, constraint) {
            _width = (constraint.maxWidth > constraint.maxHeight ? constraint.maxHeight : constraint.maxWidth);
            return ClipOval(
              child: _Image(
                _canLoadImage ? url : null,
                placeBuilder: placeBuilder,
                errorBuilder: errorBuilder,
                fit: fit,
                width: _width ?? _height,
                height: _height ?? _width,
                placeHolder: placeHolder,
                errorHolder: errorHolder,
                borderColor: borderColor,
                border: border,
                heroTag: heroTag,
              ),
            );
          },
        );
      }
      return _CircleImage(
        _canLoadImage ? url : null,
        placeHolder: placeHolder,
        errorBuilder: errorBuilder,
        errorHolder: errorHolder,
        fit: fit,
        heroTag: heroTag,
        placeBuilder: placeBuilder,
        radius: _radius,
        border: border,
        borderColor: borderColor,
      );
    } else if (_type == TYPE_ROUND_CORNER) {
      return ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: _borderRadius ?? BorderRadius.all(Radius.circular(_radius!)),
        child: _Image(_canLoadImage ? url : null,
            fit: fit,
            thumbUrl: _thumbUrl,
            placeHolder: placeHolder,
            errorHolder: errorHolder,
            placeBuilder: placeBuilder,
            errorBuilder: errorBuilder,
            borderColor: borderColor,
            border: border,
            width: _width ?? _height,
            height: _height ?? _width,
            heroTag: heroTag),
      );
    } else if (_type == TYPE_BLUR) {
      return SizedBox(
        width: _width,
        height: _height,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: _borderRadius ?? BorderRadius.zero,
              child: _Image(
                _canLoadImage ? url : null,
                fit: fit,
                placeHolder: placeHolder,
                placeBuilder: placeBuilder,
                errorBuilder: errorBuilder,
                heroTag: heroTag,
                errorHolder: errorHolder,
                width: _width,
                border: border,
                borderColor: borderColor,
                height: _height,
              ),
            ),
            ClipRRect(
              borderRadius: _borderRadius ?? BorderRadius.zero,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: _sigmaX!, sigmaY: _sigmaY!),
                child: Container(color: _blurColor ?? Colors.white10),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox();
  }
}

class _CircleImage extends StatelessWidget {
  final String? url;
  final PlaceholderWidgetBuilder? placeBuilder;
  final LoadingErrorWidgetBuilder? errorBuilder;
  final BoxFit? fit;
  final String? placeHolder;
  final String? errorHolder;
  final String? heroTag;
  final double? radius;
  final double? border;
  final Color? borderColor;
  final bool? transitionOnUserGestures;

  _CircleImage(
    this.url, {
    Key? key,
    this.placeBuilder,
    this.errorBuilder,
    this.fit,
    this.placeHolder,
    this.errorHolder,
    this.heroTag,
    this.border = 0,
    this.borderColor = Colors.white,
    this.radius,
    this.transitionOnUserGestures = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlaceholderWidgetBuilder? _placeBuilder;
    LoadingErrorWidgetBuilder? _errorBuilder;
    if (ImageLoader.config == null) {
      debugPrint("you are supported to use ImageLoader.init(ImageLoaderConfig)");
    } else {
      _placeBuilder = placeBuilder ?? ImageLoader.config?.getCirclePlaceBuilder(radius, border, borderColor);
      _errorBuilder = errorBuilder ?? ImageLoader.config?.getCircleErrorBuilder(radius, border, borderColor);
    }

    if (_isNetUrl(url)) {
      return CachedNetworkImage(
        imageUrl: url!,
        imageBuilder: (context, imageProvider) => _buildBorderCircleImage(
            border,
            borderColor,
            _buildHeroWidget(
              heroTag,
              transitionOnUserGestures: transitionOnUserGestures,
              child: CircleAvatar(
                backgroundImage: imageProvider,
                radius: radius,
                backgroundColor: Colors.transparent,
              ),
            )),
        placeholder: placeHolder != null
            ? (context, url) => _buildBorderCircleImage(
                  border,
                  borderColor,
                  _buildHeroWidget(
                    heroTag,
                    transitionOnUserGestures: transitionOnUserGestures,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(placeHolder ?? ''),
                      radius: radius,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                )
            : _placeBuilder,
        errorWidget: errorHolder != null
            ? (context, url, error) => _buildBorderCircleImage(
                  border,
                  borderColor,
                  _buildHeroWidget(
                    heroTag,
                    transitionOnUserGestures: transitionOnUserGestures,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(errorHolder ?? ''),
                      radius: radius,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                )
            : _errorBuilder,
      );
    } else {
      File imageFile = File(url ?? '');
      bool isFile = url != null && url!.isNotEmpty && imageFile.existsSync();
      if (isFile) {
        return _buildBorderCircleImage(
          border,
          borderColor,
          _buildHeroWidget(
            heroTag,
            transitionOnUserGestures: transitionOnUserGestures,
            child: CircleAvatar(
              radius: radius,
              backgroundImage: FileImage(imageFile),
              backgroundColor: Colors.transparent,
            ),
          ),
        );
      } else {
        return errorHolder != null
            ? _buildBorderCircleImage(
                border,
                borderColor,
                _buildHeroWidget(
                  heroTag,
                  transitionOnUserGestures: transitionOnUserGestures,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(errorHolder ?? ''),
                    radius: radius,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )
            : _errorBuilder!(context, url!, null);
      }
    }
  }
}

class _Image extends StatelessWidget {
  final String? url;
  final PlaceholderWidgetBuilder? placeBuilder;
  final LoadingErrorWidgetBuilder? errorBuilder;
  final BoxFit? fit;
  final width;
  final height;
  final String? placeHolder;
  final String? errorHolder;
  final String? heroTag;
  final String? thumbUrl;
  final double? border;
  final Color? borderColor;
  final bool transitionOnUserGestures;

  _Image(
    this.url, {
    Key? key,
    this.placeBuilder,
    this.errorBuilder,
    this.fit,
    this.placeHolder,
    this.errorHolder,
    this.heroTag,
    this.width,
    this.height,
    this.border,
    this.borderColor,
    this.transitionOnUserGestures = false,
    this.thumbUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoadingErrorWidgetBuilder? _errorBuilder;
    PlaceholderWidgetBuilder? _placeBuilder;
    double? _width = width ?? height;
    double? _height = height ?? width; //只要有一个值进来,即便另一个值为空,就默认为正方形图片
    if (ImageLoader.config == null) {
      debugPrint("you are supported to use ImageLoader.init(ImageLoaderConfig)");
    } else {
      _errorBuilder = errorBuilder ?? ImageLoader.config?.getErrorBuilder(_width, _height, border, borderColor);
      _placeBuilder = placeBuilder ?? ImageLoader.config?.getPlaceBuilder(_width, _height, border, borderColor);
    }
    if (_isNetUrl(url)) {
      return CachedNetworkImage(
        imageUrl: url!,
        key: ValueKey(url),
        fit: fit,
        fadeOutDuration: Duration(milliseconds: thumbUrl != null && thumbUrl!.length > 0 ? 0 : 1000),
        fadeInDuration: Duration(milliseconds: thumbUrl != null && thumbUrl!.length > 0 ? 0 : 500),
        width: _width,
        height: _height,
        imageBuilder: (context, imageProvider) => _buildBorderCircleImage(
          border,
          borderColor,
          _buildHeroWidget(
            heroTag,
            transitionOnUserGestures: transitionOnUserGestures,
            child: Image(
              image: imageProvider,
              fit: fit,
              width: _width,
              height: _height,
              alignment: Alignment.center,
              repeat: ImageRepeat.noRepeat,
              matchTextDirection: false,
              filterQuality: FilterQuality.low,
            ),
          ),
          shape: BoxShape.rectangle,
        ),
        placeholder: _buildPlaceWidgetBuilder(context, url, _width, _height, _placeBuilder),
        errorWidget: _buildErrorWidgetBuilder(context, url, _width, _height, _errorBuilder),
      );
    } else {
      return _loadFileOrAssertImage(_errorBuilder, _width, _height, context);
    }
  }

  //加载文件型图片
  Widget _loadFileOrAssertImage(
      LoadingErrorWidgetBuilder? errorBuilder, double? width, double? height, BuildContext context) {
    File imageFile = File(url ?? '');
    bool isFile = url != null && url!.isNotEmpty && imageFile.existsSync();
    if (isFile) {
      return _buildHeroWidget(heroTag,
          transitionOnUserGestures: transitionOnUserGestures,
          child: Image.file(
            imageFile,
            fit: fit,
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return errorBuilder != null
                  ? errorBuilder(context, url ?? '', error)
                  : _buildHeroWidget(
                      heroTag,
                      transitionOnUserGestures: transitionOnUserGestures,
                      child: Image.asset(errorHolder ?? '', width: width, height: height),
                    );
            },
            width: width,
            height: height ?? width,
          ));
    } else {
      return errorHolder != null
          ? _buildHeroWidget(
              heroTag,
              transitionOnUserGestures: transitionOnUserGestures,
              child: Image.asset(url != null && url!.length > 0 ? url! : errorHolder!, width: width, height: height),
            )
          : errorBuilder!(context, url ?? '', null);
    }
  }

  PlaceholderWidgetBuilder? _buildPlaceWidgetBuilder(
    BuildContext context,
    String? url,
    double? width,
    double? height,
    PlaceholderWidgetBuilder? placeBuilder,
  ) {
    //修改,使用者单独传了一个默认图片,单方法配置,优先于全配置,便于定制化,比如默认店铺默认一张默认店铺的图片,商品默认一张商品的图片
    //有设置了thumbUrl,优先加载小图
    if (thumbUrl != null && thumbUrl!.length > 0) {
      return (context, url) => _buildThumbUrlWidget();
    }
    //有设置方法型,优先加载placeHolder,
    if (placeHolder != null) {
      return (context, url) => _buildBorderCircleImage(
            border,
            borderColor,
            _buildHeroWidget(
              heroTag,
              transitionOnUserGestures: transitionOnUserGestures,
              child: Image.asset(placeHolder ?? '', width: width, height: height),
            ),
            shape: BoxShape.rectangle,
          );
    }
    //没有使用默认的
    return placeBuilder;
  }

  LoadingErrorWidgetBuilder? _buildErrorWidgetBuilder(
    BuildContext context,
    String? url,
    double? width,
    double? height,
    LoadingErrorWidgetBuilder? errorBuilder,
  ) {
    //有设置了thumbUrl,优先加载小图
    if (thumbUrl != null && thumbUrl!.length > 0) {
      return (context, url, error) => _buildThumbUrlWidget();
    }
    //有设置方法型,优先加载errorHolder,
    if (errorHolder != null) {
      return (context, url, error) => _buildHeroWidget(
            heroTag,
            transitionOnUserGestures: transitionOnUserGestures,
            child: Image.asset(errorHolder ?? '', width: width, height: height),
          );
    }
    //没有使用默认的
    return errorBuilder;
  }

  Widget _buildThumbUrlWidget() {
    return _Image(
      thumbUrl ?? '',
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder,
      placeBuilder: placeBuilder,
      placeHolder: placeHolder,
      border: border,
      borderColor: borderColor,
      errorHolder: errorHolder,
    );
  }
}
