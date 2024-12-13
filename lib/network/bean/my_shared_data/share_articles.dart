import 'package:flutter_wan_android/network/bean/articel_data/article_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'share_articles.g.dart';

@JsonSerializable()
class ShareArticles {
  int? curPage;
  List<ArticleItem>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;

  ShareArticles({
    this.curPage,
    this.datas,
    this.offset,
    this.over,
    this.pageCount,
    this.size,
    this.total,
  });

  factory ShareArticles.fromJson(Map<String, dynamic> json) {
    return _$ShareArticlesFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ShareArticlesToJson(this);
}
