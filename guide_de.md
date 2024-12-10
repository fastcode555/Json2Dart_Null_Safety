# json2dart Anleitung

[English](guide_en.md) | [简体中文](guide_cn.md) | [Português](guide_pt.md) | [日本語](guide_ja.md) | [한국어](guide_ko.md) | Deutsch

## I. Übersicht

json2dart ist eine Flutter-Plugin-Sammlung mit folgenden Funktionen:

1. JSON zu Dart-Modell Konvertierung
   - Null-Safety Unterstützung
   - Multi-Feld-Parsing
   - Typsichere Konvertierung
   - Standardwert-Behandlung

2. SQLite Datenbankoperationen
   - Automatische Tabellenstruktur-Generierung
   - Vollständige CRUD-Operationen
   - Unterstützung komplexer Datentypen
   - Batch-Operation Unterstützung

3. Datenbank-Visualisierungs-Debugging
   - Anzeige aller Datentabellen
   - Anzeige der Tabellenstrukturen
   - Anzeige der Tabellendaten
   - SQL-Anweisungs-Highlighting

## II. Installation

### 1. Abhängigkeiten hinzufügen

```yaml
dependencies:
  # JSON-Parsing Basispaket
  json2dart_safe: ^1.6.0
  
  # Datenbankunterstützung (wählen Sie eine)
  json2dart_db: ^latest_version    # Standardversion
  json2dart_dbffi: ^latest_version # FFI-Version (bessere Leistung)
  
  # Datenbank-Viewer Tools (wählen Sie eine)
  json2dart_viewer: ^latest_version    # Standardversion
  json2dart_viewerffi: ^latest_version # FFI-Version
```

### 2. Debug-Tool Konfiguration

Benötigt flutter_ume:

```dart
import 'package:json2dart_viewerffi/json2dart_viewerffi.dart';

void main() {
  PluginManager.instance
    ..register(const DBViewer()) // Datenbank-Viewer Plugin registrieren
    // ... weitere Plugin-Registrierungen
}
```

## III. Grundlegende Verwendung

### 1. JSON-Parsing

```dart
// Aus Map parsen
Map json = {...};
json.asString("key");     // String abrufen, gibt "" zurück wenn null
json.asInt("key");        // Int abrufen, gibt 0 zurück wenn null
json.asDouble("key");     // Double abrufen, gibt 0.0 zurück wenn null
json.asBool("key");       // Bool abrufen, gibt false zurück wenn null
json.asBean<T>("key");    // Objekt parsen
json.asList<T>("key");    // Array parsen

// Multi-Feld-Parsing
json.asStrings(["name", "user_name"]); // Versucht name dann user_name zu parsen
json.asInts(["id", "user_id"]);
json.asBools(["is_vip", "vip"]);
```

### 2. Fehlerbehandlung

```dart
// Fehler-Callback hinzufügen
Json2Dart.instance.addCallback((String error) {
  print("Parsing-Fehler: $error");
});

// Detaillierte Fehlerinformationen
Json2Dart.instance.addDetailCallback((String method, String key, Map? map) {
  print("Methode: $method, Schlüssel: $key, Daten: $map");
});
```

## IV. Anwendungsfälle

### 1. Nur JSON-Parsing

Wenn Sie nur die JSON-Parsing-Funktionalität benötigen:

```yaml
dependencies:
  json2dart_safe: ^1.6.0
```

Beispiel-Modell:

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

  // JSON-Serialisierung
  Map<String, dynamic> toJson() => {
    'username': username,
    'nickname': nickname,
    'age': age,
    'hobbies': hobbies,
  };

  // JSON-Deserialisierung
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

Verwendungsbeispiel:

```dart
// JSON parsen
Map<String, dynamic> json = {
  'username': 'test',
  'age': 18,
  'hobbies': ['lesen', 'spielen']
};
var user = UserModel.fromJson(json);

// In JSON konvertieren
Map<String, dynamic> data = user.toJson();
```

### 2. Mit Datenbankunterstützung

Wenn Sie Datenbankunterstützung benötigen, fügen Sie die vollständigen Abhängigkeiten hinzu:

```yaml
dependencies:
  json2dart_safe: ^1.6.0
  json2dart_db: ^latest_version
  json2dart_viewer: ^latest_version
```

In diesem Fall müssen Sie:
1. Die Modellklasse von BaseDbModel ableiten
2. Die primaryKeyAndValue-Methode implementieren
3. Eine entsprechende Dao-Klasse erstellen

Ein vollständiges Beispiel finden Sie im nächsten Kapitel.

## V. Vollständiges Beispiel

### 1. Modelldefinition (user_model.dart)

