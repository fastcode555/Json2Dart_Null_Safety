# json2dart 가이드

[English](guide_en.md) | [简体中文](guide_cn.md) | [Deutsch](guide_de.md) | [Português](guide_pt.md) | [日本語](guide_ja.md) | 한국어

## I. 개요

json2dart는 다음 기능을 제공하는 Flutter 플러그인 모음입니다:

1. JSON에서 Dart 모델로 변환
   - Null 안전성 지원
   - 다중 필드 파싱
   - 타입 안전 변환
   - 기본값 처리

2. SQLite 데이터베이스 작업
   - 자동 테이블 구조 생성
   - 완전한 CRUD 작업
   - 복잡한 타입 지원
   - 일괄 작업 지원

3. 데이터베이스 시각화 디버깅
   - 모든 테이블 보기
   - 테이블 구조 보기
   - 테이블 데이터 보기
   - SQL 구문 강조

## II. 설치

### 1. 의존성 추가

```yaml
dependencies:
  # JSON 파싱 기본 패키지
  json2dart_safe: ^1.6.0
  
  # 데이터베이스 지원 (하나 선택)
  json2dart_db: ^latest_version    # 표준 버전
  json2dart_dbffi: ^latest_version # FFI 버전 (성능 향상)
  
  # 데이터베이스 뷰어 도구 (하나 선택)
  json2dart_viewer: ^latest_version    # 표준 버전
  json2dart_viewerffi: ^latest_version # FFI 버전
```

### 2. 디버그 도구 설정

flutter_ume가 필요합니다:

```dart
import 'package:json2dart_viewerffi/json2dart_viewerffi.dart';

void main() {
  PluginManager.instance
    ..register(const DBViewer()) // 데이터베이스 뷰어 플러그인 등록
    // ... 기타 플러그인 등록
}
```

## III. 기본 사용법

### 1. JSON 파싱

```dart
// Map에서 파싱
Map json = {...};
json.asString("key");     // String 가져오기, null이면 ""를 반환
json.asInt("key");        // int 가져오기, null이면 0을 반환
json.asDouble("key");     // double 가져오기, null이면 0.0을 반환
json.asBool("key");       // bool 가져오기, null이면 false를 반환
json.asBean<T>("key");    // 객체 파싱
json.asList<T>("key");    // 배열 파싱

// 다중 필드 파싱
json.asStrings(["name", "user_name"]); // name과 user_name을 순서대로 파싱
json.asInts(["id", "user_id"]);
json.asBools(["is_vip", "vip"]);
```

### 2. 오류 처리

```dart
// 오류 콜백 추가
Json2Dart.instance.addCallback((String error) {
  print("파싱 오류: $error");
});

// 상세 오류 정보
Json2Dart.instance.addDetailCallback((String method, String key, Map? map) {
  print("메소드: $method, 키: $key, 데이터: $map");
});
```

## IV. 사용 시나리오

### 1. JSON 파싱만 사용

JSON 파싱 기능만 필요한 경우:

```yaml
dependencies:
  json2dart_safe: ^1.6.0
```

모델 예시:

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

  // JSON 직렬화
  Map<String, dynamic> toJson() => {
    'username': username,
    'nickname': nickname,
    'age': age,
    'hobbies': hobbies,
  };

  // JSON 역직렬화
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

사용 예시:

```dart
// JSON 파싱
Map<String, dynamic> json = {
  'username': 'test',
  'age': 18,
  'hobbies': ['독서', '게임']
};
var user = UserModel.fromJson(json);

// JSON으로 변환
Map<String, dynamic> data = user.toJson();
```

### 2. 데이터베이스 지원 포함

데이터베이스 지원이 필요한 경우 전체 의존성을 추가합니다:

```yaml
dependencies:
  json2dart_safe: ^1.6.0
  json2dart_db: ^latest_version
  json2dart_viewer: ^latest_version
```

이 경우 다음이 필요합니다:
1. Model 클래스에 BaseDbModel 믹스인
2. primaryKeyAndValue 메소드 구현
3. 해당 Dao 클래스 생성

전체 예시는 다음 장을 참조하세요.

## V. 전체 예시

### 1. 모델 정의 (user_model.dart)

```dart
import 'dart:convert';
import 'package:json2dart_safe/json2dart.dart';

/// 사용자 정보 모델
class UserModel with BaseDbModel {
  // 데이터베이스 기본 키, 자동 증가
  int? userId;
  
  // 기본 필드
  String? username;
  String? nickname;
  String? avatar;
  int? age;
  double? height;
  bool? isVip;
  DateTime? birthday;
  
  // 복잡한 타입
  List<String>? hobbies;        // 취미 목록
  List<int>? followingIds;      // 팔로우 중인 사용자 ID
  Map<String, dynamic>? extra;   // 확장 필드
  
  // 생성자
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

  // JSON 직렬화
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

  // JSON 역직렬화
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

  // 데이터베이스 작업용 정적 메소드
  static UserModel toBean(Map json) => UserModel.fromJson(json);

  // 디버깅용 toString 재정의
  @override
  String toString() => jsonEncode(toJson());

  // 동등성 연산자 재정의
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;

  // BaseDbModel 메소드 구현
  @override
  Map<String, dynamic> get primaryKeyAndValue => {'user_id': userId};
}
```

