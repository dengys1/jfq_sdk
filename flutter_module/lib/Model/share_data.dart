import 'package:flutter_module/Model/red_bag_model.dart';
import 'package:flutter_module/Model/task_model.dart';
import 'package:flutter_module/Model/user_model.dart';

class ShareData {
  factory ShareData() => shared();
  static ShareData _instance;
  ShareData._() {}
  static ShareData shared() {
    if (_instance == null) {
      _instance = ShareData._();
    }
    return _instance;
  }
  //添加一个属性 通过单例来缓存属性值

  UserModel userModel;
  RedBagModel redBagModel;
  TaskModel taskModel;
}
