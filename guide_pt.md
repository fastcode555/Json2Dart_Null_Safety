# Guia json2dart

[English](guide_en.md) | [简体中文](guide_cn.md) | [Deutsch](guide_de.md) | Português

## I. Visão Geral

json2dart é uma coleção de plugins Flutter que oferece:

1. Conversão de JSON para Modelo Dart
   - Suporte a null safety
   - Análise de múltiplos campos
   - Conversão segura de tipos
   - Tratamento de valores padrão

2. Operações de Banco de Dados SQLite
   - Geração automática de estrutura de tabela
   - Operações CRUD completas
   - Suporte a tipos complexos
   - Suporte a operações em lote

3. Depuração com Visualização de Banco de Dados
   - Visualização de todas as tabelas
   - Visualização da estrutura das tabelas
   - Visualização dos dados das tabelas
   - Destaque de sintaxe SQL

## II. Instalação

### 1. Adicionar Dependências

```yaml
dependencies:
  # Pacote base para análise JSON
  json2dart_safe: ^1.6.0
  
  # Suporte a banco de dados (escolha um)
  json2dart_db: ^latest_version    # Versão padrão
  json2dart_dbffi: ^latest_version # Versão FFI (melhor desempenho)
  
  # Ferramentas de visualização de banco de dados (escolha um)
  json2dart_viewer: ^latest_version    # Versão padrão
  json2dart_viewerffi: ^latest_version # Versão FFI
```

### 2. Configuração da Ferramenta de Depuração

Requer flutter_ume:

```dart
import 'package:json2dart_viewerffi/json2dart_viewerffi.dart';

void main() {
  PluginManager.instance
    ..register(const DBViewer()) // Registrar plugin de visualização de banco de dados
    // ... outros registros de plugins
}
```

## III. Uso Básico

### 1. Análise JSON

```dart
// Analisar do Map
Map json = {...};
json.asString("key");     // Obter String, retorna "" se nulo
json.asInt("key");        // Obter int, retorna 0 se nulo
json.asDouble("key");     // Obter double, retorna 0.0 se nulo
json.asBool("key");       // Obter bool, retorna false se nulo
json.asBean<T>("key");    // Analisar objeto
json.asList<T>("key");    // Analisar array

// Análise de múltiplos campos
json.asStrings(["name", "user_name"]); // Tenta analisar name depois user_name
json.asInts(["id", "user_id"]);
json.asBools(["is_vip", "vip"]);
```

### 2. Tratamento de Erros

```dart
// Adicionar callback de erro
Json2Dart.instance.addCallback((String error) {
  print("Erro de análise: $error");
});

// Informações detalhadas de erro
Json2Dart.instance.addDetailCallback((String method, String key, Map? map) {
  print("Método: $method, Chave: $key, Dados: $map");
});
```

## IV. Cenários de Uso

### 1. Apenas Análise JSON

Se você precisa apenas da funcionalidade de análise JSON:

```yaml
dependencies:
  json2dart_safe: ^1.6.0
```

Modelo de exemplo:

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

  // Serialização JSON
  Map<String, dynamic> toJson() => {
    'username': username,
    'nickname': nickname,
    'age': age,
    'hobbies': hobbies,
  };

  // Desserialização JSON
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

Exemplo de uso:

```dart
// Analisar JSON
Map<String, dynamic> json = {
  'username': 'test',
  'age': 18,
  'hobbies': ['ler', 'jogar']
};
var user = UserModel.fromJson(json);

// Converter para JSON
Map<String, dynamic> data = user.toJson();
```

### 2. Com Suporte a Banco de Dados

Se você precisa de suporte a banco de dados, adicione as dependências completas:

```yaml
dependencies:
  json2dart_safe: ^1.6.0
  json2dart_db: ^latest_version
  json2dart_viewer: ^latest_version
```

Neste caso, você precisa:
1. Fazer sua classe Model estender BaseDbModel
2. Implementar o método primaryKeyAndValue
3. Criar a classe Dao correspondente

Veja um exemplo completo no próximo capítulo.

## V. Exemplo Completo

### 1. Definição do Modelo (user_model.dart)

```dart
import 'dart:convert';
import 'package:json2dart_safe/json2dart.dart';

/// Modelo de informações do usuário
class UserModel with BaseDbModel {
  // Chave primária do banco de dados, auto-incremento
  int? userId;
  
  // Campos básicos
  String? username;
  String? nickname;
  String? avatar;
  int? age;
  double? height;
  bool? isVip;
  DateTime? birthday;
  
  // Tipos complexos
  List<String>? hobbies;        // Lista de hobbies
  List<int>? followingIds;      // IDs dos usuários seguidos
  Map<String, dynamic>? extra;   // Campos extras
  
  // Construtor
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

  // Serialização JSON
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

  // Desserialização JSON
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

  // Método estático para operações de banco de dados
  static UserModel toBean(Map json) => UserModel.fromJson(json);

  // Sobrescrever toString para depuração
  @override
  String toString() => jsonEncode(toJson());

  // Sobrescrever operador de igualdade
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;

  // Implementar método do BaseDbModel
  @override
  Map<String, dynamic> get primaryKeyAndValue => {'user_id': userId};
}
```

