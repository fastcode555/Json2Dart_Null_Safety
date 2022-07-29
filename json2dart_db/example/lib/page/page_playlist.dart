import 'package:flutter/material.dart';
import 'package:gesound/common/model/category_model.dart';
import 'package:gesound/common/model/playlist_model.dart';
import 'package:gesound/common/utils/navigator_util.dart';
import 'package:gesound/page/page_category.dart';
import 'package:gesound/page/page_playlist_detail.dart';
import 'package:gesound/res/index.dart';
import 'package:gesound/widgets/custom_tab_bar.dart';
import 'package:get/get.dart';

import '../res/strings.dart';
import 'controller/database_controller.dart';

class PagePlaylist extends StatefulWidget {
  static const String routeName = "/page/PagePlaylist";

  const PagePlaylist({Key? key}) : super(key: key);

  @override
  _PagePlaylistState createState() => _PagePlaylistState();
}

class _PagePlaylistState extends State<PagePlaylist> with TickerProviderStateMixin {
  TabController? _tabController;
  final DataBaseController _dbController = Get.find<DataBaseController>();

  //需要刷新移动后，Category中Playlist的列表
  final ValueNotifier<MapEntry<CategoryModel, PlaylistModel>?> _moveNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _dbController.queryCategories();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      automaticallyImplyLeading: false,
      titleId: Ids.playlist,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      List<CategoryModel> _categories = _dbController.categoriesObs.value;
      if (_categories.isEmpty) {
        return const SizedBox();
      }
      if (_tabController == null || _tabController?.length != _categories.length) {
        _tabController = TabController(length: _categories.length, vsync: this);
      }
      return Column(
        children: [
          CustomTabBar(
            _categories,
            controller: _tabController!,
            onTap: () => _handleActionMore(_categories),
          ),
          Expanded(
            child: TabBarView(
              children: _categories
                  .map(
                    (t) => PagePlaylistDetail(t),
                  )
                  .toList(),
              controller: _tabController,
            ),
          ),
        ],
      );
    });
  }

  void _handleActionMore(List<CategoryModel> categories) {
    NavigatorUtil.pushName(PageCategory.routeName)?.then((obj) {
      if (obj != null && obj is CategoryModel) {
        CategoryModel _choose = obj;
        int index = categories.indexOf(_choose);
        if (index >= 0) {
          _tabController!.index = index;
        }
      }
    });
  }
}
