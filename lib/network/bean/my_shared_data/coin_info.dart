import 'package:json_annotation/json_annotation.dart';

part 'coin_info.g.dart';

@JsonSerializable()
class CoinInfo {
  int? coinCount;
  int? level;
  String? nickname;
  String? rank;
  int? userId;
  String? username;

  CoinInfo({
    this.coinCount,
    this.level,
    this.nickname,
    this.rank,
    this.userId,
    this.username,
  });

  factory CoinInfo.fromJson(Map<String, dynamic> json) {
    return _$CoinInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CoinInfoToJson(this);
}