### 2. 데이터베이스 작업 클래스 (user_dao.dart)

```dart
import 'package:json2dart_db/database/base_dao.dart';
import '../models/user_model.dart';

class UserDao extends BaseDao<UserModel> {
  UserDao() : super('tb_user', UserModel.toBean);

  // 사용자 이름으로 검색
  Future<UserModel?> queryByUsername(String username) async {
    List<UserModel> users = await query(
      where: 'username = ?',
      whereArgs: [username],
    );
    return users.isEmpty ? null : users.first;
  }

  // VIP 사용자 검색
  Future<List<UserModel>> queryVipUsers() async {
    return query(
      where: 'is_vip = ?',
      whereArgs: [1],
      orderBy: 'user_id DESC',
    );
  }

  // VIP 상태 업데이트
  Future<bool> updateVipStatus(int userId, bool isVip) async {
    int count = await update(
      {'is_vip': isVip ? 1 : 0},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  // 팔로우 ID 업데이트
  Future<void> updateFollowingIds(int userId, List<int> followingIds) async {
    await update(
      {'following_ids': followingIds},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
```

### 3. 사용 예시 (user_page.dart)

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
    // 사용자 생성
    var user = UserModel(
      username: 'test_user',
      nickname: '테스트 사용자',
      age: 18,
      isVip: false,
      hobbies: ['독서', '게임'],
      followingIds: [1, 2, 3],
      extra: {'score': 100},
    );
    
    // 데이터베이스에 삽입
    int userId = await _userDao.insert(user);
    print('삽입 성공, 사용자 ID: $userId');
    
    // 사용자 검색
    UserModel? dbUser = await _userDao.queryOne(userId);
    print('검색 결과: $dbUser');
    
    // VIP 상태 업데이트
    await _userDao.updateVipStatus(userId, true);
    
    // 팔로우 목록 업데이트
    await _userDao.updateFollowingIds(userId, [4, 5, 6]);
    
    // 모든 VIP 사용자 검색
    List<UserModel> vipUsers = await _userDao.queryVipUsers();
    print('VIP 사용자 수: ${vipUsers.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('사용자 관리')),
      body: Center(
        child: ElevatedButton(
          onPressed: _addUser,
          child: Text('테스트 사용자 추가'),
        ),
      ),
    );
  }
}
```

## VI. 데이터베이스 구조

위 모델은 자동으로 다음과 같은 테이블 구조를 생성합니다:

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
  hobbies TEXT,  -- List 타입은 자동으로 JSON 문자열로 변환
  following_ids TEXT, -- List 타입은 자동으로 JSON 문자열로 변환
  extra TEXT -- Map 타입은 자동으로 JSON 문자열로 변환
)
```

주요 특징:

1. 지원되는 데이터 타입:
   - INTEGER: int 타입용
   - REAL: double 타입용
   - TEXT: String 타입용
   - INTEGER: bool 타입용 (0/1)

2. 복잡한 타입 처리:
   - List와 Map 타입은 자동으로 JSON 문자열로 변환
   - 읽기 시 자동으로 원래 타입으로 변환
   - 수동 타입 변환이 필요 없음

3. 기본 키 설정:
   - user_id를 기본 키로 사용
   - 자동 증가로 설정
   - primaryKeyAndValue 메소드로 지정

## VII. 중요 참고 사항

1. 데이터베이스 관련:
   - 데이터베이스 업그레이드 시 새 필드를 수동으로 추가해야 함
   - 복잡한 타입은 더 많은 저장 공간을 사용
   - 디버그 도구는 디버그 모드에서만 사용 권장
   - FFI 버전은 성능이 향상되지만 추가 설정 필요

2. 타입 안전성:
   - 모든 필드는 nullable 권장
   - JSON 파싱 시 타입 검사
   - 데이터베이스 작업 시 타입 변환

3. 성능 최적화:
   - 큰 복잡한 타입 저장 피하기
   - 테이블 구조와 인덱스 신중하게 설계
   - 일괄 작업에는 트랜잭션 사용

## VIII. 예제 프로젝트

전체 예제는 다음을 참조하세요:
- [BookReader](https://github.com/fastcode555/book_reader)
- [Example](https://github.com/fastcode555/Json2Dart_Null_Safety/tree/develop_database/example) 