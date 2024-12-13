import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_wan_android/constants/constants.dart';
import 'package:flutter_wan_android/network/bean/app_response/app_response.dart';
import 'package:flutter_wan_android/network/bean/dto_data_convert.dart';
import 'package:flutter_wan_android/user.dart';
import 'package:flutter_wan_android/utils/log_util.dart';
import 'package:path_provider/path_provider.dart';

bool useComute = false;
bool configured = false;

Duration _connectTimeout = const Duration(seconds: 30);
Duration _receivedTimeout = const Duration(seconds: 30);
Duration _sendTimeout = const Duration(seconds: 10);
late String _baseUrl;
List<Interceptor> _interceptors = [];

void configDio(String baseUrl,
    {Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    List<Interceptor>? interceptors}) {
  _baseUrl = baseUrl;
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receivedTimeout = receiveTimeout ?? _receivedTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _interceptors = interceptors ?? _interceptors;
  configured = true;
}

class HttpGo {
  late Dio _dio;

  static final HttpGo _singleton = HttpGo._internal();

  static HttpGo get instance => _singleton;

  CookieJar? cookieJar;

  HttpGo._internal() {
    if (configured == false) {
      Wanlog.d("You have not configed the dio");
      return;
    }

    _dio = Dio(BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receivedTimeout,
        sendTimeout: _sendTimeout,
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain));

    Future<Directory> resultDir = getApplicationDocumentsDirectory();
    resultDir.then((value) {
      CookieManager cookieManager = CookieManager(
          PersistCookieJar(storage: FileStorage("${value.path}/.cookies/")));
      cookieJar = cookieManager.cookieJar;
      _dio.interceptors.add(cookieManager);
    });
    _dio.interceptors.addAll(_interceptors);
  }

  Future<T> request<T>(String url, String method,
      {Object? data,
      Map<String, dynamic>? parameters,
      CancelToken? cancelToken,
      Options? options,
      ProgressCallback? progressCallback,
      ProgressCallback? receiveCallback}) async {
    AppResponse result;
    try {
      Response<String> response = await _dio.request(url,
          data: data,
          queryParameters: parameters,
          cancelToken: cancelToken,
          options: Options(method: method),
          onSendProgress: progressCallback,
          onReceiveProgress: receiveCallback);
      Map<String, dynamic> map = json.decode(response.data.toString());
      result = DtoDataConvert.convertWrapper(T, map);
      if (result.errorCode == Constant.invalidateToken) {
        User().logout();
      }
    } on DioException catch (e) {
      Wanlog.e('request error -- $e');
      result = AppResponse(
          data: null,
          errorCode: Constant.otherError,
          errorMsg: e.message ?? "");
    }
    return result as T;
  }

  Future<T> get<T>(String url,
      {Map<String, dynamic>? parameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? receiveCallback}) async {
    Wanlog.d('~~~~~~ start http get method');
    Response<String> response = await _dio.get(url,
        queryParameters: parameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: receiveCallback);
    Wanlog.d('~~~~~~ end http get method. response = $response');
    Map<String, dynamic> map = json.decode(response.data.toString());
    return DtoDataConvert.convertWrapper<T>(T, map);
  }

  Future<T> post<T>(String url,
      {Object? data,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? progressCallback,
      ProgressCallback? receiveCallback}) async {
    Wanlog.d('~~~~~~ start http post method');
    var response = await _dio.post(url,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: progressCallback,
        onReceiveProgress: receiveCallback);
    Wanlog.d('~~~~~~ end http post method. response = $response');
    Map<String, dynamic> map = json.decode(response.data.toString());
    return DtoDataConvert.convertWrapper<T>(T, map);
  }

  Future<AppResponse<T>> delete<T>(String url,
      {Map<String, dynamic>? parameters,
      Options? options,
      CancelToken? cancelToken}) async {
    var response = await _dio.delete(url,
        queryParameters: parameters,
        options: options,
        cancelToken: cancelToken);
    return DtoDataConvert.convertWrapper(T, response.data);
  }

  Future<AppResponse<T>> put<T>(String url,
      {Object? data,
      Map<String, dynamic>? parameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? progressCallback,
      ProgressCallback? receiveCallback}) async {
    var response = await _dio.put(url,
        data: data,
        queryParameters: parameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: progressCallback,
        onReceiveProgress: receiveCallback);
    return DtoDataConvert.convertWrapper(T, response.data);
  }
}
