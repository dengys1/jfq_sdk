import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioManager {
  static DioManager _instance;
  static DioManager getInstance() {
    if (_instance == null) {
      _instance = DioManager();
    }
    return _instance;
  }

  Dio dio = Dio();
  DioManager() {
    dio.options.baseUrl = 'https://jfq-on.soulgame.mobi';
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    // dio.options.contentType = 'application/x-www-form-urlencoded';
    dio.interceptors.add(LogInterceptor(requestBody: true));
    //  dio.interceptors.add(CookieManager(CookieJar()));//缓存相关类，具体设置见https://github.com/flutterchina/cookie_jar
  }

  //get请求
  get(String url, FormData params, Function successCallBack,
      Function errorCallBack) async {
    _requestHttpMethod(url, successCallBack, 'get', params, errorCallBack);
  }

  //post请求
  post(String url, params, Function successCallBack,
      Function errorCallBack) async {
    _requestHttpMethod(url, successCallBack, "post", params, errorCallBack);
  }

  post_sdk(String url, params, Function successCallBack,
      Function errorCallBack) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userData = prefs.getString('userData');
    //
    // // printLog(jsongString, StackTrace.current);
    var userMap = jsonDecode(userData);
    // printLog(userinfo, StackTrace.current);
    // UserModel userModel = UserModel.fromJson(userinfo);
    String data = userMap['uid'].toString() + userMap['token'].toString();
    var content = utf8.encode(data);
    var base64 = base64Encode(content);
    var header = {'Authorization': base64};
    // printLog(header, StackTrace.current);

    _requestHttpMethod(
        url, successCallBack, "post", params, errorCallBack, header);
  }

  //post请求
  postNoParams(
      String url, Function successCallBack, Function errorCallBack) async {
    _requestHttpMethod(url, successCallBack, "post", null, errorCallBack);
  }

  // 请求的主体
  _requestHttpMethod(String url, Function successCallBack,
      [String method,
      FormData params,
      Function errorCallBack,
      Map headers]) async {
    Response response;
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String jsongString = prefs.getString('userjson');
      //
      // // printLog(jsongString, StackTrace.current);
      // var userinfo = json.decode(jsongString);
      // printLog(userinfo, StackTrace.current);
      // UserModel userModel = UserModel.fromJson(userinfo);
      // String data = userinfo['uid'].toString() + userinfo['token'].toString();
      // var content = utf8.encode(data);
      // var base64 = base64Encode(content);
      // var header = {'Authorization': base64};
      // printLog(header, StackTrace.current);

      if (headers is Map && headers.isNotEmpty) {
        dio.options.headers = headers;
      }

      if (method == 'get') {
        if (params != null) {
          response = await dio.get(url,
              queryParameters: Map.fromEntries(params.fields));
        } else {
          response = await dio.get(url);
        }
      } else if (method == 'post') {
        if (params != null && params.fields.isNotEmpty) {
          response = await dio.post(
            url,
            data: params,
          );
        } else {
          response = await dio.post(url);
        }
      }
    } on DioError catch (error) {
      // 请求错误处理
      Response errorResponse;
      if (error.response != null) {
        errorResponse = error.response;
      } else {
        errorResponse = new Response(statusCode: 201);
      }
      _error(errorCallBack, error.message);
      return '';
    }

    String dataStr = json.encode(response.data);
    Map<String, dynamic> dataMap = json.decode(dataStr);
    if (dataMap == null || dataMap['code'] != 200) {
      _error(errorCallBack, dataMap['msg'].toString());
    } else if (successCallBack != null) {
      successCallBack(dataMap);
    }
  }

  // 请求错误返回
  _error(Function errorCallBack, String error) {
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }
}
