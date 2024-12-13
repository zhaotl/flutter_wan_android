// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_collect_web.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyCollectWeb _$MyCollectWebFromJson(Map<String, dynamic> json) => MyCollectWeb(
      desc: json['desc'] as String?,
      icon: json['icon'] as String?,
      id: (json['id'] as num?)?.toInt(),
      link: json['link'] as String?,
      name: json['name'] as String?,
      order: (json['order'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      visible: (json['visible'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MyCollectWebToJson(MyCollectWeb instance) =>
    <String, dynamic>{
      'desc': instance.desc,
      'icon': instance.icon,
      'id': instance.id,
      'link': instance.link,
      'name': instance.name,
      'order': instance.order,
      'userId': instance.userId,
      'visible': instance.visible,
    };
