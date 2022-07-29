import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//配置只复写builder式的构造方法
abstract class ImageLoaderConfigInterface {
  //错误状态下的默认图片
  LoadingErrorWidgetBuilder getErrorBuilder(double? width, double? height, double? border, Color? borderColor);

  //正常状态下的
  PlaceholderWidgetBuilder getPlaceBuilder(double? width, double? height, double? border, Color? borderColor);

  //圆形头像加载异常处理
  LoadingErrorWidgetBuilder getCircleErrorBuilder(double? radius, double? border, Color? borderColor);

  //圆形头像加载处理
  PlaceholderWidgetBuilder getCirclePlaceBuilder(double? radius, double? border, Color? borderColor);
}
