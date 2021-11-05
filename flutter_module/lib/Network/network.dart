import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/Network/http_manager.dart' as http;
import 'package:flutter_module/tools/log.dart';
import 'package:flutter_module/tools/tool.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> requestLogin(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  Response response =
      await http.post('/user/login', queryParameters: params, timeout: 10);
  Map userData = new Map<String, dynamic>.from(response.data['data']);
  return userData;
}

Future<Map> requestRedbag(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response = await http.post_sdk('/wallet/my-bag',
      queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);
  // Map data = new Map<String, dynamic>.from(response.data['data']);
  printLog(response.data, StackTrace.current);
  return response.data;
}

Future<dynamic> requestTaskList(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response = await http.post_sdk('/try-play/list',
      queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);

  return response.data;
}

Future<Map> requestBindUDID(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response = await http.post_sdk('/user/bind-udid',
      queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);
  Map data = new Map<String, dynamic>.from(response.data);
  return data;
}

Future<Map> requestGetSmsCode(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response =
      await http.post_sdk('/sms/send', queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);
  Map data = new Map<String, dynamic>.from(response.data);
  return data;
}

Future<Map> requestBindPhone(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response =
      await http.post_sdk('/user/bind', queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);
  Map data = new Map<String, dynamic>.from(response.data);
  return data;
}

Future<Map> requestBindWX(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response = await http.post_sdk('/user/bind-wx',
      queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);
  Map data = new Map<String, dynamic>.from(response.data);
  return data;
}

Future<Map> requestApplyWithdrawal(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response = await http.post_sdk('/wallet/new-apply-withdrawal',
      queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);
  Map data = new Map<String, dynamic>.from(response.data);
  return data;
}

Future<Map> requestTaskDetail(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response = await http.post_sdk('/try-play/detail',
      queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);
  Map data = new Map<String, dynamic>.from(response.data);
  return data;
}

//放弃任务
Future<Map> requestUnsubscribe(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response = await http.post_sdk('/try-play/unsubscribe',
      queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);
  Map data = new Map<String, dynamic>.from(response.data);
  return data;
}

//抢任务
Future<Map> requestSubscribe(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response = await http.post_sdk('/try-play/subscribe',
      queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);
  Map data = new Map<String, dynamic>.from(response.data);
  return data;
}

//领取奖励
Future<Map> requestReward(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response = await http.post_sdk('/try-play/reward',
      queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);
  Map data = new Map<String, dynamic>.from(response.data);
  return data;
}

//开始试玩
Future<Map> requestStart(Map params) async {
  params['sign'] = MD5Util.generateMd5(params);
  final response = await http.post_sdk('/try-play/start',
      queryParameters: params, timeout: 10);
  printLog(response.data, StackTrace.current);
  Map data = new Map<String, dynamic>.from(response.data);
  return data;
}

Future<dynamic> invokeOCMethed(String methed) async {
  printLog('调用oc的$methed', StackTrace.current);
  final params =
      await MethodChannel('methodChannel_mainPage').invokeMethod(methed);
  printLog('收到oc的$methed回调', StackTrace.current);
  printLog(params.runtimeType, StackTrace.current);
  if (params is String) {
    return params;
  }
  Map map = new Map<String, dynamic>.from(params);
  return map;
}

Future<dynamic> invokeOCMethed2(String methed, dynamic arguments) async {
  printLog('调用oc的$methed', StackTrace.current);
  printLog('调用oc的$arguments', StackTrace.current);
  final params = await MethodChannel('methodChannel_mainPage')
      .invokeMethod(methed, arguments);

  printLog('收到oc的$params', StackTrace.current);
  printLog('收到oc的$methed回调', StackTrace.current);
  printLog(params.runtimeType, StackTrace.current);
  if (params is String) {
    return params;
  }
  Map map = new Map<String, dynamic>.from(params);
  return map;
}

Future<String> saveUserData(String jsonString) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // String jsonString = jsonEncode(userData);
  await prefs.setString("kUserData", jsonString);
  printLog('saveUserData:$jsonString', StackTrace.current);
  return jsonString;
}

//
Future<Map> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = prefs.getString("kUserData");
  if (jsonString != null) {
    Map userData = jsonDecode(jsonString);
    printLog('getUserData:$userData', StackTrace.current);
    return userData;
  }
  return null;
}
