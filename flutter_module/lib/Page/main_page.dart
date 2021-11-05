// import 'dart:html';

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_module/Model/red_bag_model.dart';
import 'package:flutter_module/Model/task_model.dart';
import 'package:flutter_module/Model/user_model.dart';
import 'package:flutter_module/Page/detail_page.dart';
import 'package:flutter_module/Page/tixian_finish_page.dart';
import 'package:flutter_module/Service/notification_center.dart';
import 'package:flutter_module/const.dart';
import 'package:flutter_module/tools/log.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Network/network.dart';
import '../base_widget.dart';
import 'bind_phone_page.dart';
import 'bind_wx_page.dart';

class MainPage extends StatefulWidget {
  UserModel userModel;
  MainPage({this.userModel});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _imageIndex = 0;
  var _curBtnIndex = 0;
  var _imageFlags = ['chosen', 'grey', 'grey', 'grey', 'grey', 'grey'];
  List _btnColorState = [1, 0, 0, 0, 0, 0];
  var _moneyConfigList = [];
  var _exchange_id_list = [];
  RedBagModel _redBagModel;
  TaskModel _taskModel;
  int _needMoney = 10;
  bool _refreshUI = false;
  static const _methodChannel = const MethodChannel('methodChannel_mainPage');

  static const EventChannel _eventChannel = const EventChannel('eventChannel');

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    /// 路由订阅
    // routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    // routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _imageIndex = 0;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/3.0x/zjm/zjm_bg@3x.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                  child: Container(
                child: ListView(
                  children: [
                    appBarWidget(),
                    lingQianCell(), //我的零钱ƒ

                    (_taskModel != null && _taskModel.app_icon != null)
                        ? taskCell()
                        : Container(), //任务Cell
                    (_redBagModel != null)
                        ? tixianCell(context)
                        : Container(), //提现Cell
                    (_redBagModel != null) ? tixianBtn() : Container() //提现按钮
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    printLog('===initState===', StackTrace.current);
    invokeOCMethed('flutter_page_show');
    // NotificationCenter.instance.addObserver('MainPage_to_refresh', (object) {
    //   printLog('MainPage_to_refresh$object', StackTrace.current);
    //   widget.userModel = object;
    //   requestData();
    // });

    NotificationCenter.instance.addObserver('main_updata', (object) {
      printLog('main_updata:$object', StackTrace.current);
      printLog('============main_updata to requestData===========',
          StackTrace.current);
      if (object is UserModel) {
        widget.userModel = object;
        requestData();
      }
    });

    // getUserData().then((userData) {
    //   if (widget.userModel == null && userData != null) {
    //     widget.userModel = UserModel.fromJson(userData);
    //   }
    // });
    printLog(widget.userModel, StackTrace.current);
    if (widget.userModel == null) {
      printLog(widget.userModel, StackTrace.current);
      return;
    }

    requestData();

    //方法回调
    _methodChannel.setMethodCallHandler((MethodCall call) {
      if (call.method == 'bind_udid_params') {
        printLog(call.arguments, StackTrace.current);

        Map map = new Map<String, dynamic>.from(call.arguments);
        printLog(call.method, StackTrace.current);
        requestBindUDID(map).then((data) {
          if (data['code'] == 200) {
            widget.userModel.is_bind_udid = '1';
            saveUserData(jsonEncode(widget.userModel.toJson()));
          } else {
            printLog('绑定udid失败', StackTrace.current);
          }
          printLog(data, StackTrace.current);
        });
      }
    });
  }

  void requestData() {
    printLog('============requestData===========', StackTrace.current);
    saveUserData(jsonEncode(widget.userModel.toJson()));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        Loading.showLoading(context);
      }
    });

    _moneyConfigList = [];
    _exchange_id_list = [];
    //请求红包
    invokeOCMethed('all_params')
        .then((value) => requestRedbag(value).then((response) {
              int code = response['code'];
              printLog('requestRedbag', StackTrace.current);
              printLog(response, StackTrace.current);
              if (code == 200) {
                var data = response['data'];
                _redBagModel = RedBagModel.fromJson(data);
                List exchange_list = _redBagModel.exchange_list;

                exchange_list.forEach((element) {
                  Map map = element as Map;
                  _moneyConfigList.add(map['cash']);
                  _exchange_id_list.add(map['id']);
                });
                _moneyConfigList.sort();
                _exchange_id_list.sort();
              } else {
                _redBagModel = null;
              }
              if (_refreshUI) {
                // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //   if (mounted) {
                //     Loading.hideLoading(context);
                //     setState(() {});
                //   }
                // });
                if (mounted) {
                  Loading.hideLoading(this.context);
                  printLog('=====setState====', StackTrace.current);
                  setState(() {});
                } else {
                  Future.delayed(const Duration(seconds: 1), () {
                    if (mounted) {
                      //延时执行的代码
                      Loading.hideLoading(this.context);
                      setState(() {});
                    }
                  });
                }
              } else {
                if (mounted) {
                  _refreshUI = true;
                }
              }
            }));

    //请求任务
    invokeOCMethed('all_params').then((value) =>
        requestTaskList(value).then((data) {
          int code = data['code'];

          if (code == 200) {
            var doing_task = data['data']['doing_task'];
            if (doing_task is List) {
              if (doing_task.length > 0) {
                data =
                    new Map<String, dynamic>.from((doing_task as List).first);
              }
            } else if (doing_task is Map) {
              if ((doing_task as Map).keys.length > 0) {
                data = new Map<String, dynamic>.from((doing_task as Map));
              }
            }
            _taskModel = TaskModel.fromJson(data);
          } else {
            _taskModel = null;
          }

          if (_refreshUI) {
            if (mounted) {
              Loading.hideLoading(this.context);
              printLog('=====setState====', StackTrace.current);
              setState(() {});
            } else {
              Future.delayed(const Duration(seconds: 1), () {
                //延时执行的代码
                if (mounted) {
                  Loading.hideLoading(this.context);
                  setState(() {});
                }
              });
            }
          } else {
            if (mounted) {
              _refreshUI = true;
            }
          }
        }));
  }

  void onBackPressed(BuildContext context) {
    NavigatorState navigatorState = Navigator.of(context);
    if (navigatorState.canPop()) {
      invokeOCMethed('flutter_page_kill');
      navigatorState.pop();
    } else {
      invokeOCMethed('flutter_page_kill');
      SystemNavigator.pop();
    }
  }

  Widget appBarWidget() {
    return AppBarView(
      title: '试玩奖励',
      callback: () {
        printLog('点击返回', StackTrace.current);
        onBackPressed(context);
        // MethodChannel('methodChannel_mainPage').invokeMapMethod('exit');
        // BasicMessageChannel('messageChannel', StandardMessageCodec())
        //     .send('exit');
      },
    );
  }

  Container lingQianCell() {
    return Container(
      height: 146 * ScaleW(context),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/3.0x/zjm/zjm_box_-1@3x.png"),
          // fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 28 * ScaleW(context)),
                  alignment: Alignment.center,
                  child: Text(
                    '我的零钱',
                    style: TextStyle(
                        color: Color.fromRGBO(26, 26, 26, 1.0),
                        fontSize: 17 * ScaleW(context),
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          //我的零钱图片
          Container(
            margin: EdgeInsets.only(left: 28 * ScaleW(context)),
            child: Row(
              children: [
                Text(
                  '¥ ',
                  style: TextStyle(
                      // height: 1,
                      color: Color.fromRGBO(106, 191, 56, 1.0),
                      fontSize: 31 * ScaleW(context),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  (_redBagModel != null && _redBagModel.my_red_bag != null)
                      ? _redBagModel.my_red_bag
                      : '0.00',
                  style: TextStyle(
                      // height: 1,
                      color: Color.fromRGBO(106, 191, 56, 1.0),
                      fontSize: 47 * ScaleW(context),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ), //0.00
          Container(
              margin: EdgeInsets.only(left: 28 * ScaleW(context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '今日收益',
                    style: TextStyle(
                      color: Color.fromRGBO(217, 25, 63, 1.0),
                      // fontWeight: FontWeight.w500,
                      fontSize: 15 * ScaleW(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    (_redBagModel != null && _redBagModel.today_red_bag != null)
                        ? _redBagModel.today_red_bag
                        : '0.00',
                    style: TextStyle(
                      color: Color.fromRGBO(217, 25, 63, 1.0),
                      fontWeight: FontWeight.w500,
                      fontSize: 15 * ScaleW(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '元，累计收入',
                    style: TextStyle(
                      color: Color.fromRGBO(217, 25, 63, 1.0),
                      // fontWeight: FontWeight.w500,
                      fontSize: 15 * ScaleW(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    (_redBagModel != null &&
                            _redBagModel.history_red_bag != null)
                        ? _redBagModel.history_red_bag
                        : '0.00',
                    style: TextStyle(
                      color: Color.fromRGBO(217, 25, 63, 1.0),
                      fontWeight: FontWeight.w500,
                      fontSize: 15 * ScaleW(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '元',
                    style: TextStyle(
                      color: Color.fromRGBO(217, 25, 63, 1.0),
                      // fontWeight: FontWeight.w500,
                      fontSize: 15 * ScaleW(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
        ],
      ), //收益、收入
    );
  }

  GestureDetector taskCell() {
    return GestureDetector(
      onTap: () async {
        printLog('点击任务cell', StackTrace.current);

        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    DetailPage(_taskModel, widget.userModel)))
            .then((userModel) {
          printLog('返回回传:$userModel', StackTrace.current);
          if (userModel != null && userModel is UserModel) {
            widget.userModel = userModel;
            printLog('反向回传:$userModel', StackTrace.current);
            requestData();
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 10 * ScaleW(context)),
        padding: EdgeInsets.only(
            left: 28 * ScaleW(context), right: 28 * ScaleW(context)),
        height: 85 * ScaleW(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/3.0x/zjm/zjm_box_01@3x.png"),
            // fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  // margin: EdgeInsets.only(left: 28 * ScaleW(context)),
                  width: 52.0 * ScaleW(context),
                  height: 52.0 * ScaleW(context),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(_taskModel.app_icon),
                      // fit: BoxFit.cover
                    ),
                  ),
                ) //头像
                // Image(
                //   image: AssetImage('images/main/swjl_bg5_@3x.png'),
                //   width: 72 * ScaleW(context),
                // ), //头像边框
                // _taskModel.app_icon != null
                //     ? Image.network(_taskModel.app_icon)
                //     : Image(
                //         image: AssetImage('images/main/swjl_bg5_@3x.png'),
                //         width: 65 * ScaleW(context),
                //       ) //头像
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    (_taskModel != null)
                        ? _taskModel.app_name.substring(0, 1) + '***'
                        : '',
                    style: TextStyle(
                        color: Color.fromRGBO(250, 250, 250, 1.0),
                        fontWeight: FontWeight.bold,
                        fontSize: 17 * ScaleW(context)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    '进行中...',
                    style: TextStyle(
                        color: Color.fromRGBO(250, 250, 250, 1.0),
                        fontWeight: FontWeight.w500,
                        fontSize: 11 * ScaleW(context)),
                  ),
                ),
              ],
            ), //app名称

            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  // margin: EdgeInsets.only(right: 28 * ScaleW(context)),
                  child: Text(
                    _taskModel.reward_amount != null
                        ? '¥' + _taskModel.reward_amount.toString()
                        : ' ¥0',
                    style: TextStyle(
                        color: Color.fromRGBO(250, 250, 250, 1.0),
                        fontWeight: FontWeight.bold,
                        fontSize: 30 * ScaleW(context)),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  Container tixianCell(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15 * ScaleW(context)),
      height: 269 * ScaleW(context),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 28 * ScaleW(context)),
                alignment: Alignment.center,
                child: Text(
                  '微信提现',
                  style: TextStyle(
                      color: Color.fromRGBO(26, 26, 26, 1.0),
                      fontWeight: FontWeight.bold,
                      fontSize: 21 * ScaleW(context)),
                ),
              )
            ],
          ), //title标题

          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _moneyConfigList.length > 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10 * ScaleW(context)),
                          child: FlatButton(
                            onPressed: () {
                              clickeMoneyBtn(0);
                              setState(() {});
                              // Navigator.pop(context);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image(
                                  height: 40 * ScaleW(context),
                                  image: AssetImage(
                                      'images/3.0x/tx/wxtx/wxtx_btm_${_imageFlags[_imageIndex++]}@3x.png'),
                                ),
                                Text(
                                  _moneyConfigList[0].toString() + '元',
                                  style: TextStyle(
                                      color: _btnColorState[0] == 1
                                          ? Color.fromRGBO(106, 191, 56, 1.0)
                                          : Color.fromRGBO(26, 26, 26, 1.0),
                                      fontSize: 19 * ScaleW(context),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 10 * ScaleW(context)),
                          child: FlatButton(
                            onPressed: () {
                              clickeMoneyBtn(1);

                              setState(() {});
                              // Navigator.pop(context);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image(
                                  height: 40 * ScaleW(context),
                                  image: AssetImage(
                                      'images/3.0x/tx/wxtx/wxtx_btm_${_imageFlags[_imageIndex++]}@3x.png'),
                                ),
                                Text(
                                  _moneyConfigList[1].toString() + '元',
                                  style: TextStyle(
                                      color: _btnColorState[1] == 1
                                          ? Color.fromRGBO(106, 191, 56, 1.0)
                                          : Color.fromRGBO(26, 26, 26, 1.0),
                                      fontSize: 19 * ScaleW(context),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )),
                    ],
                  )
                : Container(),
            _moneyConfigList.length > 3
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 15),
                          child: FlatButton(
                            onPressed: () {
                              clickeMoneyBtn(2);
                              setState(() {});
                              // Navigator.pop(context);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image(
                                  height: 40 * ScaleW(context),
                                  image: AssetImage(
                                      'images/3.0x/tx/wxtx/wxtx_btm_${_imageFlags[_imageIndex++]}@3x.png'),
                                ),
                                Text(
                                  _moneyConfigList[2].toString() + '元',
                                  style: TextStyle(
                                      color: _btnColorState[2] == 1
                                          ? Color.fromRGBO(106, 191, 56, 1.0)
                                          : Color.fromRGBO(26, 26, 26, 1.0),
                                      fontSize: 19 * ScaleW(context),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 15),
                          child: FlatButton(
                            onPressed: () {
                              clickeMoneyBtn(3);
                              setState(() {});
                              // Navigator.pop(context);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image(
                                  height: 40 * ScaleW(context),
                                  image: AssetImage(
                                      'images/3.0x/tx/wxtx/wxtx_btm_${_imageFlags[_imageIndex++]}@3x.png'),
                                ),
                                Text(
                                  _moneyConfigList[3].toString() + '元',
                                  style: TextStyle(
                                      color: _btnColorState[3] == 1
                                          ? Color.fromRGBO(106, 191, 56, 1.0)
                                          : Color.fromRGBO(26, 26, 26, 1.0),
                                      fontSize: 19 * ScaleW(context),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )),
                    ],
                  )
                : Container(),
            _moneyConfigList.length > 5
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 15),
                          child: FlatButton(
                            onPressed: () {
                              clickeMoneyBtn(4);
                              setState(() {});
                              // Navigator.pop(context);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image(
                                  height: 40 * ScaleW(context),
                                  image: AssetImage(
                                      'images/3.0x/tx/wxtx/wxtx_btm_${_imageFlags[_imageIndex++]}@3x.png'),
                                ),
                                Text(
                                  _moneyConfigList[4].toString() + '元',
                                  style: TextStyle(
                                      color: _btnColorState[4] == 1
                                          ? Color.fromRGBO(106, 191, 56, 1.0)
                                          : Color.fromRGBO(26, 26, 26, 1.0),
                                      fontSize: 19 * ScaleW(context),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 15),
                          child: FlatButton(
                            onPressed: () {
                              clickeMoneyBtn(5);
                              setState(() {});
                              // Navigator.pop(context);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image(
                                  height: 40 * ScaleW(context),
                                  image: AssetImage(
                                      'images/3.0x/tx/wxtx/wxtx_btm_${_imageFlags[_imageIndex++]}@3x.png'),
                                ),
                                Text(
                                  _moneyConfigList[5].toString() + '元',
                                  style: TextStyle(
                                      color: _btnColorState[5] == 1
                                          ? Color.fromRGBO(106, 191, 56, 1.0)
                                          : Color.fromRGBO(26, 26, 26, 1.0),
                                      fontSize: 19 * ScaleW(context),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )),
                    ],
                  )
                : Container(),
          ]), //money按钮
          Container(
            margin: EdgeInsets.only(top: 10, left: 28 * ScaleW(context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '所需零钱',
                  style: TextStyle(
                      color: Color.fromRGBO(26, 26, 26, 1.0),
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * ScaleW(context)),
                ),
                Text(
                  '$_needMoney元',
                  style: TextStyle(
                      color: Color.fromRGBO(244, 67, 54, 1.0),
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * ScaleW(context)),
                ),
                Text(
                  '，当前零钱',
                  style: TextStyle(
                      color: Color.fromRGBO(26, 26, 26, 1.0),
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * ScaleW(context)),
                ),
                Text(
                  (_redBagModel != null && _redBagModel.my_red_bag != null)
                      ? _redBagModel.my_red_bag.toString() + '元'
                      : '0.00元',
                  style: TextStyle(
                      color: Color.fromRGBO(244, 67, 54, 1.0),
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * ScaleW(context)),
                ),
              ],
            ), //底部文字
          ),
        ],
      ),
    );
  }

  Container tixianBtn() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          FlatButton(
            onPressed: () {
              //余额判断
              if (double.parse(_redBagModel.my_red_bag) < _needMoney) {
                Fluttertoast.showToast(
                  msg: "可提余额不足",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                );
                //
                return;
              }

              // //udid绑定
              if (widget.userModel.is_bind_udid == '0') {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogAppleCertification(() {
                        invokeOCMethed('openUir');
                      });
                    });
                return;
              }

              //手机绑定
              if (widget.userModel.is_bind_phone == 0) {
                showDialog<String>(
                    context: this.context,
                    builder: (BuildContext context) {
                      return MyAlert(
                          aTitle: '温馨提示',
                          aContent: '为保证您的账户资金安全，首次提现前必须绑定手机',
                          okBtntitle: '去绑定',
                          cancelBtntitle: '取消',
                          callback: (tag) {
                            if (tag == 1) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BindPhonePage(widget.userModel)));
                            }
                          });
                    });
                return;
              }

              //微信绑定
              if (widget.userModel.is_bind_wx == 0) {
                showDialog<String>(
                    context: this.context,
                    builder: (BuildContext context) {
                      return MyAlert(
                          aTitle: '温馨提示',
                          aContent: '为了您的账户安全，完成微信绑定后，即可安心提现',
                          okBtntitle: '去绑定',
                          cancelBtntitle: '取消',
                          callback: (tag) {
                            if (tag == 1) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BindWXPage(widget.userModel)));
                            }
                          });
                    });
                return;
              }

              //展示提现到微信页面
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogTxqr(
                        '小明', _needMoney.toString() + '元', '提现至微信零钱', () {
                      Loading.showLoading(this.context);
                      invokeOCMethed('all_params').then((params) {
                        params['exchange_id'] =
                            _exchange_id_list[_curBtnIndex].toString();
                        params['cash_type'] = 'wechat';
                        requestApplyWithdrawal(params).then((data) {
                          Loading.hideLoading(this.context);
                          int code = data['code'];
                          if (code == 200) {
                            invokeOCMethed('draw_success');
                            Navigator.of(this.context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    TixianFinish()));
                          } else {
                            String msg = data['msg'];
                            showDialog<String>(
                                context: this.context,
                                builder: (BuildContext context) {
                                  return MyAlert(
                                      aTitle: '提现申请失败',
                                      aContent: msg,
                                      okBtntitle: '知道了',
                                      callback: (tag) {
                                        // onBackPressed(context);
                                      });
                                  onBackPressed(this.context);
                                });
                          }
                        });
                      });
                    });
                  });
              // },
            }, // () {

            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image(
                      height: 42 * ScaleW(context),
                      image: AssetImage("images/3.0x/tx/wxtx/wxtx_btm@3x.png"),
                    ),
                    Text(
                      '立即提现',
                      style: TextStyle(
                          color: Color.fromRGBO(250, 250, 250, 1.0),
                          fontWeight: FontWeight.bold,
                          fontSize: 15 * ScaleW(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, top: 20 * ScaleW(context)),
            child: Text(
              '10:00-17:00间发起的提现预计3小时内审核完毕，晚间非工作时间发起的提现预计次日12:00前审核完毕。请合理安排提现时间',
              style: TextStyle(
                  color: Color.fromRGBO(92, 92, 92, 1.0),
                  fontSize: 13 * ScaleW(context),
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  void clickeMoneyBtn(int index) {
    _imageFlags.setAll(0, [
      'grey',
      'grey',
      'grey',
      'grey',
      'grey',
      'grey',
    ]);
    _btnColorState.setAll(0, [
      0,
      0,
      0,
      0,
      0,
      0,
    ]);
    _needMoney = _moneyConfigList[index];
    _imageFlags.setRange(index, index + 1, ['chosen']);
    _btnColorState.setRange(index, index + 1, [1]);
    printLog("点击Money按钮 $_imageFlags", StackTrace.current);
  }
}
