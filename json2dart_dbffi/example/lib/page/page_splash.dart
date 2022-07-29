import 'dart:async';

import 'package:book_reader/page/page_book_shelf.dart';
import 'package:book_reader/res/index.dart';
import 'package:flutter/material.dart';

class PageSplash extends BaseView {
  static const String routeName = "/page/PageSplash";

  const PageSplash({Key? key}) : super(key: key);

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(seconds: 1), () {
      NavigatorUtil.pushReplacementNamed(PageBookShelf.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showAppBar: false,
      body: Stack(
        children: [
          Container(decoration: ResDecor.decor3),
          const Align(
            alignment: Alignment(0.0, -0.147),
            child: PinSvg(R.icLogo, color: Colours.white, width: 109.0, height: 88.0),
          ),
        ],
      ),
    );
  }
}
