<!-- 简体中文 -->
# json2dart 使用指南

[English](guide_en.md) | [Deutsch](guide_de.md) | [Português](guide_pt.md) | [日本語](guide_ja.md) | [한국어](guide_ko.md) | 简体中文

## 一、功能概述

json2dart是一个Flutter插件集合，主要提供以下功能：

1. JSON转Dart模型
   - 支持空安全
   - 支持多字段解析
   - 类型安全转换
   - 默认值处理

2. SQLite数据库操作
   - 自动创建表结构
   - 完整的CRUD操作
   - 复杂类型支持
   - 批量操作支持

3. 数据库可视化调试
   - 查看所有数据表
   - 查看表结构
   - 查看表数据
   - SQL语句高亮

## 二、安装配置

### 1. 添加依赖

```yaml
dependencies:
  # JSON解析基础包
  json2dart_safe: ^1.6.0
  
  # 数据库支持(二选一)
  json2dart_db: ^latest_version    # 普通版
  json2dart_dbffi: ^latest_version # FFI版(性能更好)
  
  # 数据库查看工具(二选一) 
  json2dart_viewer: ^latest_version    # 普通版
  json2dart_viewerffi: ^latest_version # FFI版
```

### 2. 调试工具配置

需要配合flutter_ume使用:

```dart
import 'package:json2dart_viewerffi/json2dart_viewerffi.dart';

void main() {
  PluginManager.instance
    ..register(const DBViewer()) // 注册数据库查看插件
    // ... 其他插件注册
}
```

## 三、基础用法

### 1. JSON解析

```dart
// 从Map解析
Map json = {...};
json.asString("key");     // 获取String,为空返回""
json.asInt("key");        // 获取int,为空返回0
json.asDouble("key");     // 获取double,为空返回0.0
json.asBool("key");       // 获取bool,为空返回false
json.asBean<T>("key");    // 解析对象
json.asList<T>("key");    // 解析数组

// 多字段解析
json.asStrings(["name", "user_name"]); // 依次尝试解析name和user_name
json.asInts(["id", "user_id"]);
json.asBools(["is_vip", "vip"]);
```

### 2. 错误处理

```dart
// 添加错误回调
Json2Dart.instance.addCallback((String error) {
  print("解析错误: $error");
});

// 详细错误信息
Json2Dart.instance.addDetailCallback((String method, String key, Map? map) {
  print("方法:$method, 键:$key, 数据:$map");
});
```

## 四、使用场景

### 1. 仅使用JSON解析功能

如果只需要JSON解析功能，只需要添加基础包:

```yaml
dependencies:
  json2dart_safe: ^1.6.0
```

示例Model:

```dart
import 'package:json2dart_safe/json2dart.dart';

class UserModel {
  final String? username;
  final String? nickname;
  final int? age;
  final List<String>? hobbies;

  UserModel({
    this.username,
    this.nickname,
    this.age,
    this.hobbies,
  });

  // JSON序列化
  Map<String, dynamic> toJson() => {
    'username': username,
    'nickname': nickname,
    'age': age,
    'hobbies': hobbies,
  };

  // JSON反序列化
  factory UserModel.fromJson(Map json) {
    return UserModel(
      username: json.asString('username'),
      nickname: json.asString('nickname'),
      age: json.asInt('age'),
      hobbies: json.asList<String>('hobbies'),
    );
  }
}
```

使用示例:

```dart
// 解析JSON
Map<String, dynamic> json = {
  'username': 'test',
  'age': 18,
  'hobbies': ['读书', '游戏']
};
var user = UserModel.fromJson(json);

// 转换为JSON
Map<String, dynamic> data = user.toJson();
```

### 2. 使用数据库功能

如果需要数据库支持，需要添加完整依赖:

```yaml
dependencies:
  json2dart_safe: ^1.6.0
  json2dart_db: ^latest_version
  json2dart_viewer: ^latest_version
```

此时需要:
1. Model类继承BaseDbModel
2. 实现primaryKeyAndValue方法
3. 创建对应的Dao类

完整示例见下一章节。

## 五、完整示例

### 1. 模型定义 (user_model.dart)

