// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_list_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectListData _$ProjectListDataFromJson(Map<String, dynamic> json) =>
    ProjectListData(
      curPage: (json['curPage'] as num?)?.toInt(),
      datas: (json['datas'] as List<dynamic>?)
          ?.map((e) => ProjectListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      offset: (json['offset'] as num?)?.toInt(),
      over: json['over'] as bool?,
      pageCount: (json['pageCount'] as num?)?.toInt(),
      size: (json['size'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProjectListDataToJson(ProjectListData instance) =>
    <String, dynamic>{
      'curPage': instance.curPage,
      'datas': instance.datas,
      'offset': instance.offset,
      'over': instance.over,
      'pageCount': instance.pageCount,
      'size': instance.size,
      'total': instance.total,
    };
