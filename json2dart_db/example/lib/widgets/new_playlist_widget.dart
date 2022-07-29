import 'package:flutter/material.dart';
import 'package:gesound/res/index.dart';
import 'package:gesound/res/strings.dart';
import 'package:get/get.dart';

/// @date 7/6/22
/// describe:
class NewPlayListWidget extends StatelessWidget {
  final double? width;
  final GestureTapCallback? onTap;

  const NewPlayListWidget({
    this.width,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 70.0,
        child: Row(
          children: [
            const PinSvg(R.icEdabStoke, size: 50.0),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(Ids.newPlaylist.tr, style: TextStyles.whiteW50016),
                const SizedBox(height: 2.0),
                Text(Ids.createANewPlaylist.tr, style: TextStyles.white12812),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
