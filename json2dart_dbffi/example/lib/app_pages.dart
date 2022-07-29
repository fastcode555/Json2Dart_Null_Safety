import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/page/page_reader.dart';
import 'package:infinity_core/core.dart';

import 'debug_page.dart';
import 'page/page_book_shelf.dart';
import 'page/page_books.dart';
import 'page/page_splash.dart';

class AppPages {
  static const INITIAL = PageSplash.routeName;
  static final List<GetPage> routes = [
    _page(
      name: PageSplash.routeName,
      page: () => const PageSplash(),
    ),
    _page(
      name: PageBookShelf.routeName,
      binding: ReaderBinding(),
      page: () => const PageBookShelf(),
    ),
    _page(
      name: PageReader.routeName,
      page: () => PageReader(),
    ),
    _page(
      name: PageBooks.routeName,
      page: () => const PageBooks(),
    ),
    _page(
      name: DebugPage.routeName,
      page: () => const DebugPage(),
    ),
  ];

  static final unknownRoute = _page(
    name: PageSplash.routeName,
    page: () => const PageSplash(),
  );

  static GetPage _page({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    Transition? transition,
    CustomTransition? customTransition,
  }) {
    return GetPage(
      name: name,
      binding: binding,
      customTransition: customTransition,
      transition: transition ?? Transition.rightToLeft,
      page: () {
        Monitor.instance.putPage(name);
        return page();
      },
    );
  }
}
