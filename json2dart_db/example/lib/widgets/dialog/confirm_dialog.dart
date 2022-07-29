import 'package:flutter/material.dart';
import 'package:gesound/common/utils/navigator_util.dart';
import 'package:gesound/res/index.dart';
import 'package:gesound/res/strings.dart';
import 'package:gesound/widgets/buttons.dart';
import 'package:gesound/widgets/dialog/base_dialog.dart';
import 'package:get/get.dart';

/// @date 31/5/22
/// describe:

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final double? width;
  final double? height;
  final String? leftText;
  final String? rightText;
  final GestureTapCallback? leftCallBack;
  final GestureTapCallback? rightCallBack;

  const ConfirmDialog(
    this.title,
    this.content, {
    this.width,
    this.height,
    this.leftText,
    this.rightText,
    this.leftCallBack,
    this.rightCallBack,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyles.RobotoWhiteW50018),
          Text(content, style: TextStyles.RobotoWhite14, textAlign: TextAlign.center),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinBtn(
                  leftText ?? Ids.cancel.tr,
                  onPressed: leftCallBack ?? NavigatorUtil.pop,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FillButton(
                  rightText ?? Ids.confirm.tr,
                  radius: 8.0,
                  onPressed: rightCallBack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
