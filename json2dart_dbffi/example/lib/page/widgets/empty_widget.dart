import 'package:book_reader/res/index.dart';
import 'package:book_reader/res/strings.dart';
import 'package:flutter/material.dart';

/// @date 20/7/22
/// describe:
class EmptyWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const EmptyWidget({this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Spacer(),
          Image.asset(R.icEnjoyReadBook, width: 200, height: 200),
          TextButton(onPressed: onPressed, child: Text(Ids.addBooks.tr)),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
