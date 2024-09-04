import 'dart:convert';

import 'array_2d_model.dart';

void main() {
  var content = '''
{
  "campaign_id": 10,
  "start_time": 1693972698,
  "end_time": 1701316800,
  "display_status": 1,
  "topic_3": 0,
  "topic_4": 0,
  "points": 0,
  "image_arrays": [
    [
      "0"
    ],
        null,

    [
      "1",
      "2",
      "3",
      "4"
    ],
    
    [
    ],
    [
      "5",
      "6",
      "7"
    ]
  ],
  "points_arrays": [
    [
      1,
      2,
      3
    ],
    [
      4,
      5
    ],
    [
      6
    ],
    [
      7,
      8,
      9,
      10
    ],
    []
  ],
  "your_rewards": [
    {
      "reward_type": 7,
      "reward_value": 10,
      "raw_info": {
        "traits": {
          "card_image": "https://static.base.me/jpg/base.jpg",
          "type_name": "base"
        }
      },
      "reward_addr": "0xef1343b1CF679F99Aa962318BA269A69Ae281D0d"
    },
    {
      "reward_type": 8,
      "reward_value": 20,
      "raw_info": {
        "traits": {
          "card_image": "https://static.copy.me/jpg/copy.jpg",
          "type_name": "copy"
        }
      },
      "reward_addr": ""
    }
  ],
  "points_pic": "",
  "topic_pic": "",
  "target_reward": 0,
  "main_rewards": [
    [
      {
        "tp": 2,
        "amount": 10
      },
      {
        "tp": 6,
        "amount": 10
      }
    ],
    [
      {
        "tp": 1,
        "amount": 10
      },
      {
        "tp": 6,
        "amount": 10
      }
    ],
    [
      {
        "tp": 7,
        "amount": 100000
      }
    ],
    [
      {
        "tp": 8,
        "amount": 8880000
      }
    ]
  ],
  "other_rewards": [
    [
      {
        "tp": 3,
        "amount": 10
      }
    ],
    [
      {
        "tp": 4,
        "amount": 1000
      }
    ],
    [
      {
        "tp": 5,
        "amount": 8880000
      }
    ]
  ]
}
  ''';
  var model = Array2dModel.fromJson(jsonDecode(content));
  //可以指定类型，类型清楚
  for (var list in model.mainRewards!) {
    for (var item in list) {
      print(item.toString());
    }
  }

  //测试基本类型
  print('${model.pointsArrays?.toString()}');
  print('${model.imageArrays?.toString()}');

  //测试bean类型
  print('${model.mainRewards?.toString()}');
  print('${model.yourRewards?.toString()}');
  print('${model.otherRewards?.toString()}');

  //测试clone
  var model2 = model.clone();
  print('${model.mainRewards?.hashCode}');
  print('${model2.mainRewards?.hashCode}');

  print('${model.mainRewards![0][0].hashCode}');
  print('${model2.mainRewards![0][0].hashCode}');
}
