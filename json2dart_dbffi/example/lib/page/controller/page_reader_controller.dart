import 'dart:io';

import 'package:book_reader/common/application.dart';
import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/common/model/chapter.dart';
import 'package:book_reader/common/model/font_eg.dart';
import 'package:book_reader/common/utils/font_util.dart';
import 'package:book_reader/common/utils/loading_util.dart';
import 'package:book_reader/common/utils/local_parser.dart';
import 'package:book_reader/database/db_manager.dart';
import 'package:book_reader/res/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class ReaderBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReaderController>(() => ReaderController());
  }
}

class ReaderController extends GetxController {
  //当前阅读的主题
  final readerTheme = Application.instance.getReaderTheme.obs;

  //当前加载的章节
  final chapters = <Chapter>[].obs;

  //当前加载的书籍
  final bookModels = <BookModel>[].obs;

  //当前阅读到的章节的角标
  final currentChapter = Chapter().obs;

  //控制面板是否关闭
  final isPanelClose = true.obs;

  //当前查询的角标
  int _offset = 0;

  int get offset => _offset;

  //当前阅读的书籍
  BookModel? _bookModel;

  ///保存阅读主题
  void save() {
    Application.instance.saveTheme(readerTheme.value);
  }

  ///读取章节内容
  Future<String> readContent(BookModel bookModel) async {
    String tableName = "chapter_${bookModel.md5Id}";
    int startTime = DateTime.now().millisecondsSinceEpoch;
    int count = await DbManager.instance.chapterDao.queryCount(tableName);
    double time = (DateTime.now().millisecondsSinceEpoch - startTime) / 1000;
    debugPrint("读取所有章节数量耗时：$time s,章节数量:$count");
    Chapter? _chapter = await DbManager.instance.chapterDao.queryOne(5, tableName);
    return _chapter?.content ?? "";
  }

  ///选择字体，并导入
  Future<void> importFont() async {
    FilePicker.platform.pickFiles().then(
      (value) async {
        if (value == null || value.files.isEmpty) return;
        PlatformFile _platFile = value.files.first;
        Directory directory = await FileUtils.getAppDirectory();
        //创建字体的文件夹
        Directory _fontDir = Directory("${directory.path}fonts/");
        if (!_fontDir.existsSync()) {
          _fontDir.createSync();
        }

        File _newFile = File("${_fontDir.path}${_platFile.name}");
        File _selectFile = File(_platFile.path!);
        await _selectFile.copy(_newFile.path);

        readerTheme.update((val) {
          val!.font = FontEg(
            basenameWithoutExtension(_platFile.name),
            basenameWithoutExtension(_platFile.name),
            importPath: _newFile.path,
          );
          FontUtil.loadFontFromFile(val.font!);
          DbManager.instance.fontEgDao.insert(val.font!);
        });
      },
    );
  }

  ///查询导入的所有字体
  Future<List<FontEg>>? queryFonts() async {
    List<FontEg> fonts = [];
    fonts.addAll(FontEg.fonts);
    List<FontEg>? _datasFonts = await DbManager.instance.fontEgDao.queryAll();
    if (_datasFonts != null && _datasFonts.isNotEmpty) {
      fonts.addAll(_datasFonts);
    }
    return fonts;
  }

  ///章节查询,offset：查询起始角标，reverse：角标向前获取，即获取前面的章节
  Future<bool> queryChapters(
    BookModel? bookModel, {
    int? offset,
    bool reverse = false,
    int limit = 10,
  }) async {
    _bookModel = bookModel;

    if (_offset == 0 && reverse) return true;

    if (offset == null) {
      _offset = reverse ? _offset -= limit : _offset += limit;
      _offset = _offset < 0 ? 0 : _offset;
    } else {
      _offset = offset;
    }
    List<Chapter>? dbChapters = await DbManager.instance.chapterDao.query(
      tableName: "chapter_${bookModel?.md5Id}",
      offset: _offset,
      limit: limit,
    );

    if (dbChapters == null || dbChapters.isEmpty) return false;
    if (reverse) {
      chapters.insertAll(0, dbChapters);
    } else {
      chapters.addAll(dbChapters);
    }
    return true;
  }

  ///调用文件选择器，挑选文件
  void importBook() {
    Future<FilePickerResult?> result = FilePicker.platform.pickFiles();
    result.then((value) async {
      //选择文件后，并进行章节分割
      if (value != null && value.count > 0) {
        PlatformFile _platformFile = value.files.first;
        LocalParser parser = LocalParser(_platformFile.path);
        LoadingUtil.show();
        int startTime = DateTime.now().millisecondsSinceEpoch;
        parser.parse().then((value) {
          DbManager.instance.bookModelDao.insert(value);
          if (!bookModels.contains(value)) {
            bookModels.add(value);
            bookModels.refresh();
          }
          double time = (DateTime.now().millisecondsSinceEpoch - startTime) / 1000;
          debugPrint("执行耗时时间：$time s");
          LoadingUtil.dismiss();
        });
      }
    });
  }

  ///获取数据库表中所有的书籍
  Future<List<BookModel>> getBooks([bool? forceUpdate]) async {
    if (bookModels.isNotEmpty && forceUpdate == null) return bookModels.value;
    if (forceUpdate != null && forceUpdate || bookModels.isEmpty) {
      List<BookModel>? _books = await DbManager.instance.bookModelDao.queryAll();
      bookModels.clear();
      if (_books != null && _books.isNotEmpty) {
        bookModels.addAll(_books);
      }
    }
    return bookModels.value;
  }

  //滚动到指定章节
  void scroll2Target(int selectedItem) {
    chapters.clear();
    queryChapters(_bookModel, offset: selectedItem);
  }

  //根据当前章节获取章节所在角标
  int getChapterIndex(Chapter? chapter) {
    if (_bookModel == null || chapter == null) return 0;
    int index = _bookModel!.chapter!.indexOf(chapter);
    return index < 0 ? 0 : index;
  }

  void clear() {
    chapters.clear();
    isPanelClose.value = true;
  }
}
