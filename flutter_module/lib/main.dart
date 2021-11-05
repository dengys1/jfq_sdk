import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/Model/task_model.dart';
import 'package:flutter_module/Model/user_model.dart';
import 'package:flutter_module/Page/detail_page.dart';
import 'package:flutter_module/tools/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Page/main_page.dart';
import 'Service/notification_center.dart';

final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();
void main() {
  SharedPreferences.setMockInitialValues(
      {}); //不然会报错，MissingPluginException(No implementation found for method getAll on channel
  runApp(MyApp());
}

/// smart://template/flutter?page=order&params=jsonString"

/// 继承自 StatefulWidget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// 实例化一个 MethodChannel
  MethodChannel _methodChannel = MethodChannel('methodChannel_InitRoute');

  /// Flutter 页面入口
  // Widget _initRoute = MainPage();

  UserModel _userModel;
  TaskModel _taskModel;
  String _routeId;
  @override
  void initState() {
    super.initState();

    printLog('MyApp initState', StackTrace.current);
    // 设置 MethodCallHandler 接收来自 Android 的消息
    _methodChannel.setMethodCallHandler((call) async {
      Map map = new Map<String, dynamic>.from(call.arguments);
      String task_id = map["task_id"];
      String type = map["type"];
      String userJson = map["userJson"];
      Map userData = new Map<String, dynamic>.from(jsonDecode(userJson));
      printLog('userModel', StackTrace.current);
      UserModel userModel = UserModel.fromJson(userData);
      printLog(userModel, StackTrace.current);
      TaskModel taskModel = TaskModel(task_id: task_id, type: type);
      _userModel = userModel;
      _taskModel = taskModel;

      setState(() {
        _routeId = call.method;
      });
    });
  }

  Widget _rootPage(String routeId) {
    print('======_rootPage======= $routeId');
    switch (routeId) {
      case 'detail':
        return DetailPage(_taskModel, _userModel);
      case 'main':
        NotificationCenter.instance.postNotification('main_updata', _userModel);
        return MainPage(userModel: _userModel);
      default:
        print('======_rootPage default======= $routeId');
        return MainPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _rootPage(_routeId),
    );
  }
}
