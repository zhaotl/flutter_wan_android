import 'package:flutter_wan_android/constants/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class AppResponse<T> {
  @JsonKey(name: "data")
  T? data;
  @JsonKey(name: "errorCode")
  int? errorCode;
  @JsonKey(name: "errorMsg")
  String? errorMsg;

  AppResponse({this.data, this.errorCode, this.errorMsg});

  factory AppResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic json) fromJsonT) {
    return _$AppResponseFromJson(json, fromJsonT);
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$AppResponseToJson(this, toJsonT);

  bool get isSuccessful => errorCode == Constant.successCode;
}
