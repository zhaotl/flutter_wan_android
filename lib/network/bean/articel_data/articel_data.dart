import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'article_item.dart';

part 'articel_data.g.dart';

@JsonSerializable()
class ArticelData {
  int? curPage;
  List<ArticleItem>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;

  ArticelData({
    this.curPage,
    this.datas,
    this.offset,
    this.over,
    this.pageCount,
    this.size,
    this.total,
  });

  factory ArticelData.fromJson(Map<String, dynamic> json) {
    return _$ArticelDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ArticelDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
