# json2dart database 的数据库支持

## 一.模型以及表的生成

选择一个json模型，将模型复制到生成的插件中
![Alt](http://tva1.sinaimg.cn/large/e6c76645gy1h3fls4pxqlj20mj0kd3zj.jpg)
根据上方图片显示：

- **ClassName** 只需要下划线的文件名（会自动生成文件跟对应的模型的驼峰式名字）
- **勾选Sqlite Support**,然后可以在右方的输入框中输入primaryKey(Ps:primary key如果是json中已有的，只会有**PRIMARY KEY**
  的属性，如果是json数据中没有的，会根据输入的自动增加一个属性到model的模型类中，并带有**PRIMARY KEY** 跟**AUTOINCREMENT**)</br></br>
- json 模型可以选择lib下的任何目录，生成的模型会在选择的文件夹下，dao类的生成只会生成在**lib/database**的目录下，并在有新表时，自动插入生成语句到代码的方法中

### 1.下面简单演示一下生成：取一段json，如下

```json
{
  "name": "default",
  "playlist_count": "",
  "create_time": 0,
  "position": 1,
  "playlist_ids": [
    1
  ]
}
```

### 2.调用插件,生成的模型和dao类，分别如下

为了支持数据库以及更好的区分bean，会override以下三个方法

- **hashCode** 跟 **==**(equal) 方法
- 自动with基类（**BaseDbModel**,不使用extends，方便给其它基类继承)，实现**primaryKeyAndValue**

```dart
import 'dart:convert';

import 'package:json2dart_safe/json2dart.dart';

class CategoryDaoTest with BaseDbModel {
  String? playlistCount;
  List<int>? playlistIds;
  int? createTime;
  String? name;
  int? position;
  int? categoryId;

  CategoryDaoTest({
    this.playlistCount,
    this.playlistIds,
    this.createTime,
    this.name,
    this.position,
    this.categoryId,
  });

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{}
    ..put('playlist_count', playlistCount)
    ..put('playlist_ids', playlistIds)
    ..put('create_time', createTime)
    ..put('name', name)
    ..put('position', position)
    ..put('category_id', categoryId);

  CategoryDaoTest.fromJson(Map json) {
    playlistCount = json.asString('playlist_count');
    playlistIds = json.asList<int>('playlist_ids');
    createTime = json.asInt('create_time');
    name = json.asString('name');
    position = json.asInt('position');
    categoryId = json.asInt('category_id');
  }

  static CategoryDaoTest toBean(Map json) => CategoryDaoTest.fromJson(json);

  @override
  Map<String, dynamic> primaryKeyAndValue() => {"category_id": categoryId};

  @override
  int get hashCode => categoryId?.hashCode ?? super.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is CategoryDaoTest && categoryId != null) {
      return other.categoryId == categoryId;
    }
    return super == other;
  }

  @override
  String toString() => jsonEncode(toJson());
}

```

生成的dao类如下，目前可支持多表，但需要手动调用执行表生成的语句

```dart
import 'package:json2dart_safe/json2dart.dart';
import 'package:gesound/common/model/category_dao_test.dart';

class CategoryDaoTestDao extends BaseDao<CategoryDaoTest> {
  static const String _tableName = 'category_dao_test';

  CategoryDaoTestDao() : super(_tableName, 'category_id');

  static String tableSql([String? tableName]) => ""
      "CREATE TABLE IF NOT EXISTS `${tableName ?? _tableName}` ("
      "`playlist_count` TEXT,"
      "`playlist_ids` TEXT,"
      "`create_time` INTEGER,"
      "`name` TEXT,"
      "`position` INTEGER,"
      "`category_id` INTEGER PRIMARY KEY AUTOINCREMENT)";

  @override
  CategoryDaoTest fromJson(Map json) => CategoryDaoTest.fromJson(json);
}
```

## 结合json解析类，此类数据库具有的优点

### 1.无视复杂的数据类型

当模型中包含非常多复杂的类型时，比如模型中含有其它模型，<font color=blue>模型中含有数组之类的，存储是遇到这种数据会直接将数据转换成string进行存储</font>
， 取出时，取出时会 <font color=blue>判断是不是string，是的话尝试转换成Map将将其转换成正常数据</font>
</br></br>

相比用过floor或者其它数据,可能都遇到过：

- 提供额外的toDbMap的方法
- 取出数据时，因为复杂的类型bean或者list我们都会变成数据存储，取出时需要手动判断进行转换
- 如果是复杂类型的，可能会直接用floor的**TypeConverters**，手动实现转换，如果存在非常多的复杂类型，可能处理起来就麻烦得多了

<font color=red>相比上面这些，结合json使用的数据库除了生成的代码以外，几乎不需要担心类型和其它代码的编写,其它的查询操作只需要在dao类中增加新的查询方法即可
</font>

- 该类含有List或其它bean类时，会自动转换成string，存入对应字段，无需进行额外转换,取出时自动判断并成功解析
- 数据库存入bool值，取出为0或1，结合解析类，仍然支持取出的值为bool值
- 如果只是常用的方法，几乎不需要做任何代码的编写，如果根据业务类型需要，则可在dao类中复写或者增加方法。

## BaseDao目前有的方法

一些普通的数据库方法都都已经通过BaseDao类进行实现了

### 1.查询方法

- query 调用现有sqlite封装好的方法返回查询到的数据
- queryOne 支持根据id查询一个对象返回
- queryAll 查询该表所有数据
- queryCount 查询该表的总数
- rawQuery 调用sql语句，返回查询结果
- random 随机从表中取一个数据
- randoms 随机从表中查询一组数据

### 2.插入方法

- insert 插入一个普通的模型
- insertAll 插入所有模型
- insertMap 插入map数据

### 其它方法

- update 更新数据
- delete 删除数据
- execute 执行sql语句进行操作
- clear 清空表数据
- drop 删除表

## [具体demo可点击参考](https://github.com/fastcode555/Json2Dart_Null_Safety/tree/develop_database/example)

## PS:

1.~~尚未支持migiration，查看floor源码，只是在onUpgrade中增加old version跟new version的判断，然后根据业务进行字段的表的扩增~~,已经支持对单个表进行升级，同个模型的分表暂不支持
2.floor命令行有watch的功能，可支持表重新生成，不支持此类功能，需使用者手动为表加字段