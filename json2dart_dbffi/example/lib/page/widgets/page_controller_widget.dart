import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/common/model/reader_theme.dart';
import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/page/widgets/chapter_selected_page.dart';
import 'package:book_reader/page/widgets/page_controll.dart';
import 'package:book_reader/page/widgets/page_reading.dart';
import 'package:book_reader/res/index.dart';
import 'package:book_reader/res/strings.dart';
import 'package:flutter/material.dart';

/// @date 5/5/22
/// describe:
class PageControllerWidget extends StatefulWidget {
  const PageControllerWidget({Key? key}) : super(key: key);

  @override
  _PageControllerWidgetState createState() => _PageControllerWidgetState();
}

class _PageControllerWidgetState extends State<PageControllerWidget> with SingleTickerProviderStateMixin {
  final List<String> _titles = [Ids.reading, Ids.control, Ids.contents];
  TabController? _tabController;
  BookModel? _bookModel;
  ReaderController controller = Get.find<ReaderController>();

  ReaderTheme get _readerTheme => controller.readerTheme.value;

  Color? get _background => _readerTheme.background;

  Color? get _fontColor => _readerTheme.fontColor;

  @override
  void initState() {
    super.initState();
    if (Get.arguments is BookModel) {
      _bookModel = Get.arguments;
    }
    _tabController = TabController(length: _titles.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          controller.isPanelClose.value = true;
        },
        child: Container(
          height: GetPlatform.isMobile ? 380.0 : 280,
          decoration: BoxDecoration(
            color: _background ?? Colors.white,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
            boxShadow: const [
              BoxShadow(color: Colours.black26, offset: Offset(0, -10), blurRadius: 20),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              TabBar(
                tabs: _titles.mapWidget((_, e) => Tab(text: e.tr)),
                controller: _tabController,
                labelColor: _fontColor,
                indicatorColor: _fontColor,
                unselectedLabelColor: _fontColor?.withOpacity(0.6),
                indicatorWeight: 4.0,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PageReading(),
                    const PageControll(),
                    ChapterSelectdPage(_bookModel),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.save();
  }
}
