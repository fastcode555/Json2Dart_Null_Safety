import 'package:book_reader/res/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @date 25/4/22
/// describe:
class SwitchListTitleEx extends StatelessWidget {
  final String title;
  final ValueChanged<bool>? onChanged;

  const SwitchListTitleEx(this.title, {Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        height: 50,
        child: Row(
          children: [
            Text(title, style: TextStyles.blackW50015),
            const Spacer(),
            CupertinoSwitch(
              value: true,
              onChanged: onChanged,
              activeColor: Colours.mainColor,
            ),
          ],
        ),
      ),
    );
  }
}
