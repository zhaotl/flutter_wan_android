// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hot_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotKey _$HotKeyFromJson(Map<String, dynamic> json) => HotKey(
      id: (json['id'] as num?)?.toInt(),
      link: json['link'] as String?,
      name: json['name'] as String?,
      order: (json['order'] as num?)?.toInt(),
      visible: (json['visible'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HotKeyToJson(HotKey instance) => <String, dynamic>{
      'id': instance.id,
      'link': instance.link,
      'name': instance.name,
      'order': instance.order,
      'visible': instance.visible,
    };