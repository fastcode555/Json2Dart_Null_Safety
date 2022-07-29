import 'package:book_reader/res/index.dart';
import 'package:flutter/material.dart';

import '../res/strings.dart';

class PageBooks extends StatelessWidget {
  static const String routeName = "/page/PageBooks";

  const PageBooks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colours.white,
      titleId: Ids.catalogue,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const PinSvg(R.icSerchStoke, color: Colours.ff323232, size: 18.0),
        ),
      ],
      body: Stack(
        children: [
          Text(Ids.educationalLiterature.tr, style: TextStyles.ff323232Bold22),
        ],
      ),
    );
  }
}
