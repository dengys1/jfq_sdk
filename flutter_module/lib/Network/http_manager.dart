import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_module/Network/network.dart';
import 'package:flutter_module/tools/log.dart';

enum Method { get, post }

class HttpManager {
  static final Dio dio = Dio();

  static Future request(String url,
      {Method method = Method.get,
      Map<String, dynamic> headers,
      Map<String, dynamic> queryParameters,
      int timeout}) {
    var type = method;

    var options = Options(method: 'get');
    switch (type) {
      case Method.get:
        options = Options(
          method: 'get',
        );
        break;
      case Method.post:
        options = Options(method: 'post');
        break;
    }

    if (headers is Map && headers != null) {
      options.headers = headers;
      printLog(options.headers, StackTrace.current);
    }
    printLog('请求地址:$url', StackTrace.current);
    printLog('请求提交参数:$queryParameters', StackTrace.current);
    return dio.request(url, queryParameters: queryParameters, options: options);
  }
}

Future<Response> get(url,
    {Map<String, dynamic> headers,
    Map<String, dynamic> queryParameters,
    int timeout}) {
  return HttpManager.request(url,
      queryParameters: queryParameters, method: Method.get, timeout: timeout);
}

Future<Response> post_sdk(url,
    {Map<String, dynamic> queryParameters, int timeout}) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // String userData = prefs.getString('KUserData');
  Map userMap = await getUserData();
  printLog('userMap.runtimeType', StackTrace.current);
  printLog(userMap.runtimeType, StackTrace.current);

  String data = userMap['uid'].toString() + ':' + userMap['token'].toString();
  var content = utf8.encode(data);
  var base64 = base64Encode(content);
  var headers = {'Authorization': base64};
  printLog(data, StackTrace.current);
  var uri = '';
  uri = 'https://jfq-on.soulgame.mobi' + url;
  return HttpManager.request(uri,
      headers: headers,
      queryParameters: queryParameters,
      method: Method.post,
      timeout: timeout);
}

Future<Response> post(url,
    {Map<String, dynamic> headers,
    Map<String, dynamic> queryParameters,
    int timeout}) {
  var uri = '';
  uri = 'https://jfq-on.soulgame.mobi' + url;
  return HttpManager.request(uri,
      headers: headers,
      queryParameters: queryParameters,
      method: Method.post,
      timeout: timeout);
}
