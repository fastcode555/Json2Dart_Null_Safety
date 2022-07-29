import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/res/index.dart';
import 'package:book_reader/widgets/switch_listtitleex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../res/strings.dart';

class PageControll extends StatelessWidget {
  const PageControll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? _color = Get.find<ReaderController>().readerTheme.value.fontColor;
    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                _PageSwitchWidget(R.icSwipe, Ids.swipe.tr, _color!),
                _PageSwitchWidget(R.icScroll, Ids.scroll.tr, _color),
                _PageSwitchWidget(R.icTap, Ids.tap.tr, _color),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (GetPlatform.isMobile) _RotateControllWidget(),
        //通过音量键旋转
        if (GetPlatform.isMobile)
          SwitchListTitleEx(
            Ids.flippingTheVolumeButton.tr,
            onChanged: (value) {},
          ),
      ],
    );
  }
}

class _PageSwitchWidget extends StatelessWidget {
  final String pic;
  final String title;
  final Color color;

  const _PageSwitchWidget(
    this.pic,
    this.title,
    this.color, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          PinSvg(pic, size: 34, color: color),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

//控制屏幕旋转
class _RotateControllWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      height: 80,
      child: Row(
        children: const [
          Expanded(
            child: PinSvg(R.icRotate, size: 48),
          ),
          Expanded(
            child: PinSvg(R.icPotraint, size: 48),
          ),
          Expanded(
            child: PinSvg(R.icLandscape, size: 30),
          ),
        ],
      ),
    );
  }
}
