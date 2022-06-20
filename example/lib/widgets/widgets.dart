import 'package:flutter/material.dart';
import 'package:gesound/res/index.dart';

class MoreActionWidget extends StatelessWidget {
  const MoreActionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 40.0,
      child: const PinSvg(R.icMore, width: 19.0, height: 19.0),
    );
  }
}
