// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_articles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareArticles _$ShareArticlesFromJson(Map<String, dynamic> json) =>
    ShareArticles(
      curPage: (json['curPage'] as num?)?.toInt(),
      datas: json['datas'] as List<ArticleItem>?,
      offset: (json['offset'] as num?)?.toInt(),
      over: json['over'] as bool?,
      pageCount: (json['pageCount'] as num?)?.toInt(),
      size: (json['size'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShareArticlesToJson(ShareArticles instance) =>
    <String, dynamic>{
      'curPage': instance.curPage,
      'datas': instance.datas,
      'offset': instance.offset,
      'over': instance.over,
      'pageCount': instance.pageCount,
      'size': instance.size,
      'total': instance.total,
    };
