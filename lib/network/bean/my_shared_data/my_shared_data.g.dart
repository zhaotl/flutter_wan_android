// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_shared_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MySharedData _$MySharedDataFromJson(Map<String, dynamic> json) => MySharedData(
      coinInfo: json['coinInfo'] == null
          ? null
          : CoinInfo.fromJson(json['coinInfo'] as Map<String, dynamic>),
      shareArticles: json['shareArticles'] == null
          ? null
          : ShareArticles.fromJson(
              json['shareArticles'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MySharedDataToJson(MySharedData instance) =>
    <String, dynamic>{
      'coinInfo': instance.coinInfo,
      'shareArticles': instance.shareArticles,
    };
