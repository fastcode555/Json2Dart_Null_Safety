import 'package:book_reader/common/model/book_model.dart';
import 'package:book_reader/page/page_reader.dart';
import 'package:book_reader/res/index.dart';
import 'package:flutter/material.dart';

/// @date 26/4/22
/// describe:

class BookshelfWidget extends StatefulWidget {
  final List<BookModel>? books;
  final bool isEdit;
  final ValueChanged<BookModel>? deleteCallback;

  const BookshelfWidget({
    Key? key,
    this.books,
    this.isEdit = false,
    this.deleteCallback,
  }) : super(key: key);

  @override
  _BookshelfWidgetState createState() => _BookshelfWidgetState();
}

class _BookshelfWidgetState extends State<BookshelfWidget> {
  var _crossAxisCount = 3;
  var _bookShelfCount = 0;
  double _itemWidth = 95;
  double _padding = 12.0;
  List<BookModel>? _books;

  @override
  void initState() {
    super.initState();
    _iniProperties();
  }

  @override
  void didUpdateWidget(covariant BookshelfWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _iniProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemBuilder: (_, index) {
            var isLast = index == _bookShelfCount - 1;
            int lastIndex = isLast ? _books!.length : (index + 1) * _crossAxisCount;
            List<BookModel> _bookShelfBook = _books!.sublist(index * _crossAxisCount, lastIndex);
            return _BookShelf(
              _bookShelfBook,
              _padding,
              _itemWidth,
              widget.isEdit,
              deleteCallback: widget.deleteCallback,
            );
          },
          itemCount: _bookShelfCount,
        ),
      ],
    );
  }

  void _iniProperties() {
    if (GetPlatform.isMobile) {
      _crossAxisCount = 3;
      _itemWidth = (Get.width - _padding * (_crossAxisCount - 1) - 60) / _crossAxisCount;
    } else {
      _padding = 12.0;
      _crossAxisCount = Get.width ~/ (_itemWidth + _padding);
      _padding = (Get.width - 60 - _crossAxisCount * _itemWidth) / (_crossAxisCount - 1);
    }
    _books = widget.books;
    //计算书架的个数
    int _count() {
      var _left = _books!.length % _crossAxisCount;
      int count = _books!.length ~/ _crossAxisCount;
      return _left > 0 ? count + 1 : count;
    }

    _bookShelfCount = (_books == null || _books!.isEmpty) ? 0 : _count();
  }
}

class _BookShelf extends StatelessWidget {
  List<BookModel> books;
  double padding;
  double _itemWidth;
  bool isEdit;
  final ValueChanged<BookModel>? deleteCallback;

  _BookShelf(
    this.books,
    this.padding,
    this._itemWidth,
    this.isEdit, {
    this.deleteCallback,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgets = [];
    for (int i = 0; i < books.length; i++) {
      BookModel _book = books[i];
      late Widget _childWidget;
      if (TextUtil.isEmpty(_book.cover)) {
        _childWidget = Container(
          alignment: Alignment.centerRight,
          height: 145,
          width: _itemWidth,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blueGrey,
          ),
          child: Text(
            _book.title ?? _book.path ?? "",
            style: const TextStyle(color: Colors.white),
          ),
        );
      }

      if (isEdit) {
        _widgets.add(
          SizedBox(
            width: _itemWidth,
            height: 145.0,
            child: Stack(
              children: [
                _childWidget,
                Container(
                  width: _itemWidth,
                  height: 145.0,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: const Icon(Icons.delete_forever_outlined, color: Colors.white, size: 30),
                    onPressed: () {
                      deleteCallback?.call(_book);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      } else {
        _widgets.add(
          GestureDetector(
            onTap: () {
              NavigatorUtil.pushName(PageReader.routeName, arguments: _book);
            },
            child: _childWidget,
          ),
        );
      }
      if (i != books.length - 1 && padding > 0) {
        _widgets.add(SizedBox(width: padding));
      }
    }
    return SizedBox(
      height: 190,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            bottom: 30,
            child: Container(
              width: Get.width,
              alignment: Alignment.center,
              decoration: const BoxDecoration(boxShadow: ResShadow.blackShadow),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PinSvg(
                    R.icBookShelfTop,
                    width: Get.width - 30,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    decoration: ResDecor.decor18,
                    height: 10,
                    width: Get.width - 30,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 145,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _widgets,
            ),
          ),
        ],
      ),
    );
  }
}
