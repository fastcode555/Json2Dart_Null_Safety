import 'package:book_reader/common/model/font_eg.dart';
import 'package:book_reader/common/model/reader_theme.dart';
import 'package:book_reader/common/utils/font_util.dart';
import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/res/index.dart';
import 'package:book_reader/res/strings.dart';
import 'package:flutter/material.dart';

class PageFontDialog extends StatefulWidget {
  static const String routeName = "/page/PageFontDialog";

  const PageFontDialog({Key? key}) : super(key: key);

  @override
  _PageFontDialogState createState() => _PageFontDialogState();
}

class _PageFontDialogState extends State<PageFontDialog> {
  final _readController = Get.find<ReaderController>();

  Rx<ReaderTheme> get _readTheme => _readController.readerTheme;

  Color? get _background => _readTheme.value.background;

  Color? get _fontColor => _readTheme.value.fontColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold.dialog(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: _background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colours.black26,
                      offset: Offset(0, -10),
                      blurRadius: 20,
                    ),
                  ],
                ),
                height: 380,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 60,
                      child: Stack(
                        children: [
                          Center(
                            child: Text(Ids.font.tr, style: TextStyle(fontSize: 20, color: _fontColor)),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _readController.importFont,
                              child: Text(Ids.importFont.tr),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: MediaQuery.removePadding(
                        removeBottom: true,
                        removeTop: true,
                        context: context,
                        child: FutureBuilder<List<FontEg>>(
                          future: _readController.queryFonts(),
                          builder: (_, snapShot) {
                            List<FontEg>? _fonts = snapShot.data;
                            return GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                              itemBuilder: (_, index) {
                                FontEg _font = _fonts![index];
                                return _fontItemBuilder(_font);
                              },
                              itemCount: _fonts?.length ?? 0,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _fontItemBuilder(FontEg font) {
    return GestureDetector(
      onTap: () {
        _readTheme.update((val) {
          val!.font = font;
          if (!TextUtil.isEmpty(font.importPath)) {
            FontUtil.loadFontFromFile(font);
          }
        });

        NavigatorUtil.pop();
      },
      child: Container(
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: _readTheme.value.font == font ? Border.all(color: Colors.black.withOpacity(0.4), width: 1.5) : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          font.title ?? '',
          style: TextStyle(
            fontFamily: font.fontFamily,
            fontSize: 20,
            color: _fontColor,
          ),
        ),
      ),
    );
  }
}
