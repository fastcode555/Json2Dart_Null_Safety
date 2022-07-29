/// @date 10/6/22
/// describe:
import 'package:gesound/common/model/category_model.dart';
import 'package:gesound/common/utils/navigator_util.dart';
import 'package:gesound/database/db_manager.dart';
import 'package:gesound/res/strings.dart';
import 'package:gesound/widgets/dialog/dialog_toast_util.dart';
import 'package:get/get.dart';

import 'database_controller.dart';

class CategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController());
  }
}

class CategoryController extends GetxController {
  DataBaseController controller = Get.find<DataBaseController>();

  void deleteCategory(CategoryModel model) {
    controller.deleteCategory(model);
  }

  handleRename(CategoryModel model, String name, bool isEdit) {
    if (model.categoryId != 0 && model.categoryId != 1 && isEdit) {
      showRenameDialog(
        title: Ids.editCategoryName.tr,
        hintText: model.name,
        content: model.name,
        onRightCallback: (text) {
          //判断名字是否存在
          List<CategoryModel> _categories = controller.categoriesObs.value;
          for (CategoryModel c in _categories) {
            if (c.name == text && c.categoryId != model.categoryId) {
              showFailToast(Ids.theCategoryNameAlreadyExists.tr);
              return;
            }
          }
          //名字一样，不需要进行任何操作
          if (name == text) {
            return;
          }
          //更新数据库,更新列表名字
          model.name = text;
          controller.categoriesObs.refresh();
          DbManager.instance.categoryModelDao.update(model);
          showSuccessToast(Ids.changeSucceeded.tr);
          NavigatorUtil.pop();
        },
      );
    }
    if (!isEdit) {
      NavigatorUtil.pop(result: model);
    }
  }
}