### 2. Classe de Operações do Banco de Dados (user_dao.dart)

```dart
import 'package:json2dart_db/database/base_dao.dart';
import '../models/user_model.dart';

class UserDao extends BaseDao<UserModel> {
  UserDao() : super('tb_user', UserModel.toBean);

  // Consultar por nome de usuário
  Future<UserModel?> queryByUsername(String username) async {
    List<UserModel> users = await query(
      where: 'username = ?',
      whereArgs: [username],
    );
    return users.isEmpty ? null : users.first;
  }

  // Consultar usuários VIP
  Future<List<UserModel>> queryVipUsers() async {
    return query(
      where: 'is_vip = ?',
      whereArgs: [1],
      orderBy: 'user_id DESC',
    );
  }

  // Atualizar status VIP
  Future<bool> updateVipStatus(int userId, bool isVip) async {
    int count = await update(
      {'is_vip': isVip ? 1 : 0},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  // Atualizar IDs seguidos
  Future<void> updateFollowingIds(int userId, List<int> followingIds) async {
    await update(
      {'following_ids': followingIds},
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
```

### 3. Exemplo de Uso (user_page.dart)

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
    // Criar usuário
    var user = UserModel(
      username: 'test_user',
      nickname: 'Usuário Teste',
      age: 18,
      isVip: false,
      hobbies: ['ler', 'jogar'],
      followingIds: [1, 2, 3],
      extra: {'score': 100},
    );
    
    // Inserir no banco de dados
    int userId = await _userDao.insert(user);
    print('Inserção bem-sucedida, ID do usuário: $userId');
    
    // Consultar usuário
    UserModel? dbUser = await _userDao.queryOne(userId);
    print('Resultado da consulta: $dbUser');
    
    // Atualizar status VIP
    await _userDao.updateVipStatus(userId, true);
    
    // Atualizar lista de seguidos
    await _userDao.updateFollowingIds(userId, [4, 5, 6]);
    
    // Consultar todos os usuários VIP
    List<UserModel> vipUsers = await _userDao.queryVipUsers();
    print('Número de usuários VIP: ${vipUsers.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gerenciamento de Usuários')),
      body: Center(
        child: ElevatedButton(
          onPressed: _addUser,
          child: Text('Adicionar Usuário Teste'),
        ),
      ),
    );
  }
}
```

## VI. Estrutura do Banco de Dados

O modelo acima gerará automaticamente a seguinte estrutura de tabela:

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
  hobbies TEXT,  -- Tipo List será automaticamente convertido para string JSON
  following_ids TEXT, -- Tipo List será automaticamente convertido para string JSON
  extra TEXT -- Tipo Map será automaticamente convertido para string JSON
)
```

Características principais:

1. Tipos de Dados Suportados:
   - INTEGER: para tipo int
   - REAL: para tipo double
   - TEXT: para tipo String
   - INTEGER: para tipo bool (0/1)

2. Tratamento de Tipos Complexos:
   - Tipos List e Map são automaticamente convertidos para strings JSON
   - Automaticamente convertidos de volta ao tipo original na leitura
   - Não é necessário escrever conversores de tipo manualmente

3. Configuração de Chave Primária:
   - Usa user_id como chave primária
   - Configurado como auto-incremento
   - Especificado através do método primaryKeyAndValue

## VII. Notas Importantes

1. Relacionadas ao Banco de Dados:
   - Novos campos devem ser adicionados manualmente durante atualizações do banco
   - Tipos complexos ocuparão mais espaço de armazenamento
   - Ferramentas de depuração são recomendadas apenas para modo Debug
   - Versão FFI oferece melhor desempenho mas requer configuração adicional

2. Segurança de Tipos:
   - Todos os campos devem ser nullable
   - Verificação de tipos durante análise JSON
   - Conversão de tipos durante operações de banco de dados

3. Otimização de Desempenho:
   - Evite armazenar tipos complexos muito grandes
   - Planeje cuidadosamente a estrutura da tabela e índices
   - Use transações para operações em lote

## VIII. Projetos de Exemplo

Para exemplos completos, consulte:
- [BookReader](https://github.com/fastcode555/book_reader)
- [Example](https://github.com/fastcode555/Json2Dart_Null_Safety/tree/develop_database/example) 