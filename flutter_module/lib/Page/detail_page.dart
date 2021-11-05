import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/Model/share_data.dart';
import 'package:flutter_module/Model/task_model.dart';
import 'package:flutter_module/Model/user_model.dart';
import 'package:flutter_module/Network/network.dart';
import 'package:flutter_module/base_widget.dart';
import 'package:flutter_module/const.dart';
import 'package:flutter_module/tools/log.dart';
import 'package:flutter_module/tools/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sprintf/sprintf.dart';

import '../base_widget.dart';

class DetailPage extends StatefulWidget {
  TaskModel taskModel;
  UserModel userModel;
  DetailPage(this.taskModel, this.userModel);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with WidgetsBindingObserver {
  String _task_keep_min;
  // bool _reward_status = false; //true 试玩完成，按钮设置可领奖状态
  bool _isTryPlaying;
  Timer _timer;
  static const _methodChannel = const MethodChannel('methodChannel_mainPage');
  @override
  initState() {
    printLog('===initState  detail page==', StackTrace.current);
    invokeOCMethed('flutter_page_show');
    // printLog('widget.taskModel', StackTrace.current);
    // printLog(widget.taskModel, StackTrace.current);
    if (widget.taskModel == null) {
      printLog('widget.taskModel', StackTrace.current);
      printLog(widget.taskModel, StackTrace.current);
      return;
    }

    //方法回调
    _methodChannel.setMethodCallHandler((MethodCall call) {
      if (call.method == 'bind_udid_params') {
        printLog(call.arguments, StackTrace.current);

        Map map = new Map<String, dynamic>.from(call.arguments);
        printLog(call.method, StackTrace.current);
        requestBindUDID(map).then((data) {
          if (data['code'] == 200) {
            widget.userModel.is_bind_udid = '1';
          } else {
            printLog('绑定udid失败', StackTrace.current);
          }
          printLog(data, StackTrace.current);
        });
      }
    });

    //监听生命周期
    WidgetsBinding.instance.addObserver(this);

    printLog('=====', StackTrace.current);
    saveUserData(jsonEncode(widget.userModel.toJson()));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Loading.showLoading(context);
    });