```dart
import 'dart:convert';
import 'package:json2dart_safe/json2dart.dart';

/// Benutzerinformationsmodell
class UserModel with BaseDbModel {
  // Datenbank-Primärschlüssel, Auto-Increment
  int? userId;
  
  // Grundlegende Felder
  String? username;
  String? nickname;
  String? avatar;
  int? age;
  double? height;
  bool? isVip;
  DateTime? birthday;
  
  // Komplexe Typen
  List<String>? hobbies;        // Hobbyliste
  List<int>? followingIds;      // Folgende Benutzer-IDs
  Map<String, dynamic>? extra;   // Erweiterungsfelder
  
  // Konstruktor
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

  // JSON-Serialisierung
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

  // JSON-Deserialisierung
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

  // Statische Methode für Datenbankoperationen
  static UserModel toBean(Map json) => UserModel.fromJson(json);

  // toString-Methode für Debugging überschreiben
  @override
  String toString() => jsonEncode(toJson());

  // Gleichheitsoperator überschreiben
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;

  // BaseDbModel-Methode implementieren
  @override
  Map<String, dynamic> get primaryKeyAndValue => {'user_id': userId};
}
```

### 2. Datenbankoperationsklasse (user_dao.dart)

```dart
import 'package:json2dart_db/database/base_dao.dart';
import '../models/user_model.dart';

class UserDao extends BaseDao<UserModel> {
  UserDao() : super('tb_user', UserModel.toBean);

  // Nach Benutzername suchen
  Future<UserModel?> queryByUsername(String username) async {
    List<UserModel> users = await query(
      where: 'username = ?',
      whereArgs: [username],
    );
    return users.isEmpty ? null : users.first;
  }

  // VIP-Benutzer abfragen
  Future<List<UserModel>> queryVipUsers() async {
    return query(
      where: 'is_vip = ?',
      whereArgs: [1],
      orderBy: 'user_id DESC',
    );
  }

  // VIP-Status aktualisieren
  Future<bool> updateVipStatus(int userId, bool isVip) async {
    int count = await update(
      {'is_vip': isVip ? 1 : 0},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  // Folgende IDs aktualisieren
  Future<void> updateFollowingIds(int userId, List<int> followingIds) async {
    await update(
      {'following_ids': followingIds},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
```

### 3. Verwendungsbeispiel (user_page.dart)

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
    // Benutzer erstellen
    var user = UserModel(
      username: 'test_user',
      nickname: 'Testbenutzer',
      age: 18,
      isVip: false,
      hobbies: ['lesen', 'spielen'],
      followingIds: [1, 2, 3],
      extra: {'score': 100},
    );
    
    // In Datenbank einfügen
    int userId = await _userDao.insert(user);
    print('Erfolgreich eingefügt, Benutzer-ID: $userId');
    
    // Benutzer abfragen
    UserModel? dbUser = await _userDao.queryOne(userId);
    print('Abfrageergebnis: $dbUser');
    
    // VIP-Status aktualisieren
    await _userDao.updateVipStatus(userId, true);
    
    // Folgende Liste aktualisieren
    await _userDao.updateFollowingIds(userId, [4, 5, 6]);
    
    // Alle VIP-Benutzer abfragen
    List<UserModel> vipUsers = await _userDao.queryVipUsers();
    print('Anzahl VIP-Benutzer: ${vipUsers.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Benutzerverwaltung')),
      body: Center(
        child: ElevatedButton(
          onPressed: _addUser,
          child: Text('Testbenutzer hinzufügen'),
        ),
      ),
    );
  }
}
```

## VI. Datenbankstruktur

Das obige Modell generiert automatisch folgende Tabellenstruktur:

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
  hobbies TEXT,  -- List-Typ wird automatisch in JSON-String konvertiert
  following_ids TEXT, -- List-Typ wird automatisch in JSON-String konvertiert
  extra TEXT -- Map-Typ wird automatisch in JSON-String konvertiert
)
```

Hauptmerkmale:

1. Unterstützte Datentypen:
   - INTEGER: für int-Typ
   - REAL: für double-Typ
   - TEXT: für String-Typ
   - INTEGER: für bool-Typ (0/1)

2. Behandlung komplexer Typen:
   - List- und Map-Typen werden automatisch in JSON-Strings konvertiert
   - Automatische Rückkonvertierung beim Lesen
   - Keine manuelle Typkonvertierung erforderlich

3. Primärschlüssel-Konfiguration:
   - Verwendet user_id als Primärschlüssel
   - Auf Auto-Increment gesetzt
   - Über primaryKeyAndValue-Methode spezifiziert

## VII. Wichtige Hinweise

1. Datenbankbezogen:
   - Neue Felder müssen bei Datenbankaktualisierungen manuell hinzugefügt werden
   - Komplexe Typen benötigen mehr Speicherplatz
   - Debug-Tools werden nur für Debug-Modus empfohlen
   - FFI-Version bietet bessere Leistung, erfordert aber zusätzliche Konfiguration

2. Typsicherheit:
   - Alle Felder sollten nullable sein
   - Typüberprüfung während JSON-Parsing
   - Typkonvertierung bei Datenbankoperationen

3. Leistungsoptimierung:
   - Vermeiden Sie das Speichern großer komplexer Typen
   - Tabellenstruktur und Indizes sorgfältig planen
   - Transaktionen für Batch-Operationen verwenden

## VIII. Beispielprojekte

Vollständige Beispiele finden Sie hier:
- [BookReader](https://github.com/fastcode555/book_reader)
- [Example](https://github.com/fastcode555/Json2Dart_Null_Safety/tree/develop_database/example)