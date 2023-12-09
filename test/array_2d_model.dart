import 'package:json2dart_safe/json2dart.dart';
import 'dart:convert';

class Array2dModel {
  List<List<OtherRewards>>? otherRewards;
  List<List<MainRewards>>? mainRewards;
  String? pointsPic;
  List<List<int>>? pointsArrays;
  int? targetReward;
  int? endTime;
  List<YourRewards>? yourRewards;
  int? points;
  int? startTime;
  String? topicPic;
  int? topic3;
  int? topic4;
  List<List<String>>? imageArrays;
  int? campaignId;
  int? displayStatus;

  Array2dModel({
    this.otherRewards,
    this.mainRewards,
    this.pointsPic,
    this.pointsArrays,
    this.targetReward,
    this.endTime,
    this.yourRewards,
    this.points,
    this.startTime,
    this.topicPic,
    this.topic3,
    this.topic4,
    this.imageArrays,
    this.campaignId,
    this.displayStatus,
  });

  Array2dModel clone() => Array2dModel(
        otherRewards: otherRewards?.map((v) => v.map((e) => e.clone()).toList()).toList(),
        mainRewards: mainRewards?.map((v) => v.map((e) => e.clone()).toList()).toList(),
        pointsPic: pointsPic,
        pointsArrays: pointsArrays?.map((e) => List<int>.from(e)).toList(),
        targetReward: targetReward,
        endTime: endTime,
        yourRewards: yourRewards?.map((v) => v.clone()).toList(),
        points: points,
        startTime: startTime,
        topicPic: topicPic,
        topic3: topic3,
        topic4: topic4,
        imageArrays: imageArrays?.map((e) => List<String>.from(e)).toList(),
        campaignId: campaignId,
        displayStatus: displayStatus,
      );

  Map<String, dynamic> toJson() => {
        'other_rewards': otherRewards?.map((v) => v.map((e) => e.toJson()).toList()).toList(),
        'main_rewards': mainRewards?.map((v) => v.map((e) => e.toJson()).toList()).toList(),
        'points_pic': pointsPic,
        'points_arrays': pointsArrays,
        'target_reward': targetReward,
        'end_time': endTime,
        'your_rewards': yourRewards?.map((v) => v.toJson()).toList(),
        'points': points,
        'start_time': startTime,
        'topic_pic': topicPic,
        'topic_3': topic3,
        'topic_4': topic4,
        'image_arrays': imageArrays,
        'campaign_id': campaignId,
        'display_status': displayStatus,
      };

  Array2dModel.fromJson(Map json) {
    otherRewards = json.asArray2d<OtherRewards>('other_rewards', (v) => OtherRewards.fromJson(v));
    mainRewards = json.asArray2d<MainRewards>('main_rewards', (v) => MainRewards.fromJson(v));
    pointsPic = json.asString('points_pic');
    pointsArrays = json.asArray2d<int>('points_arrays');
    targetReward = json.asInt('target_reward');
    endTime = json.asInt('end_time');
    yourRewards = json.asList<YourRewards>('your_rewards', (v) => YourRewards.fromJson(v));
    points = json.asInt('points');
    startTime = json.asInt('start_time');
    topicPic = json.asString('topic_pic');
    topic3 = json.asInt('topic_3');
    topic4 = json.asInt('topic_4');
    imageArrays = json.asArray2d<String>('image_arrays');
    campaignId = json.asInt('campaign_id');
    displayStatus = json.asInt('display_status');
  }

  @override
  String toString() => jsonEncode(toJson());
}

class OtherRewards {
  int? amount;
  int? tp;

  OtherRewards({
    this.amount,
    this.tp,
  });

  OtherRewards clone() => OtherRewards(
        amount: amount,
        tp: tp,
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'tp': tp,
      };

  OtherRewards.fromJson(Map json) {
    amount = json.asInt('amount');
    tp = json.asInt('tp');
  }

  @override
  String toString() => jsonEncode(toJson());
}

class MainRewards {
  int? amount;
  int? tp;

  MainRewards({
    this.amount,
    this.tp,
  });

  MainRewards clone() => MainRewards(
        amount: amount,
        tp: tp,
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'tp': tp,
      };

  MainRewards.fromJson(Map json) {
    amount = json.asInt('amount');
    tp = json.asInt('tp');
  }

  @override
  String toString() => jsonEncode(toJson());
}

class Traits {
  String? typeName;
  String? cardImage;

  Traits({
    this.typeName,
    this.cardImage,
  });

  Traits clone() => Traits(
        typeName: typeName,
        cardImage: cardImage,
      );

  Map<String, dynamic> toJson() => {
        'type_name': typeName,
        'card_image': cardImage,
      };

  Traits.fromJson(Map json) {
    typeName = json.asString('type_name');
    cardImage = json.asString('card_image');
  }

  @override
  String toString() => jsonEncode(toJson());
}

class RawInfo {
  Traits? traits;

  RawInfo({
    this.traits,
  });

  RawInfo clone() => RawInfo(
        traits: traits?.clone(),
      );

  Map<String, dynamic> toJson() => {
        'traits': traits?.toJson(),
      };

  RawInfo.fromJson(Map json) {
    traits = json.asBean('traits', (v) => Traits.fromJson(v));
  }

  @override
  String toString() => jsonEncode(toJson());
}

class YourRewards {
  int? rewardValue;
  int? rewardType;
  String? rewardAddr;
  RawInfo? rawInfo;

  YourRewards({
    this.rewardValue,
    this.rewardType,
    this.rewardAddr,
    this.rawInfo,
  });

  YourRewards clone() => YourRewards(
        rewardValue: rewardValue,
        rewardType: rewardType,
        rewardAddr: rewardAddr,
        rawInfo: rawInfo?.clone(),
      );

  Map<String, dynamic> toJson() => {
        'reward_value': rewardValue,
        'reward_type': rewardType,
        'reward_addr': rewardAddr,
        'raw_info': rawInfo?.toJson(),
      };

  YourRewards.fromJson(Map json) {
    rewardValue = json.asInt('reward_value');
    rewardType = json.asInt('reward_type');
    rewardAddr = json.asString('reward_addr');
    rawInfo = json.asBean('raw_info', (v) => RawInfo.fromJson(v));
  }

  @override
  String toString() => jsonEncode(toJson());
}
