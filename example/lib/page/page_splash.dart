import 'package:flutter/material.dart';
import 'package:gesound/common/utils/navigator_util.dart';
import 'package:gesound/page/page_playlist.dart';
import 'package:gesound/res/index.dart';

/// @date 10/6/22
/// describe:
class PageSplash extends StatefulWidget {
  static const String routeName = "/page/PageSplash";

  const PageSplash({Key? key}) : super(key: key);

  @override
  _PageSplashState createState() => _PageSplashState();
}

class _PageSplashState extends State<PageSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      NavigatorUtil.pushReplacementNamed(PagePlaylist.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(showAppBar: false);
  }
}
