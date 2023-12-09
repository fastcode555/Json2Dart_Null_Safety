import 'package:json2dart_safe/json2dart.dart';
import 'dart:convert';

class ArrayListModel {
  List<List>? otherRewards;
  List<List>? mainRewards;
  String? pointsPic;
  String? targetReward;
  String? endTime;
  List<YourRewards>? yourRewards;
  String? points;
  String? startTime;
  String? topicPic;
  String? topic3;
  String? topic4;
  String? campaignId;
  String? displayStatus;

  ArrayListModel({
    this.otherRewards,
    this.mainRewards,
    this.pointsPic,
    this.targetReward,
    this.endTime,
    this.yourRewards,
    this.points,
    this.startTime,
    this.topicPic,
    this.topic3,
    this.topic4,
    this.campaignId,
    this.displayStatus,
  });

  ArrayListModel clone() => ArrayListModel(
        otherRewards: otherRewards?.map((v) => v.map((e) => e.clone()).toList()).toList(),
        mainRewards: mainRewards?.map((v) => v.map((e) => e.clone()).toList()).toList(),
        pointsPic: pointsPic,
        targetReward: targetReward,
        endTime: endTime,
        yourRewards: yourRewards?.map((v) => v.clone()).toList(),
        points: points,
        startTime: startTime,
        topicPic: topicPic,
        topic3: topic3,
        topic4: topic4,
        campaignId: campaignId,
        displayStatus: displayStatus,
      );

  Map<String, dynamic> toJson() => {
        'other_rewards': otherRewards?.map((v) => v.map((e) => e.toJson()).toList()).toList(),
        'main_rewards': mainRewards?.map((v) => v.map((e) => e.toJson()).toList()).toList(),
        'points_pic': pointsPic,
        'target_reward': targetReward,
        'end_time': endTime,
        'your_rewards': yourRewards?.map((v) => v.toJson()).toList(),
        'points': points,
        'start_time': startTime,
        'topic_pic': topicPic,
        'topic_3': topic3,
        'topic_4': topic4,
        'campaign_id': campaignId,
        'display_status': displayStatus,
      };

  ArrayListModel.fromJson(Map json) {
    otherRewards = json.asList<List>('other_rewards', (v) => OtherRewards.fromJson(v));
    mainRewards = json.asList<List>('main_rewards', (v) => MainRewards.fromJson(v));
    pointsPic = json.asString('points_pic');
    targetReward = json.asString('target_reward');
    endTime = json.asString('end_time');
    yourRewards = json.asList<YourRewards>('your_rewards', (v) => YourRewards.fromJson(v));
    points = json.asString('points');
    startTime = json.asString('start_time');
    topicPic = json.asString('topic_pic');
    topic3 = json.asString('topic_3');
    topic4 = json.asString('topic_4');
    campaignId = json.asString('campaign_id');
    displayStatus = json.asString('display_status');
  }

  @override
  String toString() => jsonEncode(toJson());
}

class OtherRewards {
  String? amount;
  String? tp;

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
    amount = json.asString('amount');
    tp = json.asString('tp');
  }

  @override
  String toString() => jsonEncode(toJson());
}

class MainRewards {
  String? amount;
  String? tp;

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
    amount = json.asString('amount');
    tp = json.asString('tp');
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
  String? rewardValue;
  String? rewardType;
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
    rewardValue = json.asString('reward_value');
    rewardType = json.asString('reward_type');
    rewardAddr = json.asString('reward_addr');
    rawInfo = json.asBean('raw_info', (v) => RawInfo.fromJson(v));
  }

  @override
  String toString() => jsonEncode(toJson());
}
