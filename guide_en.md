# json2dart Guide

[简体中文](guide_cn.md) | [Deutsch](guide_de.md) | [Português](guide_pt.md) | [日本語](guide_ja.md) | [한국어](guide_ko.md) | English

## I. Overview

json2dart is a Flutter plugin collection that provides:

1. JSON to Dart Model Conversion
   - Null safety support
   - Multi-field parsing
   - Type-safe conversion
   - Default value handling

2. SQLite Database Operations
   - Automatic table structure generation
   - Complete CRUD operations
   - Complex type support
   - Batch operation support

3. Database Visualization Debugging
   - View all data tables
   - View table structures
   - View table data
   - SQL statement highlighting

## II. Installation

### 1. Add Dependencies

```yaml
dependencies:
  # JSON parsing base package
  json2dart_safe: ^1.6.0
  
  # Database support (choose one)
  json2dart_db: ^latest_version    # Standard version
  json2dart_dbffi: ^latest_version # FFI version (better performance)
  
  # Database viewer tools (choose one)
  json2dart_viewer: ^latest_version    # Standard version
  json2dart_viewerffi: ^latest_version # FFI version
```

### 2. Debug Tool Configuration

Requires flutter_ume:

```dart
import 'package:json2dart_viewerffi/json2dart_viewerffi.dart';

void main() {
  PluginManager.instance
    ..register(const DBViewer()) // Register database viewer plugin
    // ... other plugin registrations
}
```

## III. Basic Usage

### 1. JSON Parsing

```dart
// Parse from Map
Map json = {...};
json.asString("key");     // Get String, returns "" if null
json.asInt("key");        // Get int, returns 0 if null
json.asDouble("key");     // Get double, returns 0.0 if null
json.asBool("key");       // Get bool, returns false if null
json.asBean<T>("key");    // Parse object
json.asList<T>("key");    // Parse array

// Multi-field parsing
json.asStrings(["name", "user_name"]); // Try parsing name then user_name
json.asInts(["id", "user_id"]);
json.asBools(["is_vip", "vip"]);
```

### 2. Error Handling

```dart
// Add error callback
Json2Dart.instance.addCallback((String error) {
  print("Parsing error: $error");
});

// Detailed error information
Json2Dart.instance.addDetailCallback((String method, String key, Map? map) {
  print("Method: $method, Key: $key, Data: $map");
});
```

## IV. Usage Scenarios

### 1. JSON Parsing Only

If you only need JSON parsing functionality, just add the base package:

```yaml
dependencies:
  json2dart_safe: ^1.6.0
```

Example Model:

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

  // JSON serialization
  Map<String, dynamic> toJson() => {
    'username': username,
    'nickname': nickname,
    'age': age,
    'hobbies': hobbies,
  };

  // JSON deserialization
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

Usage example:

```dart
// Parse JSON
Map<String, dynamic> json = {
  'username': 'test',
  'age': 18,
  'hobbies': ['reading', 'gaming']
};
var user = UserModel.fromJson(json);

// Convert to JSON
Map<String, dynamic> data = user.toJson();
```

### 2. With Database Support

If you need database support, add the complete dependencies:

```yaml
dependencies:
  json2dart_safe: ^1.6.0
  json2dart_db: ^latest_version
  json2dart_viewer: ^latest_version
```

In this case you need to:
1. Have your Model class extend BaseDbModel
2. Implement the primaryKeyAndValue method
3. Create corresponding Dao class

See the next chapter for a complete example.

## V. Complete Example

### 1. Model Definition (user_model.dart)

