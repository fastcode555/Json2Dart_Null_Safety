import 'dart:async';

import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/common/model/chapter.dart';
import 'package:book_reader/common/model/font_eg.dart';
import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/res/index.dart';
import 'package:book_reader/res/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//章节选择页
class ChapterSelectdPage extends StatefulWidget {
  final BookModel? bookModel;

  const ChapterSelectdPage(this.bookModel, {Key? key}) : super(key: key);

  @override
  _ChapterSelectdPageState createState() => _ChapterSelectdPageState();
}

class _ChapterSelectdPageState extends State<ChapterSelectdPage> {
  late FixedExtentScrollController _scrollController;
  final ReaderController controller = Get.find<ReaderController>();
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    int index = controller.getChapterIndex(controller.currentChapter.value);
    _scrollController = FixedExtentScrollController(initialItem: index);
    _sub = controller.currentChapter.listen(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    ReaderController controller = Get.find<ReaderController>();
    Color? color = controller.readerTheme.value.fontColor;
    FontEg? font = controller.readerTheme.value.font;
    return Column(
      children: [
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              //跳转到所在的章节
              controller.scroll2Target(_scrollController.selectedItem);
              controller.isPanelClose.value = true;
            },
            child: Text(Ids.confirm.tr, style: TextStyle(color: color)),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: CupertinoPicker.builder(
            itemExtent: 41,
            //item的高度
            onSelectedItemChanged: (index) {},
            scrollController: _scrollController,
            selectionOverlay: Row(
              children: [
                Container(color: color, width: 8, height: 41),
                const Spacer(),
                Container(color: color, width: 8, height: 41),
              ],
            ),
            itemBuilder: (_, index) {
              Chapter _chapter = widget.bookModel!.chapter![index];
              return Container(
                alignment: Alignment.center,
                child: Text(
                  _chapter.chapterTitle ?? "",
                  style: TextStyle(
                    fontSize: 15,
                    color: color,
                    fontFamily: font?.fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
            childCount: widget.bookModel?.chapter?.length ?? 0,
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _sub?.cancel();
  }

  void _scrollListener(Chapter currentChapter) {
    int pageIndex = controller.getChapterIndex(currentChapter);
    _scrollController.animateToItem(pageIndex, duration: const Duration(seconds: 1), curve: Curves.easeIn);
  }
}
