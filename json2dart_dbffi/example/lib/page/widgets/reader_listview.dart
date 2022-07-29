import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/common/model/chapter.dart';
import 'package:book_reader/common/model/reader_theme.dart';
import 'package:book_reader/database/db_manager.dart';
import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/res/index.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

///阅读器列表页面
class ReaderListView extends StatefulWidget {
  final BookModel bookModel;

  const ReaderListView(this.bookModel, {Key? key}) : super(key: key);

  @override
  _ReaderListViewState createState() => _ReaderListViewState();
}

class _ReaderListViewState extends State<ReaderListView> {
  ReaderController controller = Get.find<ReaderController>();

  ReaderTheme get _readTheme => controller.readerTheme.value;

  Color? get _fontColor => _readTheme.fontColor;

  double? get _fontSize => _readTheme.fontSize;

  double get _padding => _readTheme.paddingType;

  double get _letterHeight => _readTheme.letterHeight;

  String? get _fontFamily => _readTheme.font?.fontFamily;
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int _lastPage = -1;

  @override
  void initState() {
    super.initState();
    controller.queryChapters(widget.bookModel, offset: widget.bookModel.lastIndex ?? 0).then((value) {
      controller.currentChapter.value = controller.chapters.value[0];
    });
    //返回当前页面可见的position
    itemPositionsListener.itemPositions.addListener(() {
      var positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        ItemPosition position = positions.toList()[0];
        Chapter chapter = controller.chapters[position.index];
        debugPrint(
            "position:${position.index},itemLeadingEdge:${position.itemLeadingEdge},itemTrailingEdge:${position.itemTrailingEdge}");
        if (chapter != controller.currentChapter.value) {
          controller.currentChapter.value = chapter;
          widget.bookModel.lastIndex = controller.getChapterIndex(chapter);
          //如果是最后一章，则加载更多章节补充到末尾
          if (position.index == controller.chapters.length - 1) {
            controller.queryChapters(widget.bookModel);
          } else if (position.index == 0 && controller.offset > 0 && _lastPage != position.index) {
            //如果是首章
            // controller.queryChapters(widget.bookModel, reverse: true).then((value) {
            //   _scrollController.jumpTo(index: 0);
            // });
            // _lastPage = position.index;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Padding(
          padding: EdgeInsets.fromLTRB(_padding, 20, _padding, 0),
          child: ScrollablePositionedList.builder(
            itemScrollController: _scrollController,
            itemPositionsListener: itemPositionsListener,
            itemBuilder: (_, index) {
              Chapter chapter = controller.chapters[index];
              return Text(
                chapter.content ?? "",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: _fontSize,
                  color: _fontColor,
                  fontFamily: _fontFamily,
                  fontWeight: FontWeight.w500,
                  height: _letterHeight,
                ),
              );
            },
            itemCount: controller.chapters.length,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.clear();
    DbManager.instance.bookModelDao.update(widget.bookModel);
  }
}
