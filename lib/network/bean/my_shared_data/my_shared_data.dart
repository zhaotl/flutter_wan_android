import 'package:json_annotation/json_annotation.dart';

import 'coin_info.dart';
import 'share_articles.dart';

part 'my_shared_data.g.dart';

@JsonSerializable()
class MySharedData {
  CoinInfo? coinInfo;
  ShareArticles? shareArticles;

  MySharedData({this.coinInfo, this.shareArticles});

  factory MySharedData.fromJson(Map<String, dynamic> json) {
    return _$MySharedDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MySharedDataToJson(this);
}