```dart
import 'dart:convert';
import 'package:json2dart_safe/json2dart.dart';

/// 用户信息模型
class UserModel with BaseDbModel {
  // 数据库主键,自增
  int? userId;
  
  // 基础字段
  String? username;
  String? nickname;
  String? avatar;
  int? age;
  double? height;
  bool? isVip;
  DateTime? birthday;
  
  // 复杂类型
  List<String>? hobbies;        // 爱好列表 
  List<int>? followingIds;      // 关注的用户ID
  Map<String, dynamic>? extra;   // 扩展字段
  
  // 构造函数
  UserModel({
    this.userId,
    this.username,
    this.nickname,
    this.avatar,
    this.age,
    this.height,
    this.isVip,
    this.birthday,
    this.hobbies,
    this.followingIds,
    this.extra,
  });

  // JSON序列化
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'username': username,
    'nickname': nickname,
    'avatar': avatar,
    'age': age,
    'height': height,
    'is_vip': isVip,
    'birthday': birthday?.millisecondsSinceEpoch,
    'hobbies': hobbies,
    'following_ids': followingIds,
    'extra': extra,
  };

  // JSON反序列化 
  factory UserModel.fromJson(Map json) {
    return UserModel(
      userId: json.asInt('user_id'),
      username: json.asString('username'),
      nickname: json.asString('nickname'), 
      avatar: json.asString('avatar'),
      age: json.asInt('age'),
      height: json.asDouble('height'),
      isVip: json.asBool('is_vip'),
      birthday: json.asInt('birthday') != null 
          ? DateTime.fromMillisecondsSinceEpoch(json.asInt('birthday'))
          : null,
      hobbies: json.asList<String>('hobbies'),
      followingIds: json.asList<int>('following_ids'),
      extra: json.asMap('extra'),
    );
  }

  // 用于数据库操作的静态方法
  static UserModel toBean(Map json) => UserModel.fromJson(json);

  // 重写toString方法,方便调试
  @override
  String toString() => jsonEncode(toJson());

  // 重写相等运算符
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;

  // 实现BaseDbModel的方法,返回主键和值
  @override
  Map<String, dynamic> get primaryKeyAndValue => {'user_id': userId};
}
```

### 2. 数据库操作类 (user_dao.dart)

```dart
import 'package:json2dart_db/database/base_dao.dart';
import '../models/user_model.dart';

class UserDao extends BaseDao<UserModel> {
  UserDao() : super('tb_user', UserModel.toBean);

  // 根据用户名查询
  Future<UserModel?> queryByUsername(String username) async {
    List<UserModel> users = await query(
      where: 'username = ?',
      whereArgs: [username],
    );
    return users.isEmpty ? null : users.first;
  }

  // 查询VIP用户
  Future<List<UserModel>> queryVipUsers() async {
    return query(
      where: 'is_vip = ?',
      whereArgs: [1],
      orderBy: 'user_id DESC',
    );
  }

  // 更新用户VIP状态
  Future<bool> updateVipStatus(int userId, bool isVip) async {
    int count = await update(
      {'is_vip': isVip ? 1 : 0},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  // 批量更新关注状态
  Future<void> updateFollowingIds(int userId, List<int> followingIds) async {
    await update(
      {'following_ids': followingIds},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
```

### 3. 使用示例 (user_page.dart)

```dart
import '../database/dao/user_dao.dart';
import '../models/user_model.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserDao _userDao = UserDao();

  Future<void> _addUser() async {
    // 创建用户
    var user = UserModel(
      username: 'test_user',
      nickname: '测试用户',
      age: 18,
      isVip: false,
      hobbies: ['读书', '游戏'],
      followingIds: [1, 2, 3],
      extra: {'score': 100},
    );
    
    // 插入数据库
    int userId = await _userDao.insert(user);
    print('插入成功,用户ID: $userId');
    
    // 查询用户
    UserModel? dbUser = await _userDao.queryOne(userId);
    print('查询结果: $dbUser');
    
    // 更新VIP状态
    await _userDao.updateVipStatus(userId, true);
    
    // 更新关注列表
    await _userDao.updateFollowingIds(userId, [4, 5, 6]);
    
    // 查询所有VIP用户
    List<UserModel> vipUsers = await _userDao.queryVipUsers();
    print('VIP用户数: ${vipUsers.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('用户管理')),
      body: Center(
        child: ElevatedButton(
          onPressed: _addUser,
          child: Text('添加测试用户'),
        ),
      ),
    );
  }
}
```

## 六、数据库表结构

上述Model会自动生成如下表结构:

```sql
CREATE TABLE IF NOT EXISTS tb_user (
  user_id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT,
  nickname TEXT,
  avatar TEXT,
  age INTEGER,
  height REAL,
  is_vip INTEGER,
  birthday INTEGER,
  hobbies TEXT,  -- List类型会自动转换为JSON字符串存储
  following_ids TEXT, -- List类型会自动转换为JSON字符串存储
  extra TEXT -- Map类型会自动转换为JSON字符串存储
)
```

主要特点:

1. 支持常用数据类型:
   - INTEGER: int类型
   - REAL: double类型
   - TEXT: String类型
   - INTEGER: bool类型(0/1)

2. 复杂类型处理:
   - List、Map等类型会自动转换为JSON字符串存储
   - 读取时自动解析回原始类型
   - 无需手动编写类型转换器

3. 主键配置:
   - 使用user_id作为主键
   - 设置为自增长
   - 通过primaryKeyAndValue方法指定

## 七、注意事项

1. 数据库相关:
   - 数据库升级时需要手动添加新字段
   - 复杂类型会占用更多存储空间
   - 建议在Debug模式下使用调试工具
   - FFI版本性能更好但需要额外配置

2. 类型安全:
   - 所有字段建议使用可空类型
   - JSON解析时会进行类型检查
   - 数据库操作时会进行类型转换

3. 性能优化:
   - 避免存储过大的复杂类型
   - 合理设计表结构和索引
   - 批量操作时使用事务

## 八、示例项目

完整示例可参考:
- [BookReader](https://github.com/fastcode555/book_reader)
- [Example](https://github.com/fastcode555/Json2Dart_Null_Safety/tree/develop_database/example) 