    //请求任务详情
    invokeOCMethed('all_params').then((params) {
      params['task_id'] = widget.taskModel.task_id;
      params['type'] = widget.taskModel.type;
      requestTaskDetail(params).then((data) {
        if (data['code'] == 200) {
          widget.taskModel = ShareData.shared().taskModel =
              widget.taskModel = TaskModel.fromJson(data['data']);

          if (widget.taskModel.is_expire) {
            //回调给游戏
            invokeOCMethed2('task_finish', '1');
            cancelTimer();
            //任务过期提示
            taskExpire();
          } else {
            //没过期，启动定时间倒计时
            if (widget.taskModel.pass_secs > 0) {
              //定时器，结束提示，
              _startTimer();
            }
          }
        } else {
          String msg = data['msg'];
          Fluttertoast.showToast(
              msg: '获取任务详情失败:$msg',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              // backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16 * ScaleW(this.context));
          onBackPressed(this.context);
        }
        if (mounted) {
          //定时器在刷新
          Loading.hideLoading(this.context);
          setState(() {});
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            //延时执行的代码
            Loading.hideLoading(this.context);
            setState(() {});
          });
        }
      });
    });
  }

  //任务过期提示
  void taskExpire() {
    var appname = widget.taskModel.app_name;
    showDialog<String>(
        context: this.context,
        builder: (BuildContext context) {
          return MyAlert(
              aTitle: '任务失败',
              aContent: '试玩《' + appname + '》超时，请重新领取',
              okBtntitle: '知道了',
              callback: (tag) {
                printLog('任务过期$appname', StackTrace.current);
                onBackPressed(context);
              });
          onBackPressed(context);
        });
  }

  //更新数据，并提示是否过期
  void updateTaskData() {
    invokeOCMethed('all_params').then((params) {
      params['task_id'] = widget.taskModel.task_id;
      params['type'] = widget.taskModel.type;
      requestTaskDetail(params).then((data) {
        if (data['code'] == 200) {
          printLog('===updateTaskData==', StackTrace.current);

          ShareData.shared().taskModel = widget.taskModel =
              widget.taskModel = TaskModel.fromJson(data['data']);

          if (widget.taskModel.is_expire) {
            //过期
            taskExpire();
          } else {
            //更新定时器时间
            checkTryPlay();
          }
        } else {
          String msg = data['msg'];
          Fluttertoast.showToast(
              msg: '任务失败:$msg',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              // backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16 * ScaleW(this.context));
          onBackPressed(this.context);
        }
      });
    });
  }

  // 启动Timer
  void _startTimer() {
    cancelTimer();
    if (widget.taskModel.pass_secs == null) {
      return;
    }

    int seconds = widget.taskModel.pass_secs % 60; //取余
    int minute = widget.taskModel.pass_secs ~/ 60; //取整;
    String keep_min = sprintf('%02i:%02i', [minute, seconds]);
    _task_keep_min = keep_min;
    //定时器，结束提示，
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      widget.taskModel.pass_secs--;
      seconds = widget.taskModel.pass_secs % 60; //取余
      minute = widget.taskModel.pass_secs ~/ 60; //取整;

      keep_min = sprintf('%02i:%02i', [minute, seconds]);
      printLog(keep_min, StackTrace.current);

      if (mounted) {
        setState(() {
          Loading.hideLoading(context);
        });
      }
      _task_keep_min = keep_min;
      if (widget.taskModel.pass_secs == 0) {
        cancelTimer();
        updateTaskData(); //倒计时间用完，根据网络请求判断是否过期并提示，否则更新定时器时间。
      }
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;

      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        updateTaskData();
        _startTimer();
        break;

      case AppLifecycleState.paused: // 界面不可见，后台
        if (widget.taskModel != null) {
          if (!widget.taskModel.is_expire &&
              !widget.taskModel.is_done &&
              !widget.taskModel.reward_status) {
            cancelTimer();
            //添加本地通知
            invokeOCMethed2('task_start', widget.taskModel.task_id);
          }
        }
        break;
      case AppLifecycleState.detached: // APP结束时调用
        cancelTimer();
        break;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //销毁监听生命周期
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _timer.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/3.0x/rwxq/rwxq_bg@3x.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
                child: Container(
              child: ListView(
                children: [
                  appBarWidget(), //appBar
                  headerCell(context), //头部cell
                  contentCell1(context), //️内容cell1
                  contentCell2(context), //️内容cell2
                  contentCell3(context), //️内容cell3
                ],
              ),
            ))
          ],
        ),
      ),
      onWillPop: () async {
        return false;
      },
    ));
    ;
  }

  Container contentCell3(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 9),
      height: 156 * ScreenWidth(context) / 375,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/3.0x/rwxq/rwxq_bg3_@3x.png"),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20 * ScaleW(context)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Image(
                    //   image: AssetImage('images/rwxq/rwxq_bg1_@3x.png'),
                    //   width: 30 * ScaleW(context),
                    // ),
                    Text(
                      '3',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22 * ScreenWidth(context) / 375,
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25 * ScaleW(context), top: 5),
                child: Text(
                  '点击"开始试玩"体验3分钟',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17 * ScreenWidth(context) / 375,
                    color: Color.fromRGBO(26, 26, 26, 1.0),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: ScreenWidth(context),
            margin: EdgeInsets.only(left: 60 * ScaleW(context), top: 5),
            child: Text(
              '试玩结束后可领取奖励',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 13 * ScreenWidth(context) / 375,
                color: Color.fromRGBO(51, 51, 51, 1.0),
              ),
            ),
          ), //第一行
          Expanded(
            child: FlatButton(
              onPressed: () {
                printLog(widget.taskModel.is_done, StackTrace.current);
                if (widget.taskModel.is_done == false) {
                  return;
                }
                printLog('点击领取奖励', StackTrace.current);

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
                invokeOCMethed('all_params').then((params) {
                  params["task_id"] = widget.taskModel.task_id;
                  params['type'] = widget.taskModel.type;
                  requestReward(params).then((data) {
                    String add_num = data['data']["add_num"].toString();
                    String red_bag = data['data']["red_bag"].toString();
                    String msg = data["msg"].toString();
                    int code = data["code"];
                    if (code == 200) {
                      // 回调给游戏
                      invokeOCMethed2('task_finish', '2');
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogTryPlayAward(add_num, red_bag, () {
                              // NotificationCenter.instance.postNotification(
                              //     'MainPage_to_refresh', null);
                              onBackPressed(context);
                            });
                          });
                    } else {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return MyAlert(
                                aTitle: '领取奖励失败',
                                aContent: msg,
                                okBtntitle: '知道了',
                                callback: (tag) {});
                            onBackPressed(context);
                          });
                    }
                  });
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    height: 40 * ScaleW(context),
                    image: AssetImage((widget.taskModel.is_done != null &&
                            widget.taskModel.is_done == true)
                        ? 'images/3.0x/rwxq/rwxq_btm1@3x.png'
                        : 'images/3.0x/rwxq/rwxq_btm@3x.png'), //images/main/swjl_btn1_@3x.png
                  ),
                  Text(
                    '领取奖励',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15 * ScaleW(context),
                      color: Color.fromRGBO(250, 250, 250, 1.0),
                    ),
                  ),
                ],
              ),
            ), //领取奖励
          ),
        ],
      ),
    );
  }

  Container contentCell2(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 9),
      height: 156 * ScreenWidth(context) / 375,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/3.0x/rwxq/rwxq_bg3_@3x.png"),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20 * ScaleW(context)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Image(
                    //   image: AssetImage('images/rwxq/rwxq_bg1_@3x.png'),
                    //   width: 30 * ScaleW(context),
                    // ),
                    Text(
                      '2',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22 * ScreenWidth(context) / 375,
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25 * ScaleW(context), top: 5),
                child: Text(
                  '点击"开始试玩"体验3分钟',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17 * ScreenWidth(context) / 375,
                    color: Color.fromRGBO(26, 26, 26, 1.0),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: ScreenWidth(context),
            margin: EdgeInsets.only(left: 60 * ScaleW(context), top: 5),
            child: Text(
              '打开应用是必须"允许"使用无线数据，\n"允许"IDFA应用跟踪',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13 * ScreenWidth(context) / 375,
                color: Color.fromRGBO(244, 67, 54, 1.0),
              ),
            ),
          ), //第一行
          Expanded(
            child: FlatButton(
              onPressed: () {
                if (widget.taskModel.status.toInt() == 2) {
                  invokeOCMethed2('open_app', widget.taskModel.app_package_id)
                      .then((isOpen) {
                    if (isOpen == '1') {
                      appDidOpen(context);
                    } else {
                      showDialog<String>(
                          context: this.context,
                          builder: (BuildContext context) {
                            return DialogNoPullAPP(
                                widget.taskModel.app_icon,
                                widget.taskModel.app_keyword,
                                widget.taskModel.app_rank,
                                () {});
                          });
                    }
                  });
                } else {
                  showDialog<String>(
                      context: this.context,
                      builder: (BuildContext context) {
                        return DialogBeginTryPlay(() {
                          invokeOCMethed2(
                                  'open_app', widget.taskModel.app_package_id)
                              .then((isOpen) {
                            if (isOpen == '1') {
                              appDidOpen(this.context);
                            } else {
                              showDialog<String>(
                                  context: this.context,
                                  builder: (BuildContext context) {
                                    return DialogNoPullAPP(
                                        widget.taskModel.app_icon,
                                        widget.taskModel.app_keyword,
                                        widget.taskModel.app_rank,
                                        () {});
                                  });
                            }
                          });
                        });
                      });
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    height: 40 * ScaleW(context),
                    image: AssetImage('images/3.0x/rwxq/rwxq_btm1@3x.png'),
                  ),
                  Text(
                    '开始试玩',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15 * ScaleW(context),
                      color: Color.fromRGBO(250, 250, 250, 1.0),
                    ),
                  ),
                ],
              ),
            ), //开始试玩
          ),
        ],
      ),
    );
  }

  void appDidOpen(BuildContext context) {
    if (widget.taskModel.status.toInt() == 2) {
      //正在试玩，非首次点击
      _isTryPlaying = true;
    } else {
      invokeOCMethed('all_params').then((params) {
        params["task_id"] = widget.taskModel.task_id;
        params['type'] = widget.taskModel.type;
        requestStart(params).then((data) {
          printLog(data, StackTrace.current);
          String msg = data["msg"].toString();
          int code = data["code"];

          // Map map  = {'msg':msg}
          if (code == 200) {
            invokeOCMethed2('play_start', widget.taskModel.task_id);
            widget.taskModel.status = widget.taskModel.status = 2;
            _isTryPlaying = true;
            SharedPreferencesUtils.remove('kRequestSubscribe');
          } else {
            SharedPreferencesUtils.savePreference(
                'kRequestSubscribe', jsonEncode(data));
          }
        });
      });
    }
  }

  Container contentCell1(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 9),
      height: 156 * ScaleW(context),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/3.0x/rwxq/rwxq_bg3_@3x.png"),
          // fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20 * ScaleW(context)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '1',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22 * ScreenWidth(context) / 375,
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25 * ScaleW(context), top: 0),
                child: Text(
                  '回到桌面，打开App Store',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17 * ScreenWidth(context) / 375,
                    color: Color.fromRGBO(26, 26, 26, 1.0),
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            // color: Color.fromRGBO(23, 23, 23, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48.0 * ScaleW(context),
                  height: 48.0 * ScaleW(context),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: (widget.taskModel.app_icon != null)
                          ? NetworkImage(widget.taskModel.app_icon)
                          : AssetImage("images/main/swjl_bg5_@3x.png"),
                      // fit: BoxFit.cover
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      margin: EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Text(
                            '搜索',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13 * ScreenWidth(context) / 375,
                              color: Color.fromRGBO(102, 102, 102, 1.0),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Text(
                              (widget.taskModel.app_keyword != null)
                                  ? widget.taskModel.app_keyword
                                  : '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17 * ScaleW(context),
                                color: Color.fromRGBO(244, 67, 54, 1.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 200,
                      margin: EdgeInsets.only(top: 3, left: 15),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              '下载位于第',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13 * ScreenWidth(context) / 375,
                                color: Color.fromRGBO(102, 102, 102, 1.0),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 3, right: 3),
                            child: Text(
                              (widget.taskModel.app_rank != null)
                                  ? widget.taskModel.app_rank
                                  : ' ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16 * ScreenWidth(context) / 375,
                                color: Color.fromRGBO(244, 67, 54, 1.0),
                              ),
                            ),
                          ),
                          Text(
                            '位',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13 * ScreenWidth(context) / 375,
                              color: Color.fromRGBO(102, 102, 102, 1.0),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: FlatButton(
              onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogHowDown(
                        () {}); //DialogTip('放弃高额奖励，将会影响下次任务推送的优先级，确认要放弃吗？', (tag) {
                    // print(tag);
                    //  }); //DialogAppTryPlay('2');
                    // return UpdateDialog(
                    //     upDateContent: '1.修复已知bug\n2.优化用户体验', isForce: true);
                  }),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                    height: 40 * ScaleW(context),
                    image: AssetImage('images/3.0x/rwxq/rwxq_btm1@3x.png'),
                  ),
                  Text(
                    '如何下载',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15 * ScaleW(context),
                      color: Color.fromRGBO(250, 250, 250, 1.0),
                    ),
                  ),
                ],
              ),
            ), //如何下载
          )
        ],
      ),
    );
  }

  Widget appBarWidget() {
    return AppBarView(
      title: '任务详情',
      callback: () {
        printLog('点击返回', StackTrace.current);
        onBackPressed(context);
      },
    );
  }

  Container headerCell(BuildContext context) {
    return Container(
      height: 84 * ScreenWidth(context) / 375,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/3.0x/rwxq/rwxq_bg2_@3x.png"),
        ),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  width: 250,
                  margin: EdgeInsets.only(left: 30, top: 0),
                  child: Row(
                    children: [
                      Text(
                        '试玩奖励',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18 * ScaleW(context),
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(26, 26, 26, 1.0)),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 3, right: 3, bottom: 2),
                        child: Text(
                          widget.taskModel.reward_amount != null
                              ? widget.taskModel.reward_amount.toString()
                              : '',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 31 * ScaleW(context),
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(234, 25, 50, 1.0)),
                        ),
                      ),
                      Text(
                        '元',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18 * ScaleW(context),
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(26, 26, 26, 1.0)),
                      ),
                    ],
                  )),
              Container(
                  width: 250,
                  margin: EdgeInsets.only(left: 30, bottom: 5),
                  child: Row(
                    children: [
                      Text(
                        '剩余时间：$_task_keep_min',
                        style: TextStyle(
                          fontSize: 16 * ScaleW(context),
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(26, 26, 26, 1.0),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ))
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: FlatButton(
                // minWidth: 300,
                onPressed: () {
                  printLog('点击放弃试玩', StackTrace.current);

                  showDialog<String>(
                      context: this.context,
                      builder: (BuildContext context) {
                        return MyAlert(
                            aTitle: '温馨提示',
                            aContent: '放弃试玩任务，将会影响下次任务推送的优先级，确认要放弃吗？',
                            okBtntitle: '确认',
                            cancelBtntitle: '取消',
                            callback: (tag) {
                              if (tag == 1) {
                                invokeOCMethed('all_params').then((params) {
                                  params['task_id'] = widget.taskModel.task_id;
                                  params['type'] = widget.taskModel.type;
                                  requestUnsubscribe(params).then((data) {
                                    String msg = data["msg"].toString();
                                    int code = data["code"];
                                    if (code == 200) {
                                      invokeOCMethed2('task_finish', '2');
                                      onBackPressed(this.context);
                                    } else {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MyAlert(
                                                aTitle: '放弃试玩失败',
                                                aContent: msg,
                                                okBtntitle: '知道了',
                                                callback: (tag) {});
                                          });
                                    }
                                  });
                                });
                              }
                            });
                      });
                },

                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image(
                      height: 33 * ScaleW(context),
                      image: AssetImage("images/3.0x/rwxq/fqsw_btn_01@3x.png"),
                    ),
                    Text(
                      '放弃',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * ScaleW(context),
                        color: Color.fromRGBO(250, 250, 250, 1.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //提示还差多就完成试玩,并刷新页面
  checkTryPlay() {
    if (widget.taskModel.status.toInt() == 2) {
      if (widget.taskModel.is_done) {
        setState(() {
          // _reward_status = true;
          invokeOCMethed2('task_finish', '0');
        });

        _isTryPlaying = false;
      } else {
        if (_isTryPlaying) {
          _isTryPlaying = false;
          int shengyu = 3 * 60 - widget.taskModel.done_secs;
          int minute = shengyu ~/ 60;
          int sec = shengyu % 60;
          print('ddddddd4');
          String text = '';
          if (minute > 0) {
            text = minute.toString() + '分钟';
          }
          if (sec > 0) {
            text = text + sec.toString() + '秒';
          }
          print('ddddddd5');
          showDialog<String>(
              context: this.context,
              builder: (BuildContext context) {
                return DialogTipCommon(
                    '时间还不够哟～ \n再试玩' + text + '就能领奖啦',
                    '继续试玩', //wxts_tx01_ //bdwx_tx01_
                    '', () {
                  invokeOCMethed2('open_app', widget.taskModel.app_package_id)
                      .then((value) {
                    _isTryPlaying = (value == "1") ? true : false;
                  });
                });
              });
          print('ddddddd7');
        }
      }
    } else if (widget.taskModel.status.toInt() == 1) {
      // SharedPreferencesUtils.savePreference('kRequestSubscribe', 'false');
      SharedPreferencesUtils.getPreference('kRequestSubscribe', '1')
          .then((jsonStr) {
        if (jsonStr is String && jsonStr != '1') {
          Map data = Map.from(jsonDecode(jsonStr));
          if (data != null && data is Map) {
            int code = data['code'];
            String msg = data['msg'];
            if (code != 200) {
              SharedPreferencesUtils.remove('kRequestSubscribe');
              MyAlert(
                  aTitle: '开始试玩失败',
                  aContent: msg,
                  okBtntitle: '知道了',
                  callback: (tag) {});
            }
          }
        }
      });
    }
  }

  void onBackPressed(BuildContext context) {
    NavigatorState navigatorState = Navigator.of(context);
    if (navigatorState.canPop()) {
      navigatorState.pop(widget.userModel);
    } else {
      invokeOCMethed('flutter_page_kill');
      SystemNavigator.pop();
    }
  }
}
