/// @date 1/6/22
/// describe:
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:gesound/common/model/category_model.dart';
import 'package:gesound/common/model/playlist_model.dart';
import 'package:gesound/database/audio_model_dao.dart';
import 'package:gesound/database/category_model_dao.dart';
import 'package:gesound/database/db_manager.dart';
import 'package:gesound/database/playlist_model_dao.dart';
import 'package:gesound/res/strings.dart';
import 'package:gesound/widgets/dialog/dialog_toast_util.dart';
import 'package:get/get.dart';

class DataBaseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataBaseController>(() => DataBaseController());
  }
}

class DataBaseController extends GetxController {
  final RxList<CategoryModel> categoriesObs = <CategoryModel>[].obs;

  CategoryModelDao get _categoryDao => DbManager.instance.categoryModelDao;

  PlaylistModelDao get _playlistDao => DbManager.instance.playlistModelDao;

  AudioModelDao get _audioDao => DbManager.instance.audioModelDao;

  ///查询所有的分类
  Future<List<CategoryModel>> queryCategories() async {
    if (categoriesObs.isNotEmpty) return categoriesObs.value;
    List<CategoryModel>? _categories;
    try {
      _categories = await _categoryDao.queryAll();
    } catch (e) {
      debugPrint(e.toString());
    }
    if (_categories == null) {
      _categories = [CategoryModel.music(), CategoryModel.novel()];
      _categoryDao.insertAll(_categories);
    }
    categoriesObs.value = _categories;
    return _categories;
  }

  ///获取生成默认的playlist name
  String getDefaultPlaylistModelName(CategoryModel model) {
    List<PlaylistModel>? _playlist = model.playlists;
    String name = Ids.playlist.tr;
    if (_playlist == null || _playlist.isEmpty) return "${name}01";
    int maxValue = 1;
    for (PlaylistModel list in _playlist) {
      if (list.name?.startsWith(name) ?? false) {
        String digit = list.name!.replaceAll(name, "");
        maxValue = math.max(maxValue, int.parse(digit));
      }
    }
    maxValue++;
    String stringDigit = maxValue < 10 ? "0$maxValue" : "$maxValue";
    return "$name$stringDigit";
  }

  ///获取默认的分类名
  String getDefaultCategoryName() {
    List<CategoryModel>? _categories = categoriesObs.value;
    String name = Ids.category.tr;
    if (_categories.isEmpty) return "${name}01";
    int maxValue = 0;
    for (CategoryModel list in _categories) {
      if (list.name?.startsWith(name) ?? false) {
        String digit = list.name!.replaceAll(name, "");
        maxValue = math.max(maxValue, int.parse(digit));
      }
    }
    maxValue++;
    String stringDigit = maxValue < 10 ? "0$maxValue" : "$maxValue";
    return "$name$stringDigit";
  }

  //删除分类
  void deleteCategory(CategoryModel model) {
    //该分类没有playlist，直接删除
    if ((model.playlistIds?.length ?? 0) <= 0) {
      categoriesObs.remove(model);
      _categoryDao.delete(model);
      return;
    }
    showDeleteCategoryConfirmDialog(
      model: model,
      rightCallBack: () {
        categoriesObs.remove(model);
        _categoryDao.delete(model);
        model.playlists?.forEach((element) {
          _playlistDao.delete(element);
        });
      },
    );
  }

  ///查询该分类下的所有的播放列表
  Future<List<PlaylistModel>> queryPlaylist(CategoryModel model) async {
    List<PlaylistModel> _playlists = await _playlistDao.queryMultiIds(model.playlistIds);
    return _playlists;
  }

  ///sort playlist
  void sort(List<PlaylistModel>? playlists) {
    playlists?.sort(
      (a, b) {
        if (a.isPin! && b.isPin!) {
          if (a.index > b.index) {
            return 1;
          }
          return -1;
        }
        if (a.isPin! && !b.isPin!) {
          return -1;
        }
        if (b.isPin! && !a.isPin!) {
          return 1;
        }
        if (a.index > b.index) {
          return 1;
        }
        return -1;
      },
    );
  }

  //拖动排序列表
  void onRecorder(int oldIndex, int newIndex, List<PlaylistModel> platLists) {
    int _newIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    //同时为置顶或者同时不为置顶，才能重新排序成功
    PlaylistModel _oldOne = platLists[oldIndex];
    PlaylistModel _newOne = platLists[_newIndex];
    if (_oldOne.isPin == _newOne.isPin) {
      List<int> _indexs = [];
      for (PlaylistModel model in platLists) {
        _indexs.add(model.index);
      }
      platLists.remove(_oldOne);
      if (_newIndex < platLists.length - 1) {
        platLists.insert(_newIndex, _oldOne);
      } else {
        platLists.add(_oldOne);
      }
      for (int i = 0; i < platLists.length; i++) {
        PlaylistModel model = platLists[i];
        model.position = _indexs[i];
        DbManager.instance.playlistModelDao.update(model);
      }
    }
  }
}
