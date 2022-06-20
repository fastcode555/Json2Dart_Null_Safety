import 'package:flutter/material.dart';
import 'package:gesound/common/model/category_model.dart';
import 'package:gesound/res/index.dart';

/// @date 1/6/22
/// describe:
class CustomTabBar extends StatelessWidget {
  final List<CategoryModel> titles;
  final TabController controller;
  final VoidCallback? onTap;

  const CustomTabBar(
    this.titles, {
    required this.controller,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ResDecor.decor17,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20),
      height: 30,
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              tabs: titles.map((t) => Tab(text: t.finalName)).toList(),
              controller: controller,
              isScrollable: true,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: const SizedBox(
              width: 40.0,
              height: 19.0,
              child: PinSvg(R.icMore, width: 5.0, height: 19.0),
            ),
          ),
        ],
      ),
    );
  }
}
