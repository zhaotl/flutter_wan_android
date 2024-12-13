import 'dart:convert';

import 'package:flutter_wan_android/network/bean/app_response/app_response.dart';
import 'package:flutter_wan_android/network/bean/articel_data/articel_data.dart';
import 'package:flutter_wan_android/network/bean/banner/banner.dart';
import 'package:flutter_wan_android/network/bean/hot_key/hot_key.dart';
import 'package:flutter_wan_android/network/bean/my_collect_web/my_collect_web.dart';
import 'package:flutter_wan_android/network/bean/project_list_data/project_list_data.dart';
import 'package:flutter_wan_android/network/bean/project_tab/project_tab.dart';
import 'package:flutter_wan_android/network/bean/user_info/user_info.dart';
import 'package:flutter_wan_android/utils/log_util.dart';

class DtoDataConvert {
  static T convertWrapper<T>(Type type, dynamic json) {
    if (type == String && (json is String || json == null)) {
      return json as T;
    }

    return _convert(type, json);
  }

  static T _convert<T>(Type type, dynamic json) {
    Wanlog.d("~~~ ~~~convert type is $type");
    switch (type) {
      case const (AppResponse<UserInfo>):
        return AppResponse.fromJson(
            json, (dataJson) => UserInfo.fromJson(dataJson)) as T;
      case const (AppResponse<ArticelData>):
        return AppResponse.fromJson(
            json, (dataJson) => ArticelData.fromJson(dataJson)) as T;
      case const (AppResponse<List<BannerEntity>>):
        var res = AppResponse.fromJson(
            json,
            (dataJson) => (dataJson as List<dynamic>)
                .map((e) => BannerEntity.fromJson(e as Map<String, dynamic>))
                .toList());
        return res as T;
      case const (AppResponse<List<ProjectTab>>):
        return AppResponse.fromJson(
            json,
            (dataJson) => (dataJson as List<dynamic>)
                .map((e) => ProjectTab.fromJson(e as Map<String, dynamic>))
                .toList()) as T;
      case const (AppResponse<List<MyCollectWeb>>):
        return AppResponse.fromJson(
            json,
            (dataJson) => (dataJson as List<dynamic>)
                .map((e) => MyCollectWeb.fromJson(e as Map<String, dynamic>))
                .toList()) as T;
      case const (AppResponse<ProjectListData>):
        return AppResponse.fromJson(
            json, (dataJson) => ProjectListData.fromJson(dataJson)) as T;
      case const (AppResponse<List<HotKey>>):
        return AppResponse.fromJson(
            json,
            (dataJson) => (dataJson as List<dynamic>)
                .map((e) => HotKey.fromJson(e as Map<String, dynamic>))
                .toList()) as T;
      default:
        return AppResponse.fromJson(json, (dataJson) => dataJson) as T;
    }
  }

  static jsonString2Map(String jsonStrong) => jsonDecode(jsonStrong);
}
