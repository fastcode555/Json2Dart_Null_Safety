import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gesound/common/model/category_model.dart';
import 'package:gesound/common/model/playlist_model.dart';
import 'package:gesound/res/index.dart';
import 'package:gesound/widgets/dialog/dialog_toast_util.dart';
import 'package:gesound/widgets/new_playlist_widget.dart';
import 'package:gesound/widgets/playlist_item.dart';
import 'package:get/get.dart';

import 'controller/database_controller.dart';

/// @date 1/6/22
/// describe:
class PagePlaylistDetail extends StatefulWidget {
  final CategoryModel model;

  const PagePlaylistDetail(
    this.model, {
    Key? key,
  }) : super(key: key);

  @override
  _PagePlaylistDetailState createState() => _PagePlaylistDetailState();
}

class _PagePlaylistDetailState extends State<PagePlaylistDetail> with AutomaticKeepAliveClientMixin {
  final DataBaseController _controller = Get.find<DataBaseController>();

  List<PlaylistModel>? get _platLists => widget.model.playlists;

  @override
  void initState() {
    super.initState();
    //初始化，并且查询数据库
    if (widget.model.playlistIds == null || (widget.model.playlists?.isEmpty ?? true)) {
      _controller.queryPlaylist(widget.model).then((value) {
        widget.model.playlists ??= [];
        if (value.isNotEmpty) {
          widget.model.playlists!.addAll(value);
          _controller.sort(widget.model.playlists);
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildBody();
  }

  void _handleCreatePlayList() async {
    PlaylistModel? _playlist = await showCreateNewPlayList(widget.model);
    if (_playlist != null) {
      setState(() {});
    }
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildBody() {
    return ReorderableListView.builder(
      proxyDecorator: (child, index, animation) {
        return Container(
          color: Colours.ff103434,
          child: child,
        );
      },
      dragStartBehavior: DragStartBehavior.down,
      header: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          NewPlayListWidget(onTap: _handleCreatePlayList),
        ],
      ),
      itemBuilder: (_, index) {
        PlaylistModel _model = _platLists![index];
        return PlaylistItem(
          _model,
          widget.model,
          refreshCallBack: () => setState(() {}),
          key: ValueKey(index),
        );
      },
      itemCount: _platLists?.length ?? 0,
      onReorder: (o, n) => _controller.onRecorder(o, n, _platLists!),
    );
  }
}
