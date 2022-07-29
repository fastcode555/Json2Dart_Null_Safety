import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/database/db_manager.dart';
import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/page/widgets/empty_widget.dart';
import 'package:book_reader/res/index.dart';
import 'package:book_reader/res/strings.dart';
import 'package:book_reader/widgets/book_shelf_widget.dart';
import 'package:flutter/material.dart';

import '../res/strings.dart';

class PageBookShelf extends StatefulWidget {
  static const String routeName = "/page/PageBookShelf";

  const PageBookShelf({Key? key}) : super(key: key);

  @override
  _PageBookShelfState createState() => _PageBookShelfState();
}

class _PageBookShelfState extends State<PageBookShelf> {
  ReaderController controller = Get.find<ReaderController>();
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    controller.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.white,
      titleId: Ids.bookshelf,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () => setState(() {}),
          icon: const Icon(Icons.refresh, color: Colours.ff323232),
        ),
        IconButton(
          onPressed: controller.importBook,
          icon: const Icon(Icons.add, color: Colours.ff323232),
        ),
        _buildEditWidget(),
      ],
      body: Obx(
        () {
          List<BookModel> books = controller.bookModels.value;
          if (books.isEmpty) {
            return EmptyWidget(onPressed: controller.importBook);
          }
          return BookshelfWidget(
            books: books,
            isEdit: _isEdit,
            deleteCallback: (book) {
              DbManager.instance.bookModelDao.delete(book);
              controller.bookModels.remove(book);
              if (controller.bookModels.value.isEmpty) {
                _deleteBook();
              }
            },
          );
        },
      ),
    );
  }

  void _deleteBook() {
    setState(() {
      _isEdit = !_isEdit;
    });
  }

  Widget _buildEditWidget() {
    if (_isEdit) {
      return TextButton(onPressed: _deleteBook, child: Text(Ids.finish.tr));
    } else {
      return IconButton(
        onPressed: _deleteBook,
        icon: const Icon(Icons.edit, color: Colours.ff323232, size: 20),
      );
    }
  }
}
