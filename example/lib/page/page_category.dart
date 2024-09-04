import 'package:flutter/material.dart';
import 'package:gesound/common/model/category_model.dart';
import 'package:gesound/common/utils/navigator_util.dart';
import 'package:gesound/res/index.dart';
import 'package:gesound/res/strings.dart';
import 'package:gesound/widgets/buttons.dart';
import 'package:gesound/widgets/dialog/dialog_toast_util.dart';
import 'package:get/get.dart';

import 'controller/category_controller.dart';
import 'controller/database_controller.dart';

class PageCategory extends StatefulWidget {
  static const String routeName = "/page/PageCategory";

  const PageCategory({Key? key}) : super(key: key);

  @override
  _PageCategoryState createState() => _PageCategoryState();
}

class _PageCategoryState extends State<PageCategory> {
  bool _isEdit = false;
  DataBaseController controller = Get.find<DataBaseController>();
  final CategoryController _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      titleId: Ids.allCategories,
      leading: const IconButton(
        onPressed: NavigatorUtil.pop,
        icon: PinSvg(R.icWhiteClose, color: Colours.white, size: 16.0),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _isEdit = !_isEdit;
            });
          },
          child: Text((_isEdit ? Ids.done : Ids.edit).tr, style: TextStyles.ff4adedeW50018),
        )
      ],
      body: Column(
        children: [
          InkWell(
            onTap: showNewCategoryDialog,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const PinSvg(R.icGreenAdd, color: Colours.mainColor, size: 20.0),
                  const SizedBox(width: 12),
                  Text(Ids.createANewCategory.tr, style: TextStyles.ff4adedeW50016),
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildGridView(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return Obx(
      () {
        List<CategoryModel> _categories = controller.categoriesObs.value;
        if (_categories.isEmpty) return const SizedBox();
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 2.1,
          ),
          itemBuilder: (_, index) => _CategoryItem(
            _categories[index],
            controller: _categoryController,
            isEdit: _isEdit,
          ),
          itemCount: _categories.length,
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryModel model;
  final CategoryController controller;
  final bool isEdit;

  const _CategoryItem(
    this.model, {
    required this.controller,
    this.isEdit = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _name = model.finalName;
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          child: FillButton(
            _name,
            onPressed: () => controller.handleRename(model, _name, isEdit),
          ),
        ),
        if (model.categoryId != 0 && model.categoryId != 1 && isEdit)
          GestureDetector(
            onTap: () => controller.deleteCategory(model),
            child: const PinSvg(R.icCategoryClose, size: 15.0),
          ),
      ],
    );
  }
}
