import 'package:flutter/material.dart';
import 'package:gesound/common/config/image_loader.dart';
import 'package:gesound/common/model/category_model.dart';
import 'package:gesound/common/model/playlist_model.dart';
import 'package:gesound/res/index.dart';
import 'package:gesound/res/strings.dart';
import 'package:gesound/widgets/widgets.dart';
import 'package:get/get.dart';

/// @date 31/5/22
/// describe:
class PlaylistItem extends StatefulWidget {
  final GestureTapCallback? onTap;
  final PlaylistModel model;
  final CategoryModel category;
  final VoidCallback? refreshCallBack;
  final TextEditingController? controller;

  const PlaylistItem(
    this.model,
    this.category, {
    this.onTap,
    this.refreshCallBack,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _PlaylistItemState createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<PlaylistItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: 70.0,
        padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
        child: Row(
          children: [
            ImageLoader.round(widget.model.cover, width: 50, radius: 4),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.model.isPin!)
                    Row(
                      children: [
                        const PinSvg(R.icPinFill, color: Colours.mainColor, angle: -0.7854, size: 11.0),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.model.name ?? "",
                            style: TextStyles.ff4adedeW50016,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  if (!(widget.model.isPin!))
                    Text(
                      widget.model.name ?? '',
                      style: TextStyles.whiteW50016,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  const SizedBox(height: 2),
                  Text(Ids.songs.tr, style: TextStyles.white12812),
                ],
              ),
            ),
            const MoreActionWidget(),
          ],
        ),
      ),
    );
  }

  ///重命名播放列表
}
