import 'package:json_annotation/json_annotation.dart';

part 'my_collect_web.g.dart';

@JsonSerializable()
class MyCollectWeb {
  String? desc;
  String? icon;
  int? id;
  String? link;
  String? name;
  int? order;
  int? userId;
  int? visible;

  MyCollectWeb({
    this.desc,
    this.icon,
    this.id,
    this.link,
    this.name,
    this.order,
    this.userId,
    this.visible,
  });

  factory MyCollectWeb.fromJson(Map<String, dynamic> json) {
    return _$MyCollectWebFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MyCollectWebToJson(this);
}
