import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_module/Model/user_model.dart';
import 'package:flutter_module/Network/network.dart';
import 'package:flutter_module/tools/log.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../base_widget.dart';
import '../const.dart';

class BindWXPage extends StatefulWidget {
  UserModel userModel;
  BindWXPage(this.userModel);

  @override
  _BindWXPageState createState() => _BindWXPageState();
}

class _BindWXPageState extends State<BindWXPage> {
  String _code = '';
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
                          height: 77 * ScaleW(context),
                          // width: 356 * ScaleW(context),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/3.0x/zjm/bdwx_01.png"),
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                  child: Row(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(bottom: 5, left: 30),
                                    child: Text(
                                      '验证码',
                                      style: TextStyle(
                                        color: Color.fromRGBO(26, 26, 26, 1.0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18 * ScaleW(context),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, left: 5),
                                      child: TextField(
                                        // obscureText: true,
                                        onChanged: (val) {
                                          _code = val;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                          hintText: "按步骤获取并输入验证码",
                                          hintStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                172, 172, 172, 1.0),
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18 * ScaleW(context),
                                          ),
                                        ),

                                        cursorColor:
                                            Color.fromRGBO(165, 161, 161, 1.0),
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              172, 172, 172, 1.0),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18 * ScaleW(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )), //验证码
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: FlatButton(
                            onPressed: () {
                              if (_code == null || _code.length == 0) {
                                printLog('konggg', StackTrace.current);
                                Fluttertoast.showToast(
                                    msg: "请输入验证码",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0 * ScaleW(context));

                                return;
                              }

                              invokeOCMethed('all_params').then((params) {
                                params["code"] = _code;
                                requestBindWX(params).then((data) {
                                  if (data["code"] == 200) {
                                    widget.userModel.is_bind_wx = 1;
                                    saveUserData(
                                        jsonEncode(widget.userModel.toJson()));
                                    Fluttertoast.showToast(
                                        msg: "微信绑定完成",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        textColor: Colors.white,
                                        fontSize: 16.0 * ScaleW(context));
                                    Navigator.pop(context, widget.userModel);
                                  } else {
                                    var msg = data["msg"] != null
                                        ? data["msg"]
                                        : '微信绑定失败';
                                    Fluttertoast.showToast(
                                        msg: msg,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
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
                        ), //按钮
                        Container(
                          height: 271 * ScaleW(context),
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/3.0x/zjm/bdwx_02.png"),
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                  child: Container(
                                // color: Color.fromRGBO(123, 123, 12, 1),
                                margin: EdgeInsets.only(left: 30, top: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '第一步',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(26, 26, 26, 1.0),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18 * ScaleW(context),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            '1、',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  26, 26, 26, 1.0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15 * ScaleW(context),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '长按复制 ',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  223, 109, 17, 1.0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15 * ScaleW(context),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SelectableText(
                                            '葡萄赚钱',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  26, 26, 26, 1.0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15 * ScaleW(context),
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '2、打开微信搜索并关注公众号',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(26, 26, 26, 1.0),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15 * ScaleW(context),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                // color: Color.fromRGBO(123, 123, 12, 1),
                                margin: EdgeInsets.only(left: 30, top: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '第二步',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(26, 26, 26, 1.0),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18 * ScaleW(context),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            '1、',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  26, 26, 26, 1.0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15 * ScaleW(context),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '点击获取',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  26, 26, 26, 1.0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15 * ScaleW(context),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '【获取验证码】',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  223, 109, 17, 1.0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15 * ScaleW(context),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '2、',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(26, 26, 26, 1.0),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15 * ScaleW(context),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '回到本页面填写',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                223, 109, 17, 1.0),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15 * ScaleW(context),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            )));
    ;
  }

  Widget appBarWidget() {
    return AppBarView(
      title: '绑定微信',
      callback: () {
        Navigator.pop(context);
      },
    );
  }
}
