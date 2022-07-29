import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/common/model/chapter.dart';
import 'package:book_reader/common/model/reader_theme.dart';
import 'package:book_reader/res/r.dart';
import 'package:flutter/material.dart';
import 'package:xdlibrary/widgets/pin_mark_widget.dart';

/// @date 4/5/22
/// describe:
class ReaderAppBar extends StatelessWidget {
  final ReaderTheme readerTheme;
  final BookModel? bookModel;
  final Chapter? chapter;

  const ReaderAppBar(
    this.readerTheme,
    this.bookModel,
    this.chapter, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: AppBar(
        backgroundColor: readerTheme.background,
        leading: IconButton(
          icon: PinSvg(R.icReturn, color: readerTheme.fontColor, width: 17.0, height: 14.3),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          chapter?.chapterTitle ?? bookModel?.title ?? '',
          style: TextStyle(
            fontSize: 18,
            color: readerTheme.fontColor,
            fontWeight: FontWeight.w500,
            fontFamily: readerTheme.font?.fontFamily,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: PinSvg(
              R.icMark,
              color: readerTheme.fontColor,
            ),
          ),
        ],
      ),
    );
  }
}
