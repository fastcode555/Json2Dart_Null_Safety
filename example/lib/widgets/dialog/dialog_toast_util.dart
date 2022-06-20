import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:gesound/common/model/category_model.dart';
import 'package:gesound/common/model/playlist_model.dart';
import 'package:gesound/common/utils/navigator_util.dart';
import 'package:gesound/common/utils/string_ext.dart';
import 'package:gesound/database/db_manager.dart';
import 'package:gesound/res/index.dart';
import 'package:gesound/res/strings.dart';
import 'package:gesound/widgets/dialog/confirm_dialog.dart';
import 'package:gesound/widgets/dialog/edit_dialog.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../page/controller/database_controller.dart';

Future<T?> _showCommonDialog<T>({required WidgetBuilder builder}) async {
  final value = await showDialog<T>(context: Get.context!, builder: builder);
  return value;
}

void showRenameDialog({
  String? title,
  String? content,
  String? hintText,
  int maxLength = 20,
  ValueChanged<String>? onRightCallback,
  TextEditingController? controller,
}) {
  TextEditingController? _controller;

  controller?.text = '';
  if (!TextUtil.isEmpty(content)) {
    _controller = controller ?? TextEditingController();
    _controller.text = content ?? '';
  }
  _showCommonDialog(
    builder: (_) {
      return EditDialog(
        title ?? Ids.renamePlaylist.tr,
        hintText ?? "",
        onRightCallback: (v) {
          onRightCallback?.call(v);
        },
        maxLength: maxLength,
        controller: _controller,
      );
    },
  );
}

void showDeleteCategoryConfirmDialog({
  GestureTapCallback? rightCallBack,
  CategoryModel? model,
}) {
  _showCommonDialog(
    builder: (_) {
      return ConfirmDialog(
        Ids.areYouSure.tr,
        Ids.deleteCategoryConfirm.tr.formatter([
          model?.name ?? 'N',
          "${model?.playlistIds?.length ?? 0}",
        ]),
        height: 280.0,
        rightCallBack: rightCallBack,
      );
    },
  );
}

Future showDeletePlayList({GestureTapCallback? rightCallBack}) {
  return _showCommonDialog(
    builder: (_) {
      return ConfirmDialog(
        Ids.areYouSure.tr,
        Ids.deletePlaylistConfirm.tr,
        height: 200.0,
        rightCallBack: rightCallBack,
      );
    },
  );
}

Future showDeleteSong({GestureTapCallback? rightCallBack}) {
  return _showCommonDialog(
    builder: (_) {
      return ConfirmDialog(
        Ids.areYouSure.tr,
        Ids.deleteSongDescription.tr,
        height: 200.0,
        rightCallBack: rightCallBack,
      );
    },
  );
}

///创建一个playlist的列表
Future<PlaylistModel?> showCreateNewPlayList([CategoryModel? model]) async {
  String _playListName = Get.find<DataBaseController>().getDefaultPlaylistModelName(model!);
  return _showCommonDialog<PlaylistModel?>(
    builder: (_) {
      return EditDialog(
        Ids.createANewPlaylist.tr,
        _playListName,
        onRightCallback: (text) {
          String _name = TextUtil.isEmpty(text) ? _playListName : text;
          if (model.playlists != null && model.playlists!.isNotEmpty) {
            List<PlaylistModel>? _playlists = model.playlists;
            for (PlaylistModel model in _playlists!) {
              if (model.name == _name) {
                showFailToast(Ids.playlistNameAlreadyExists.tr);
                return;
              }
            }
          }
          //创建playlist
          PlaylistModel _model = PlaylistModel.empty(name: _name);
          DbManager.instance.playlistModelDao.insert(_model).then((value) {
            _model.playlistId = value;
            model.playlists ??= [];
            model.playlists!.add(_model);
            model.playlistIds ??= [];
            model.playlistIds?.add(value);
            //更新分类的数据
            DbManager.instance.categoryModelDao.update(model);
            showSuccessToast(Ids.createdSuccessfully.tr);
            NavigatorUtil.pop(result: _model);
          });
        },
      );
    },
  );
}

///创建一个新的分类名弹窗
void showNewCategoryDialog({String? hintText, ValueChanged<String>? onRightCallback}) {
  String _categoryName = Get.find<DataBaseController>().getDefaultCategoryName();
  _showCommonDialog(
    builder: (_) {
      return EditDialog(
        Ids.newCategory.tr,
        _categoryName,
        onRightCallback: (text) {
          DataBaseController _controller = Get.find<DataBaseController>();
          String _name = TextUtil.isEmpty(text) ? _categoryName : text;
          List<CategoryModel> _categories = _controller.categoriesObs.value;
          for (CategoryModel model in _categories) {
            if (model.name == _name) {
              showFailToast(Ids.theCategoryNameAlreadyExists.tr);
              return;
            }
          }
          CategoryModel _model = CategoryModel.empty(name: _name);
          DbManager.instance.categoryModelDao.insert(_model).then((value) {
            _model.categoryId = value;
            _controller.categoriesObs.add(_model);
            showSuccessToast(Ids.createdSuccessfully.tr);
            NavigatorUtil.pop();
          });
        },
      );
    },
  );
}

void showSuccessToast([String? text]) {
  showToastWidget(
    _ToastWidget(
      text ?? Ids.submitSuccessfully.tr,
      decoration: const BoxDecoration(
        color: Colours.ff103434,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        border: Border.fromBorderSide(BorderSide(width: 1.0, color: Colours.ff27dbd9)),
      ),
    ),
    position: ToastPosition.center,
    duration: const Duration(milliseconds: 1000),
  );
}

void showFailToast([String? text]) {
  showToastWidget(
    _ToastWidget(
      text ?? Ids.submitFailed.tr,
      decoration: const BoxDecoration(
        color: Colours.ff39a7a7,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        border: Border.fromBorderSide(BorderSide(width: 1.0, color: Colours.bottomBarColor)),
      ),
    ),
    position: ToastPosition.center,
    duration: const Duration(milliseconds: 1000),
  );
}

class _ToastWidget extends StatelessWidget {
  final String text;
  final Decoration? decoration;
  final double? width;
  final double? height;

  const _ToastWidget(
    this.text, {
    this.decoration,
    this.width,
    this.height = 68.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: height,
        width: Get.width - 80,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: decoration,
        alignment: Alignment.center,
        child: Text(text, style: TextStyles.RobotoWhiteW50020),
      ),
    );
  }
}
