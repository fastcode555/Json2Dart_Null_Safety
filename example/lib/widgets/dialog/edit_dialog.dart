import 'package:flutter/material.dart';
import 'package:gesound/common/utils/navigator_util.dart';
import 'package:gesound/res/index.dart';
import 'package:gesound/res/strings.dart';
import 'package:gesound/widgets/buttons.dart';
import 'package:gesound/widgets/dialog/base_dialog.dart';
import 'package:get/get.dart';

/// @date 31/5/22
/// describe:
String _value = "";

class EditDialog extends Dialog {
  final String title;
  final String hintText;
  final double? width;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onRightCallback;
  final TextEditingController? controller;
  final int? maxLength;

  const EditDialog(
    this.title,
    this.hintText, {
    this.width,
    this.onChanged,
    this.onRightCallback,
    this.controller,
    this.maxLength = 20,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      height: 200.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyles.RobotoWhiteW50018),
          InputField.border(
            labelText: hintText,
            contentPadding: 0,
            maxLength: maxLength,
            height: 50.0,
            onChangeDelay: false,
            onChanged: (v) {
              _value = v;
              onChanged?.call(v);
            },
            controller: controller,
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colours.mainColor)),
            inputBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colours.mainColor)),
            hintStyle: TextStyles.RobotoWhite12814,
            style: TextStyles.RobotoWhite12814,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinBtn(Ids.cancel.tr, onPressed: NavigatorUtil.pop),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FillButton(
                  Ids.confirm.tr,
                  radius: 8.0,
                  onPressed: () {
                    onRightCallback?.call(_value);
                    _value = '';
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
