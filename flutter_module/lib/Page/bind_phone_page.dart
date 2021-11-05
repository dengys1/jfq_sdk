import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_module/Model/user_model.dart';
import 'package:flutter_module/Network/network.dart';
import 'package:flutter_module/tools/log.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../base_widget.dart';
import '../const.dart';

class BindPhonePage extends StatefulWidget {
  UserModel userModel;
  BindPhonePage(this.userModel);
  @override
  _BindPhonePageState createState() => _BindPhonePageState();
}

class _BindPhonePageState extends State<BindPhonePage> {
  String _phoneNum;
  String _getCodeBtnTitle = '获取验证码';
  String _code;
  final FocusNode focusNode = FocusNode();
  var seconds = 60;
  Timer _timer;

  @override
  void dispose() {
    // TODO: implement dispose
    //销毁监听生命周期
    super.dispose();
    _timer.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
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
                    Container(
                      height: 148 * ScaleW(context),
                      // width: 356 * ScaleW(context),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/3.0x/zjm/bdsj.png"),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 5, left: 30),
                                child: Text(
                                  '手机号',
                                  style: TextStyle(
                                    color: Color.fromRGBO(26, 26, 26, 1.0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16 * ScaleW(context),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: TextField(
                                    // obscureText: true,
                                    onChanged: (val) {
                                      _phoneNum = val;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "请输入手机号 ",
                                      hintStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(172, 172, 172, 1.0),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16 * ScaleW(context),
                                      ),
                                    ),

                                    cursorColor:
                                        Color.fromRGBO(165, 161, 161, 1.0),
                                    style: TextStyle(
                                      color: Color.fromRGBO(172, 172, 172, 1.0),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16 * ScaleW(context),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // color: Color.fromRGBO(10, 9, 8, 1.0),
                                margin: EdgeInsets.only(right: 4),
                                child: MaterialButton(
                                  child: Text(
                                    _getCodeBtnTitle, //获取验证码
                                    style: TextStyle(
                                      color: Color.fromRGBO(106, 191, 56, 1.0),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16 * ScaleW(context),
                                    ),
                                  ),
                                  onPressed: () {
                                    //手机判断
                                    if (_phoneNum == null ||
                                        _phoneNum.length == 0) {
                                      Fluttertoast.showToast(
                                          msg: '请输入手机号码',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 1,
                                          // backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16 * ScaleW(context));
                                      return;
                                    }

                                    //发起请求
                                    Loading.showLoading(context);
                                    invokeOCMethed('all_params').then((map) {
                                      map["phone"] = _phoneNum;
                                      map["type"] = '2';
                                      requestGetSmsCode(map).then((value) {
                                        Loading.hideLoading(context);
                                        if (value['code'] == 200) {
                                          if (_timer != null) {
                                            return;
                                          }
                                          _timer = new Timer.periodic(
                                              new Duration(seconds: 1),
                                              (timer) {
                                            setState(() {
                                              if (seconds > 0) {
                                                seconds--;
                                                setState(() {
                                                  _getCodeBtnTitle =
                                                      seconds.toString() + 's';
                                                });
                                              } else {
                                                setState(() {
                                                  _getCodeBtnTitle = '重新获取';
                                                });
                                                _timer.cancel();
                                                _timer = null;
                                                seconds = 60;
                                              }
                                            });
                                          });
                                        } else {
                                          String msg = value['msg'];
                                          Fluttertoast.showToast(
                                              msg: '获取验证码失败:$msg',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              // backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16 * ScaleW(context));
                                        }
                                      });
                                    });
                                  },
                                ),
                              )
                            ],
                          )), //手机号
                          Expanded(
                              child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 5, left: 30),
                                child: Text(
                                  '验证码',
                                  style: TextStyle(
                                    color: Color.fromRGBO(26, 26, 26, 1.0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16 * ScaleW(context),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextField(
                                    // obscureText: true,
                                    onChanged: (val) {
                                      _code = val;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "请输入验证码",
                                      hintStyle: TextStyle(
                                        color:
                                            Color.fromRGBO(172, 172, 172, 1.0),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16 * ScaleW(context),
                                      ),
                                    ),

                                    cursorColor:
                                        Color.fromRGBO(165, 161, 161, 1.0),
                                    style: TextStyle(
                                      color: Color.fromRGBO(172, 172, 172, 1.0),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16 * ScaleW(context),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )), //验证码
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      child: FlatButton(
                        onPressed: () {
                          //提交
                          // Navigator.pop(context);
                          //手机判断
                          if (_phoneNum == null || _phoneNum.length == 0) {
                            Fluttertoast.showToast(
                                msg: '请输入手机号码',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                // backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16 * ScaleW(context));
                            return;
                          }

                          //验证码判断
                          if (_code == null || _code.length == 0) {
                            Fluttertoast.showToast(
                                msg: '验证码不能为空',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                // backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16 * ScaleW(context));
                            return;
                          }

                          Loading.showLoading(context);
                          invokeOCMethed('all_params').then((map) {
                            printLog(map, StackTrace.current);
                            map["login_id"] = _phoneNum;
                            map["type"] = '1';
                            map['token'] = _code;
                            requestBindPhone(map).then((value) {
                              Loading.hideLoading(context);
                              if (value['code'] == 200) {
                                widget.userModel.is_bind_phone = 1;
                                saveUserData(
                                    jsonEncode(widget.userModel.toJson()));
                                Fluttertoast.showToast(
                                    msg: "手机绑定完成",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0 * ScaleW(context));
                                Navigator.pop(context, widget.userModel);
                              } else {
                                var msg = value["msg"] != null
                                    ? value["msg"]
                                    : '手机绑定失败';

                                Fluttertoast.showToast(
                                    msg: msg,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    // backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0 * ScaleW(context));
                              }
                            });
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image(
                              height: 40 * ScaleW(context),
                              image: AssetImage(
                                  "images/3.0x/rwxq/rwxq_btm1@3x.png"),
                            ),
                            Text(
                              '确认',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15 * ScaleW(context),
                                color: Color.fromRGBO(250, 250, 250, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
    ;
  }

  Widget appBarWidget() {
    return AppBarView(
      title: '绑定手机',
      callback: () {
        Navigator.pop(context);
      },
    );
  }
}
