import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../res/index.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? title;
  final Widget? body;
  final String? titleLabel;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final AppBar? appBar;
  final bool showAppBar;
  final PreferredSizeWidget? bottom;
  final bool? resizeToAvoidBottomInset;
  final String? titleId;
  final bool automaticallyImplyLeading;
  final bool? centerTitle;
  final EdgeInsetsGeometry? padding;
  final Color? appBarColor;
  final bool blur;
  final Color? arrowColor;
  final Brightness? brightness;
  final double? height;
  final String? subTitleLable;
  bool _slideOffPage = false;
  final Widget? leading;

  PageController? _pageController;
  BuildContext? _context;

  CustomScaffold({
    Key? key,
    this.title,
    this.titleLabel,
    this.body,
    this.actions,
    this.blur = false,
    this.resizeToAvoidBottomInset = false,
    this.appBar,
    this.backgroundColor = Colours.bottomBarColor,
    this.showAppBar = true,
    this.appBarColor = Colors.transparent,
    this.bottom,
    this.titleId,
    this.automaticallyImplyLeading = true,
    this.padding,
    this.centerTitle = true,
    this.arrowColor,
    this.brightness,
    this.leading,
    this.height,
    this.subTitleLable,
  }) : super(key: key);

  CustomScaffold.blur({
    Key? key,
    this.title,
    this.titleLabel,
    this.body,
    this.actions,
    this.blur = true,
    this.resizeToAvoidBottomInset = false,
    this.appBar,
    this.backgroundColor = Colours.bottomBarColor,
    this.showAppBar = true,
    this.appBarColor = Colors.transparent,
    this.bottom,
    this.titleId,
    this.automaticallyImplyLeading = true,
    this.padding,
    this.arrowColor = Colors.black,
    this.centerTitle = true,
    this.brightness,
    this.leading,
    this.height,
    this.subTitleLable,
  }) : super(key: key);

  CustomScaffold.slide({
    Key? key,
    this.title,
    this.titleLabel,
    this.body,
    this.actions,
    this.blur = true,
    this.resizeToAvoidBottomInset = false,
    this.appBar,
    this.backgroundColor = Colours.bottomBarColor,
    this.showAppBar = true,
    this.appBarColor = Colors.transparent,
    this.bottom,
    this.titleId,
    this.arrowColor = Colors.black,
    this.automaticallyImplyLeading = true,
    this.padding,
    this.centerTitle = true,
    this.brightness,
    this.leading,
    this.height,
    this.subTitleLable,
  }) : super(key: key) {
    _slideOffPage = true;
    _pageController = PageController(initialPage: 1);
    _pageController?.addListener(() {
      if (_pageController?.page == 0 && _context != null && Navigator.canPop(_context!)) {
        Navigator.of(_context!).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    if (_slideOffPage && _pageController != null) {
      return PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return const SizedBox();
          } else {
            return blur ? _buildBlurScaffold(context) : _buildScaffold(context);
          }
        },
      );
    }
    if (blur) {
      return _buildBlurScaffold(context);
    }
    return _buildScaffold(context);
  }

  _buildLeading(BuildContext context) {
    if (automaticallyImplyLeading) {
      return leading ??
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          );
    }
  }

  Widget _buildScaffold(BuildContext context) {
    return Stack(
      children: [
        const SizedBox.expand(child: DecoratedBox(decoration: ResDecor.backgroundDecor)),
        Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          backgroundColor: Colors.transparent,
          appBar: !showAppBar
              ? null
              : appBar ??
                  AppBar(
                    leading: _buildLeading(context),
                    backgroundColor: appBarColor,
                    centerTitle: centerTitle,
                    systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: brightness),
                    automaticallyImplyLeading: automaticallyImplyLeading,
                    actions: actions,
                    title: _getTileWidget(),
                    elevation: 0,
                    bottom: bottom,
                  ),
          body: height != null
              ? SingleChildScrollView(child: Container(padding: padding, height: height, child: body))
              : padding == null
                  ? body
                  : Padding(padding: padding!, child: body),
        ),
      ],
    );
  }

  Widget _buildBlurScaffold(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        color: Colors.black12.withOpacity(0.2),
        child: _buildScaffold(context),
      ),
    );
  }

  Widget _getTileWidget() {
    if (TextUtil.isEmpty(subTitleLable)) {
      return title ?? Text(titleId?.tr ?? titleLabel ?? '', style: TextStyles.whiteW50024);
    }
    return Column(
      children: [
        title ?? Text(titleId?.tr ?? titleLabel ?? '', style: TextStyles.whiteW50024),
        const SizedBox(height: 4),
        Text(subTitleLable! /*, style: TextStyles.x8a323232W50015*/),
      ],
    );
  }
}
