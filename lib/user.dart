import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_wan_android/network/bean/user_info/user_info.dart';
import 'package:flutter_wan_android/utils/log_util.dart';
import 'package:mmkv/mmkv.dart';

typedef LoginStatusChangeCallback = void Function();

class User extends ChangeNotifier {
  static const String _userInfoKey = "userInfo";

  User._internal();

  static User? _singleton;

  static User get instance {
    _singleton ??= User._internal();

    return _singleton!;
  }

  factory User() => User.instance;

  UserInfo? _userInfo;

  bool isLoggedIn() => _userInfo != null;

  String get userName => _userInfo?.username ?? "";

  int get userCoinCount => _userInfo?.coinCount ?? 0;

  final List<LoginStatusChangeCallback> _list = [];

  on(LoginStatusChangeCallback loginStatusChange) {
    _list.add(loginStatusChange);
  }

  off(LoginStatusChangeCallback loginStatusChange) {
    _list.remove(loginStatusChange);
  }

  void loadFromLocal() {
    try {
      MMKV mmkv = MMKV.defaultMMKV();
      String? infoContent = mmkv.decodeString(_userInfoKey);
      if (infoContent != null && infoContent.isNotEmpty) {
        _userInfo = UserInfo.fromJson(json.decoder.convert(infoContent));
      }
    } catch (e) {
      Wanlog.e('Get user info from local error - $e');
    }
  }

  void loginSuccess(UserInfo userInfo) {
    _userInfo = userInfo;
    try {
      MMKV mmkv = MMKV.defaultMMKV();
      String info = _userInfo.toString();
      mmkv.encodeString(_userInfoKey, info);
    } catch (e) {
      Wanlog.e('login error $e');
    }
    notifyListeners();
    for (var callback in _list) {
      callback();
    }
  }

  void logout() {
    // Todo:
  }
}
