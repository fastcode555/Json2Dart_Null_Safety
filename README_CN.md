### json 转 dart 模型，支持空指针跟安全转换，以及多字段解析

### 前言

> 20年疫情爆发时，感觉部门甚是不稳定，本身做安卓出身的我，在一位前同事介绍下，就去做了flutter，当然我本身也是很看好flutter的！转眼到了现在，想想博客荒废到现在，也该动动手，写一些文章简单总结下了!

### 一. json 转dart的现况

其实一开始用flutter都是用现在比较火json2dart的插件或者一个外国小哥写的json2dart的插件，那时那些插件也都不支持空安全（主要是当时flutter版本在迭代中)
。当然，促使我真正开始写自己的这个插件的原因还是因为当时flutter不能清楚的指名json转model，具体错误出现在哪一行，哪个字段，只说明了某个类型转换某个类型错误，当时首页几千行的json，要找一个类型错误，着实蛋疼，于是才着手编写了现在的dart依赖的package以及插件,代码已经上传到pub上了：

```dart
https: //pub.dev/packages/json2dart_safe
```

插件一开始是直接写进代码中，后来经过几个版本的迭代，也就抽出来了。代码在当时当时12个人的小组中被当成组内规范使用，模型基本都被要求用我写的插件生成（感谢！！！）。当然之前除了在公司内，本人影响力着实有限，加上之前真的好久没有写过博客，插件也未上过架，所以package使用者也是廖廖，各位使用flutter开发的看官，大概已经有了成熟的稳定的方法了，也权当做看看了！

### 二.json转dart的代码

#### 1.安全转换

```dart

Map? json = Map();
//获取String，为空返回“”
json.asString(String key)
//获取Double值，为空返回0.0
json.asDouble(String key)
//获取Int值，为空返回0
json.asInt(String key)
//获取Bool值，为空返回false
json.asBool(String key)
//获取num值，可谓double或者int，实际生成中会具体指名类型，不会生成该字段
json.asNum(String key)
//解析具体的bean类
json.asBean<T>(String key)
//解析具体的数组类
json.asList<T>(String key)
```

#### 2.空指针支持

跟随flutter版本支持全面支持空指针

```dart
  int?num;
  String?name;
  String?singerName;
  String?singerImage;
  int?singerNum;
  String?images;
  String?releaseTime;
  int?like;
  String?audioUrl;
  String?views;
  String?videoUrl;
  int?albumNum;
  String?albumName;
  String?movieTime;
  String?heroTag;
  String?uploadedBy;
  String?inPlaylists;
```

#### 3.支持多个字段解析

其实用法跟单字段一致，只是会加方法名加上s，支持多字段数据，进行解析，已求达到多个模型能够达到共用的目的，当然也是为了适应后台不同人员开发，习惯不同导致命名不同，建议直接找后台人员修改，懒得也可以直接指定多字段，当然这里是跟gson对齐，gson是支持多字段解析的！

```dart

Map? json = Map();
//获取String，为空返回“”
json.asStrings(List<String> key);
//获取Double值，为空返回0.0
json.asDoubles(List<String> key);
//获取Int值，为空返回0
json.asInts(List<String> key);
//获取Bool值，为空返回false
json.asBools(List<String> key);
//获取num值，可谓double或者int，实际生成中会具体指名类型，不会生成该字段
json.asNums(List<String> key);
//解析具体的bean类
json.asBeans<T>(List<String>);
//解析具体的数组类
json.asLists<T>(List<String>);
```

#### 4.最外层的model会多生成一个静态方法

至于为啥这样做，总觉得dart支持方法变量传递，不用就不高大尚而已，纯属个人怪癖。

```dart
  static Music toBean(Map json)=>Music.fromJson(json);
```

#### 5.具体的模型示例

```dart
import 'package:json2dart_safe/json2dart.dart';

class Music {
  int? num;
  String? name;
  String? singerName;
  String? singerImage;
  int? singerNum;
  String? images;
  String? releaseTime;
  int? like;
  String? audioUrl;
  String? views;
  String? videoUrl;
  int? albumNum;
  String? albumName;
  String? movieTime;
  String? heroTag;
  String? uploadedBy;
  String? inPlaylists;

  Music({
    this.num,
    this.albumNum,
    this.name,
    this.singerName,
    this.images,
    this.releaseTime,
    this.like,
    this.audioUrl,
    this.videoUrl,
    this.views,
    this.albumName,
    this.movieTime,
    this.heroTag,
    this.singerNum,
    this.singerImage,
    this.uploadedBy,
    this.inPlaylists,
  });

  Map<String, dynamic> toMap() =>
      {
        'num', this.num,
        'name', this.name,
        'singerName', this.singerName,
        'singerNum', this.singerNum,
        'images', this.images,
        'releaseTime', this.releaseTime,
        'like', this.like,
        'videoUrl', this.videoUrl,
        'audioUrl', this.audioUrl,
        'albumNum', this.albumNum,
        'albumName', this.albumName,
        'heroTag', this.heroTag,
        'views', this.views,
        'uploadedBy', this.uploadedBy,
        'movieTime', this.movieTime,
        'in_playlists', this.inPlaylists,
        'singerImage', this.singerImage,
      };

  factory Music.fromJson(Map json) {
    return Music(
      num: json.asInts(['num', 'music_num']),
      name: json.asStrings(['name', 'music_name']),
      singerName: json.asStrings(['singerName', 'singer_name']),
      releaseTime: json.asString('releaseTime'),
      inPlaylists: json.asString('in_playlists'),
      like: json.asInt('like'),
      audioUrl: json.asStrings(['audioUrl', 'audio_url']),
      videoUrl: json.asStrings(['videoUrl', 'video_url']),
      albumNum: json.asInts(['albumNum', 'album', 'album_num']),
      albumName: json.asStrings(['albumName', 'album_name']),
      views: json.asString('views'),
      singerNum: json.asInts(['singerNum', 'singer_num']),
      movieTime: json.asString('movieTime'),
      singerImage: json.asString('singer_image'),
      uploadedBy: json.asString('uploaded_by'),
      images: json.asStrings(['images', 'music_image', 'album_image']),
    );
  }

  static Music toBean(Map json) => Music.fromJson(json);
}
```

Ps:

- 这里put的调用会将Null值和空字符串筛选掉，put方法做了判断
- 另外生成的model只会支持单字段，多字段，需自己手动改代码

#### 6.基于现有的model模型，配合自己的封装，api层一般都是长这样子的

现在还没用resultful风格，得找个时间好好研究。代码尽量做到封装度高，调用简洁

```dart
Future<ResultData> search(Map<String, dynamic> parameters) {
  return getList<Music>(
    'apis',
    data: parameters,
    builder: Music.toBean,
  );
}
```

### 三.json 转dart的插件跟网站

以下两种方式都是本人捣鼓的，第二网站的搭建是某位大神的，我也是clone 大神的flutter web项目搭建的（感谢！！！）

- [插件下载地址](https://github.com/fastcode555/JsonBeanGenerator/tree/master/publish_version)
- [model生成地址](https://fastcode555.github.io/#tools/Json2DartPage)

### 四.json转dart引用

- [简单在代码中使用该网站的pub.dev的plugin就可以了](https://pub.dev/packages/json2dart_safe)

  ```yaml
  json2dart_safe: ^1.4.3
  ```

### 五. 结尾

如果有任何问题需要改进，欢迎大家提出来。另外希望大家动动小指头，点亮star