```dart
import 'dart:convert';
import 'package:json2dart_safe/json2dart.dart';

/// User information model
class UserModel with BaseDbModel {
  // Database primary key, auto-increment
  int? userId;
  
  // Basic fields
  String? username;
  String? nickname;
  String? avatar;
  int? age;
  double? height;
  bool? isVip;
  DateTime? birthday;
  
  // Complex types
  List<String>? hobbies;        // Hobby list
  List<int>? followingIds;      // Following user IDs
  Map<String, dynamic>? extra;   // Extension fields
  
  // Constructor
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

  // JSON serialization
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

  // JSON deserialization
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

  // Static method for database operations
  static UserModel toBean(Map json) => UserModel.fromJson(json);

  // Override toString for debugging
  @override
  String toString() => jsonEncode(toJson());

  // Override equality operator
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;

  // Implement BaseDbModel method, return primary key and value
  @override
  Map<String, dynamic> get primaryKeyAndValue => {'user_id': userId};
}
```

### 2. Database Operations Class (user_dao.dart)

```dart
import 'package:json2dart_db/database/base_dao.dart';
import '../models/user_model.dart';

class UserDao extends BaseDao<UserModel> {
  UserDao() : super('tb_user', UserModel.toBean);

  // Query by username
  Future<UserModel?> queryByUsername(String username) async {
    List<UserModel> users = await query(
      where: 'username = ?',
      whereArgs: [username],
    );
    return users.isEmpty ? null : users.first;
  }

  // Query VIP users
  Future<List<UserModel>> queryVipUsers() async {
    return query(
      where: 'is_vip = ?',
      whereArgs: [1],
      orderBy: 'user_id DESC',
    );
  }

  // Update user VIP status
  Future<bool> updateVipStatus(int userId, bool isVip) async {
    int count = await update(
      {'is_vip': isVip ? 1 : 0},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  // Batch update following status
  Future<void> updateFollowingIds(int userId, List<int> followingIds) async {
    await update(
      {'following_ids': followingIds},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
```

### 3. Usage Example (user_page.dart)

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
    // Create user
    var user = UserModel(
      username: 'test_user',
      nickname: 'Test User',
      age: 18,
      isVip: false,
      hobbies: ['reading', 'gaming'],
      followingIds: [1, 2, 3],
      extra: {'score': 100},
    );
    
    // Insert into database
    int userId = await _userDao.insert(user);
    print('Insert successful, User ID: $userId');
    
    // Query user
    UserModel? dbUser = await _userDao.queryOne(userId);
    print('Query result: $dbUser');
    
    // Update VIP status
    await _userDao.updateVipStatus(userId, true);
    
    // Update following list
    await _userDao.updateFollowingIds(userId, [4, 5, 6]);
    
    // Query all VIP users
    List<UserModel> vipUsers = await _userDao.queryVipUsers();
    print('VIP user count: ${vipUsers.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: Center(
        child: ElevatedButton(
          onPressed: _addUser,
          child: Text('Add Test User'),
        ),
      ),
    );
  }
}
```

## VI. Database Table Structure

The above model will automatically generate the following table structure:

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
  hobbies TEXT,  -- List type will be automatically converted to JSON string
  following_ids TEXT, -- List type will be automatically converted to JSON string
  extra TEXT -- Map type will be automatically converted to JSON string
)
```

Key features:

1. Supported Data Types:
   - INTEGER: for int type
   - REAL: for double type
   - TEXT: for String type
   - INTEGER: for bool type (0/1)

2. Complex Type Handling:
   - List and Map types are automatically converted to JSON strings
   - Automatically parsed back to original types when reading
   - No need to write manual type converters

3. Primary Key Configuration:
   - Uses user_id as primary key
   - Set to auto-increment
   - Specified through primaryKeyAndValue method

## VII. Important Notes

1. Database Related:
   - New fields must be added manually during database upgrades
   - Complex types will occupy more storage space
   - Debug tools are recommended for Debug mode only
   - FFI version offers better performance but requires additional configuration

2. Type Safety:
   - All fields should be nullable
   - Type checking during JSON parsing
   - Type conversion during database operations

3. Performance Optimization:
   - Avoid storing large complex types
   - Design table structure and indexes properly
   - Use transactions for batch operations

## VIII. Example Projects

For complete examples, refer to:
- [BookReader](https://github.com/fastcode555/book_reader)
- [Example](https://github.com/fastcode555/Json2Dart_Null_Safety/tree/develop_database/example) 