// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppResponse<T> _$AppResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    AppResponse<T>(
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      errorCode: (json['errorCode'] as num?)?.toInt(),
      errorMsg: json['errorMsg'] as String?,
    );

Map<String, dynamic> _$AppResponseToJson<T>(
  AppResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
