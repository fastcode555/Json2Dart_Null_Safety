import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/common/model/chapter.dart';
import 'package:book_reader/common/model/reader_theme.dart';
import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/page/widgets/page_controller_widget.dart';
import 'package:book_reader/page/widgets/reader_app_bar.dart';
import 'package:book_reader/page/widgets/reader_listview.dart';
import 'package:book_reader/res/index.dart';
import 'package:flutter/material.dart';

/// @date 26/4/22
/// describe:

class PageReader extends BaseView<ReaderController> {
  static const String routeName = "/page/PageReader";

  PageReader({Key? key}) : super(key: key);

  ReaderTheme get _readTheme => controller.readerTheme.value;

  Color? get _backgroundColor => _readTheme.background;

  Color? get _fontColor => _readTheme.fontColor;

  String? get _fontFamily => _readTheme.font?.fontFamily;

  BookModel? _bookModel;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is BookModel) {
      _bookModel = Get.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Stack(
          children: [
            _readWidget(),
            Obx(
              () => AnimatedPositioned(
                left: 0,
                right: 0,
                top: controller.isPanelClose.value ? -100 : 0,
                duration: const Duration(milliseconds: 300),
                child: ReaderAppBar(_readTheme, _bookModel, controller.currentChapter.value),
              ),
            ),
            Obx(
              () => AnimatedPositioned(
                left: 0,
                right: 0,
                bottom: controller.isPanelClose.value ? -380 : 0,
                duration: const Duration(milliseconds: 300),
                child: const PageControllerWidget(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _readWidget() {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: GestureDetector(
        onTap: () {
          controller.isPanelClose.value = !controller.isPanelClose.value;
        },
        child: Column(
          children: [
            Expanded(child: ReaderListView(_bookModel!)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _bookModel?.title ?? "",
                      style: TextStyle(
                        fontSize: 10,
                        color: _fontColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: _fontFamily,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () {
                        Chapter currentChapter = controller.currentChapter.value;
                        String? title = currentChapter.chapterTitle;
                        title = TextUtil.isEmpty(title?.trim()) ? '' : '($title)';
                        return Text(
                          '$title${(currentChapter.chapterId ?? 0)}/${_bookModel!.chapterCount}',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 10,
                            color: _fontColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: _fontFamily,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
