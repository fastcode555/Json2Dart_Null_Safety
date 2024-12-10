# json2dart ガイド

[English](guide_en.md) | [简体中文](guide_cn.md) | [Deutsch](guide_de.md) | [Português](guide_pt.md) | 日本語

## I. 概要

json2dartは以下の機能を提供するFlutterプラグインコレクションです：

1. JSONからDartモデルへの変換
   - Nullセーフティのサポート
   - マルチフィールドパース
   - 型安全な変換
   - デフォルト値の処理

2. SQLiteデータベース操作
   - テーブル構造の自動生成
   - 完全なCRUD操作
   - 複雑な型のサポート
   - バッチ操作のサポート

3. データベース可視化デバッグ
   - 全テーブルの表示
   - テーブル構造の表示
   - テーブルデータの表示
   - SQLステートメントのハイライト

## II. インストール

### 1. 依存関係の追加

```yaml
dependencies:
  # JSON解析基本パッケージ
  json2dart_safe: ^1.6.0
  
  # データベースサポート（いずれかを選択）
  json2dart_db: ^latest_version    # 標準バージョン
  json2dart_dbffi: ^latest_version # FFIバージョン（パフォーマンス向上）
  
  # データベースビューワーツール（いずれかを選択）
  json2dart_viewer: ^latest_version    # 標準バージョン
  json2dart_viewerffi: ^latest_version # FFIバージョン
```

### 2. デバッグツールの設定

flutter_umeが必要です：

```dart
import 'package:json2dart_viewerffi/json2dart_viewerffi.dart';

void main() {
  PluginManager.instance
    ..register(const DBViewer()) // データベースビューワープラグインを登録
    // ... その他のプラグイン登録
}
```

## III. 基本的な使用方法

### 1. JSON解析

```dart
// Mapから解析
Map json = {...};
json.asString("key");     // String取得、nullの場合は""を返す
json.asInt("key");        // int取得、nullの場合は0を返す
json.asDouble("key");     // double取得、nullの場合は0.0を返す
json.asBool("key");       // bool取得、nullの場合はfalseを返す
json.asBean<T>("key");    // オブジェクト解析
json.asList<T>("key");    // 配列解析

// マルチフィールド解析
json.asStrings(["name", "user_name"]); // nameとuser_nameを順に解析
json.asInts(["id", "user_id"]);
json.asBools(["is_vip", "vip"]);
```

### 2. エラー処理

```dart
// エラーコールバックの追加
Json2Dart.instance.addCallback((String error) {
  print("解析エラー: $error");
});

// 詳細なエラー情報
Json2Dart.instance.addDetailCallback((String method, String key, Map? map) {
  print("メソッド: $method, キー: $key, データ: $map");
});
```

## IV. 使用シナリオ

### 1. JSON解析のみ

JSON解析機能のみが必要な場合：

```yaml
dependencies:
  json2dart_safe: ^1.6.0
```

モデル例：

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

  // JSONシリアライズ
  Map<String, dynamic> toJson() => {
    'username': username,
    'nickname': nickname,
    'age': age,
    'hobbies': hobbies,
  };

  // JSONデシリアライズ
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

使用例：

```dart
// JSON解析
Map<String, dynamic> json = {
  'username': 'test',
  'age': 18,
  'hobbies': ['読書', 'ゲーム']
};
var user = UserModel.fromJson(json);

// JSONに変換
Map<String, dynamic> data = user.toJson();
```

### 2. データベースサポート付き

データベースサポートが必要な場合は、完全な依存関係を追加します：

```yaml
dependencies:
  json2dart_safe: ^1.6.0
  json2dart_db: ^latest_version
  json2dart_viewer: ^latest_version
```

この場合、以下が必要です：
1. ModelクラスにBaseDbModelをミックスイン
2. primaryKeyAndValueメソッドを実装
3. 対応するDaoクラスを作成

完全な例は次の章を参照してください。

## V. 完全な例

### 1. モデル定義 (user_model.dart)

```dart
import 'dart:convert';
import 'package:json2dart_safe/json2dart.dart';

/// ユーザー情報モデル
class UserModel with BaseDbModel {
  // データベース主キー、自動増分
  int? userId;
  
  // 基本フィールド
  String? username;
  String? nickname;
  String? avatar;
  int? age;
  double? height;
  bool? isVip;
  DateTime? birthday;
  
  // 複雑な型
  List<String>? hobbies;        // 趣味リスト
  List<int>? followingIds;      // フォロー中のユーザーID
  Map<String, dynamic>? extra;   // 拡張フィールド
  
  // コンストラクタ
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

  // JSONシリアライズ
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

  // JSONデシリアライズ
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

  // データベース操作用の静的メソッド
  static UserModel toBean(Map json) => UserModel.fromJson(json);

  // デバッグ用のtoString上書き
  @override
  String toString() => jsonEncode(toJson());

  // 等価演算子の上書き
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;

  // BaseDbModelメソッドの実装
  @override
  Map<String, dynamic> get primaryKeyAndValue => {'user_id': userId};
}
```

### 2. データベース操作クラス (user_dao.dart)

```dart
import 'package:json2dart_db/database/base_dao.dart';
import '../models/user_model.dart';

class UserDao extends BaseDao<UserModel> {
  UserDao() : super('tb_user', UserModel.toBean);

  // ユーザー名で検索
  Future<UserModel?> queryByUsername(String username) async {
    List<UserModel> users = await query(
      where: 'username = ?',
      whereArgs: [username],
    );
    return users.isEmpty ? null : users.first;
  }

  // VIPユーザーを検索
  Future<List<UserModel>> queryVipUsers() async {
    return query(
      where: 'is_vip = ?',
      whereArgs: [1],
      orderBy: 'user_id DESC',
    );
  }

  // VIPステータスを更新
  Future<bool> updateVipStatus(int userId, bool isVip) async {
    int count = await update(
      {'is_vip': isVip ? 1 : 0},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  // フォローIDを更新
  Future<void> updateFollowingIds(int userId, List<int> followingIds) async {
    await update(
      {'following_ids': followingIds},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
```

### 3. 使用例 (user_page.dart)

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
    // ユーザーを作成
    var user = UserModel(
      username: 'test_user',
      nickname: 'テストユーザー',
      age: 18,
      isVip: false,
      hobbies: ['読書', 'ゲーム'],
      followingIds: [1, 2, 3],
      extra: {'score': 100},
    );
    
    // データベースに挿入
    int userId = await _userDao.insert(user);
    print('挿入成功、ユーザーID: $userId');
    
    // ユーザーを検索
    UserModel? dbUser = await _userDao.queryOne(userId);
    print('検索結果: $dbUser');
    
    // VIPステータスを更新
    await _userDao.updateVipStatus(userId, true);
    
    // フォローリストを更新
    await _userDao.updateFollowingIds(userId, [4, 5, 6]);
    
    // 全VIPユーザーを検索
    List<UserModel> vipUsers = await _userDao.queryVipUsers();
    print('VIPユーザー数: ${vipUsers.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ユーザー管理')),
      body: Center(
        child: ElevatedButton(
          onPressed: _addUser,
          child: Text('テストユーザーを追加'),
        ),
      ),
    );
  }
}
```

## VI. データベース構造

上記のモデルは自動的に以下のテーブル構造を生成します：

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
  hobbies TEXT,  -- List型は自動的にJSON文字列に変換
  following_ids TEXT, -- List型は自動的にJSON文字列に変換
  extra TEXT -- Map型は自動的にJSON文字列に変換
)
```

主な特徴：

1. サポートされるデータ型：
   - INTEGER: int型用
   - REAL: double型用
   - TEXT: String型用
   - INTEGER: bool型用（0/1）

2. 複雑な型の処理：
   - ListやMap型は自動的にJSON文字列に変換
   - 読み取り時に自動的に元の型に戻す
   - 手動の型変換が不要

3. 主キーの設定：
   - user_idを主キーとして使用
   - 自動増分に設定
   - primaryKeyAndValueメソッドで指定

## VII. 重要な注意事項

1. データベース関連：
   - データベースアップグレード時は新しいフィールドを手動で追加する必要がある
   - 複雑な型は多くのストレージ容量を使用する
   - デバッグツールはデバッグモードでのみ使用を推奨
   - FFIバージョンはパフォーマンスが向上するが追加設定が必要

2. 型の安全性：
   - すべてのフィールドはnullable推奨
   - JSON解析時の型チェック
   - データベース操作時の型変換

3. パフォーマンス最適化：
   - 大きな複雑な型の保存を避ける
   - テーブル構造とインデックスを慎重に設計
   - バッチ操作にはトランザクションを使用

## VIII. サンプルプロジェクト

完全な例は以下を参照してください：
- [BookReader](https://github.com/fastcode555/book_reader)
- [Example](https://github.com/fastcode555/Json2Dart_Null_Safety/tree/develop_database/example) 