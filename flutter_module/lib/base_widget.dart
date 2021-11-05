import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/tools/log.dart';

import 'const.dart';

typedef Callback<T> = void Function();
typedef Callback2<T> = void Function(int tag);

//导航栏
class AppBarView extends StatelessWidget {
  final String title;
  Callback callback;
  AppBarView({this.title, this.callback});

  // @override
  // StatelessElement createElement() {
  //   // TODO: implement createElement
  //   return super.createElement();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60 * ScaleW(context),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: 10,
            child: IconButton(
              iconSize: 25 * ScaleW(context),
              icon: Image(
                image: AssetImage("images/3.0x/zjm/zjm_back_icon@3x.png"),
              ),
              onPressed: () {
                printLog("点击返回图标", StackTrace.current);
                callback();
                //
              },
            ),
          ),
          Container(
            child: Text(
              title,
              style: TextStyle(
                  color: Color.fromRGBO(250, 250, 250, 1.0),
                  fontSize: 19 * ScaleW(context),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none),
            ),
          ),
        ],
      ),
    );
  }
}

//加载菊花
class LoadingDialog extends Dialog {
  String text;
  bool backMiss;
  LoadingDialog({Key key, @required this.text, this.backMiss})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (backMiss) {
          Navigator.of(context).pop();
        }
      },
      child: Material(
        type: MaterialType.transparency,
        child: new Center(
          child: new SizedBox(
            width: 120.0,
            height: 120.0,
            child: new Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: new Text(
                      text,
                      style: new TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//应用试玩
class DialogAppTryPlay extends Dialog {
  final String num;
  Callback callback;
  DialogAppTryPlay(this.num, this.callback);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: [
          Positioned(
              // top: 10,
              child: Image(
            height: 288 * ScaleW(context),
            image: AssetImage("images/bmzlqtj/bmzlqtj_bg01_@3x.png"),
          )),
          Positioned(
              top: -(288 * ScaleW(context)) / 2 + 20,
              child: Column(
                children: [
                  Image(
                    height: 163 * ScaleW(context),
                    image: AssetImage("images/yysw/yysw_bg01_@3x.png"),
                  ), //应用试玩图片
                  Container(
                    height: 145 * ScaleW(context),
                    width: 257 * ScaleW(context),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/yysw/yysw_bg02_@3x.png"),
                        // fit: BoxFit.cover,
                      ),
                    ),
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // margin: EdgeInsets.only(top: 30),
                          child: Text(
                            '下载并试玩 3 分钟，完成任务目标',
                            style: TextStyle(
                                color: Color.fromRGBO(19, 84, 134, 1.0),
                                fontSize: 16 * ScaleW(context),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '即可领取',
                                  style: TextStyle(
                                      color: Color.fromRGBO(19, 84, 134, 1.0),
                                      fontSize: 20 * ScaleW(context),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none),
                                ),
                                Text(
                                  ' $num 元 ',
                                  style: TextStyle(
                                      color: Color.fromRGBO(197, 97, 0, 1.0),
                                      fontSize: 30 * ScaleW(context),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none),
                                ),
                                Text(
                                  '奖励',
                                  style: TextStyle(
                                      color: Color.fromRGBO(19, 84, 134, 1.0),
                                      fontSize: 20 * ScaleW(context),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none),
                                ),
                              ],
                            ))
                      ],
                    ), //
                  ), //内容
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: FlatButton(
                      // minWidth: 300,
                      onPressed: () {
                        Navigator.pop(context);
                        callback();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            height: 45 * ScaleW(context),
                            image: AssetImage("images/main/swjl_btn1_@3x.png"),
                          ),
                          Image(
                            height: 22 * ScaleW(context),
                            image: AssetImage("images/yysw/yysw_tx01_@3x.png"),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
          Positioned(
            top: -10,
            right: -30,
            child: FlatButton(
              child: Image(
                  height: 41 * ScaleW(context),
                  image: AssetImage("images/kssw/kssw_btn01_@3x.png")),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ) //关闭按钮
        ],
      ),
    );
  }
}

//放弃奖励提示
class DialogTip extends Dialog {
  final String content;
  Callback2 callback;
  DialogTip(this.content, this.callback);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: [
          Positioned(
              // top: 10,
              child: Image(
            height: 288 * ScaleW(context),
            image: AssetImage("images/bmzlqtj/bmzlqtj_bg01_@3x.png"),
          )), //背景图片
          Positioned(
              top: 0,
              child: Column(
                children: [
                  Container(
                    height: 145 * ScaleW(context),
                    width: 257 * ScaleW(context),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/yysw/yysw_bg02_@3x.png"),
                        // fit: BoxFit.cover,
                      ),
                    ),
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          content,
                          style: TextStyle(
                              height: 1.5,
                              color: Color.fromRGBO(19, 84, 134, 1.0),
                              fontSize: 16 * ScaleW(context),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ), //
                  ), //内容
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        FlatButton(
                          // minWidth: 300,
                          onPressed: () {
                            Navigator.pop(context);
                            callback(1);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image(
                                height: 45 * ScaleW(context),
                                image:
                                    AssetImage("images/main/swjl_btn1_@3x.png"),
                              ),
                              Image(
                                height: 22 * ScaleW(context),
                                image:
                                    AssetImage("images/yysw/yysw_tx01_@3x.png"),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                          // minWidth: 300,
                          onPressed: () {
                            Navigator.pop(context);
                            callback(2);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image(
                                height: 45 * ScaleW(context),
                                image:
                                    AssetImage("images/rwxq/rwxq_btn2_@3x.png"),
                              ),
                              Image(
                                height: 22 * ScaleW(context),
                                image:
                                    AssetImage("images/fqsw/fqsw_tx01_@3x.png"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )), //内柔
          Positioned(
            top: -10,
            right: -30,
            child: FlatButton(
              child: Image(
                  height: 41 * ScaleW(context),
                  image: AssetImage("images/kssw/kssw_btn01_@3x.png")),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ) //关闭按钮
        ],
      ),
    );
  }
}

//通用提示
//提示，images/kssw/kssw_tx01_@3x.png
//一键领取，images/yysw/yysw_tx01_@3x.png
class DialogTipCommon extends Dialog {
  final String content;
  final String btnTitle;
  final String btnImage;
  Callback callback;
  DialogTipCommon(this.content, this.btnTitle, this.btnImage, this.callback);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('ddddddd6');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // overflow: Overflow.visible,
        children: [
          Container(
            height: 180 * ScaleW(context),
            width: 276 * ScaleW(context),
            decoration: BoxDecoration(
              color: Color.fromRGBO(250, 250, 250, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Container(
                //   child: Text('提示',
                //       style: TextStyle(
                //           height: 1.5,
                //           color: Color.fromRGBO(0, 0, 0, 1.0),
                //           fontSize: 24 * ScaleW(context),
                //           fontWeight: FontWeight.bold,
                //           decoration: TextDecoration.none)),
                // ), //标题图片
                Container(
                  // height: 145 * ScaleW(context),
                  width: 257 * ScaleW(context),
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage("images/yysw/yysw_bg02_@3x.png"),
                  //     // fit: BoxFit.cover,
                  //   ),
                  // ),
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        content,
                        style: TextStyle(
                            height: 1.5,
                            color: Color.fromRGBO(112, 112, 112, 1.0),
                            fontSize: 16 * ScaleW(context),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ), //
                ), //内容
                Container(
                  // margin: EdgeInsets.only(top: 10 * ScaleW(context)),
                  child: FlatButton(
                    // minWidth: 300,
                    onPressed: () {
                      Navigator.pop(context);
                      callback();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image(
                          height: 40 * ScaleW(context),
                          image: AssetImage(
                              "images/3.0x/rwxq/tk_rhxz/rwxq-tc-rhxz-btm.png"),
                        ),
                        Text(
                          btnTitle,
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
          ),
          //内柔
        ],
      ),
    );
  }
}

//开始试玩
class DialogBeginTryPlay extends Dialog {
  final Callback callback;

  DialogBeginTryPlay(this.callback);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: [
          Positioned(
              // top: 0,
              child: Image(
            height: 523 * ScaleW(context),
            // width: MediaQuery.of(context).size.width,
            image:
                AssetImage("images/3.0x/rwxq/tk_kssw/rwxq_tc_kssw_bj1@3x.png"),
          )), //背景图片
          Positioned(
              top: 0,
              child: Column(
                children: [
                  Container(
                      width: 276 * ScaleW(context),
                      margin: EdgeInsets.only(
                          top: 30 * ScaleW(context),
                          left: 40 * ScaleW(context)),
                      child: Row(
                        children: [
                          Text(
                            '1.请务必',
                            style: TextStyle(
                                height: 1.5,
                                color: Color.fromRGBO(112, 112, 112, 1.0),
                                fontSize: 16 * ScaleW(context),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                          Text(
                            '允许',
                            style: TextStyle(
                                height: 1.5,
                                color: Color.fromRGBO(106, 191, 56, 1.0),
                                fontSize: 16 * ScaleW(context),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                          Text(
                            '使用数据',
                            style: TextStyle(
                                height: 1.5,
                                color: Color.fromRGBO(112, 112, 112, 1.0),
                                fontSize: 16 * ScaleW(context),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          )
                        ],
                      )), //1。
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Image(
                      height: 169 * ScaleW(context),
                      image: AssetImage(
                          "images/3.0x/rwxq/tk_kssw/rwxq_tc_kssw_alert@3x.png"),
                    ),
                  ), //图片
                  Container(
                      width: 276 * ScaleW(context),
                      margin:
                          EdgeInsets.only(top: 10, left: 40 * ScaleW(context)),
                      child: Row(
                        children: [
                          Text(
                            '2.请务必',
                            style: TextStyle(
                                height: 1.5,
                                color: Color.fromRGBO(112, 112, 112, 1.0),
                                fontSize: 16 * ScaleW(context),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                          Text(
                            '允许',
                            style: TextStyle(
                                height: 1.5,
                                color: Color.fromRGBO(106, 191, 56, 1.0),
                                fontSize: 16 * ScaleW(context),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                          Text(
                            '使用跟踪数据',
                            style: TextStyle(
                                height: 1.5,
                                color: Color.fromRGBO(112, 112, 112, 1.0),
                                fontSize: 16 * ScaleW(context),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          )
                        ],
                      )), //2。
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Image(
                      height: 150 * ScaleW(context),
                      image: AssetImage(
                          "images/3.0x/rwxq/tk_kssw/rwxq_tc_kssw_alert2@3x.png"),
                    ),
                  ), //图片
                  Container(
                    // flex: 1,
                    margin: EdgeInsets.only(top: 10 * ScaleW(context)),
                    child: FlatButton(
                      // minWidth: 300,
                      onPressed: () {
                        Navigator.pop(context);
                        callback();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            height: 40 * ScaleW(context),
                            image: AssetImage(
                                "images/3.0x/rwxq/tk_rhxz/rwxq-tc-rhxz-btm.png"),
                          ),
                          Text(
                            '知道了',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15 * ScaleW(context),
                              color: Color.fromRGBO(250, 250, 250, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) //最后按钮
                ],
              )), //内柔
        ],
      ),
    );
  }
}

//如何下载
class DialogHowDown extends Dialog {
  final Callback callback;

  DialogHowDown(this.callback);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: [
          Positioned(
              // top: 10,
              child: Image(
            height: 326 * ScaleW(context),
            width: 276 * ScaleW(context),
            image: AssetImage("images/3.0x/rwxq/tk_rhxz/rwxq_rhxz_bj.png"),
          )), //背景图片
          Positioned(
              top: 0,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    width: 200 * ScaleW(context),
                    child: Text('如何下载?',
                        style: TextStyle(
                            height: 1.5,
                            color: Color.fromRGBO(0, 0, 0, 1.0),
                            fontSize: 24 * ScaleW(context),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none)),
                  ), //标题图片
                  Container(
                    width: 200 * ScaleW(context),
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      '请返回桌面',
                      style: TextStyle(
                          height: 1.5,
                          color: Color.fromRGBO(112, 112, 112, 1.0),
                          fontSize: 13 * ScaleW(context),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                  ), //1。
                  Container(
                      width: 200 * ScaleW(context),
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Text(
                            '打开',
                            style: TextStyle(
                                height: 1.5,
                                color: Color.fromRGBO(112, 112, 112, 1.0),
                                fontSize: 13 * ScaleW(context),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                          Text(
                            ' [App Store] ',
                            style: TextStyle(
                                height: 1.5,
                                color: Color.fromRGBO(115, 197, 69, 1.0),
                                fontSize: 13 * ScaleW(context),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          ),
                          Text(
                            '下载应用',
                            style: TextStyle(
                                height: 1.5,
                                color: Color.fromRGBO(112, 112, 112, 1.0),
                                fontSize: 13 * ScaleW(context),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none),
                          )
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    child: Image(
                      height: 113 * ScaleW(context),
                      image: AssetImage(
                          "images/3.0x/rwxq/tk_rhxz/rwxq-tc-rhxz-bj@3x.png"),
                    ),
                  ), //图片
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    child: FlatButton(
                      // minWidth: 300,
                      onPressed: () {
                        Navigator.pop(context);
                        callback();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            height: 40 * ScaleW(context),
                            image: AssetImage(
                                "images/3.0x/rwxq/tk_rhxz/rwxq-tc-rhxz-btm.png"),
                          ),
                          Text(
                            '知道了',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15 * ScaleW(context),
                              color: Color.fromRGBO(250, 250, 250, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) //最后按钮
                ],
              )), //内柔
        ],
      ),
    );
  }
}

//拉不了应用
class DialogNoPullAPP extends Dialog {
  final String appIcon;
  final String appName;
  final String num;
  final Callback callback;
  DialogNoPullAPP(this.appIcon, this.appName, this.num, this.callback);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: [
          Positioned(
              // top: 10,
              child: Image(
            height: 288 * ScaleW(context),
            image:
                AssetImage("images/3.0x/rwxq/tk_wjcdyy/rwxq-tc-swjc-bj@3x.png"),
          )), //背景图片
          Positioned(
              top: 0,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        Text(
                          '尚未检测到可玩的应用',
                          style: TextStyle(
                              height: 1.5,
                              color: Color.fromRGBO(0, 0, 0, 1.0),
                              fontSize: 20 * ScaleW(context),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        ),
                        Text(
                          '应用下载错误或尚未下载完成',
                          style: TextStyle(
                              height: 1.5,
                              color: Color.fromRGBO(112, 112, 112, 1.0),
                              fontSize: 14 * ScaleW(context),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 94 * ScaleW(context),
                    width: 253 * ScaleW(context),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "images/3.0x/rwxq/tk_wjcdyy/rwxq-tc-swjc-bj-green@3x.png"),
                        // fit: BoxFit.cover,
                      ),
                    ), //内容背景图片
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Container(
                                // margin: EdgeInsets.only(left: 28 * ScaleW(context)),
                                width: 52.0 * ScaleW(context),
                                height: 52.0 * ScaleW(context),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(appIcon),
                                    // fit: BoxFit.cover
                                  ),
                                ),
                              ), //icon
                            ), //icon图片
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // width: 170,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          '在App Store搜索：',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  112, 112, 112, 1.0),
                                              fontSize: 10 * ScaleW(context),
                                              fontWeight: FontWeight.w500,
                                              decoration: TextDecoration.none),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // width: 170,
                                    padding: EdgeInsets.only(
                                        left: 10, top: 3, bottom: 3),
                                    child: Row(
                                      children: [
                                        Text(
                                          appName,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                244, 67, 54, 1.0),
                                            fontSize: 10 * ScaleW(context),
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                      // width: 170,
                                      padding: EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            '下载排名约位于第',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    112, 112, 112, 1.0),
                                                fontSize: 10 * ScaleW(context),
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Text(
                                            ' $num ',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    244, 67, 54, 1.0),
                                                fontSize: 12 * ScaleW(context),
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          Text(
                                            '位的应用',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    112, 112, 112, 1.0),
                                                fontSize: 10 * ScaleW(context),
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.none),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ), //内容内部
                    ), //
                  ), //内容外部
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        FlatButton(
                          // minWidth: 300,
                          onPressed: () {
                            Navigator.pop(context);
                            callback();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image(
                                height: 40 * ScaleW(context),
                                image: AssetImage(
                                    "images/3.0x/rwxq/tk_rhxz/rwxq-tc-rhxz-btm.png"),
                              ),
                              Text(
                                '知道了',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15 * ScaleW(context),
                                  color: Color.fromRGBO(250, 250, 250, 1.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )), //内容
        ],
      ),
    );
  }
}

// 提现确认
class DialogTxqr extends Dialog {
  final String name;
  final String money;
  final String des;
  Callback callback;
  DialogTxqr(
    this.name,
    this.money,
    this.des,
    this.callback,
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: [
          Positioned(
              // top: 10,
              child: Image(
            height: 250 * ScaleW(context),
            image: AssetImage("images/3.0x/tx/tk_txqr/wxtx_txqr_bj@3x.png"),
          )), //背景图片
          Positioned(
              top: 10,
              child: Column(
                children: [
                  Container(
                      child: Text(
                    '提现确认',
                    style: TextStyle(
                        height: 1.5,
                        color: Color.fromRGBO(26, 26, 26, 1.0),
                        fontSize: 18 * ScaleW(context),
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none),
                  )),
                  Container(
                    width: 345 * ScaleW(context),
                    margin: EdgeInsets.only(top: 50),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Text(
                                '所需零钱',
                                style: TextStyle(
                                    height: 2,
                                    color: Color.fromRGBO(26, 26, 26, 1.0),
                                    fontSize: 17 * ScaleW(context),
                                    fontWeight: FontWeight.w300,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 30),
                                  child: Text(
                                    money,
                                    style: TextStyle(
                                        height: 2,
                                        color: Color.fromRGBO(26, 26, 26, 1.0),
                                        fontSize: 17 * ScaleW(context),
                                        fontWeight: FontWeight.w300,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                              ],
                            ))
                          ],
                        ), //所需零钱
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                '提现信息',
                                style: TextStyle(
                                    height: 2,
                                    color: Color.fromRGBO(26, 26, 26, 1.0),
                                    fontSize: 17 * ScaleW(context),
                                    fontWeight: FontWeight.w300,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 30),
                                    child: Text(
                                      des,
                                      style: TextStyle(
                                          height: 2,
                                          color:
                                              Color.fromRGBO(26, 26, 26, 1.0),
                                          fontSize: 17 * ScaleW(context),
                                          fontWeight: FontWeight.w300,
                                          decoration: TextDecoration.none),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ) //提现信息
                      ],
                    ), //
                  ), //内容
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: FlatButton(
                      // minWidth: 300,
                      onPressed: () {
                        Navigator.pop(context);
                        callback();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            height: 40 * ScaleW(context),
                            image:
                                AssetImage("images/3.0x/rwxq/rwxq_btm1@3x.png"),
                          ),
                          Text(
                            '确定',
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
              )), //内柔
        ],
      ),
    );
  }
}

//苹果官方认证
class DialogAppleCertification extends Dialog {
  final Callback callback;

  DialogAppleCertification(this.callback);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: [
          Positioned(
              // top: 10,
              child: Image(
            height: 268 * ScaleW(context),
            image: AssetImage("images/3.0x/tx/tk_azrz/wxtx_pggfrz_bj@3x.png"),
          )), //背景图片
          Positioned(
              top: 80,
              child: Column(
                children: [
                  Center(
                      // width: 200 * ScaleW(context),

                      child: Container(
                    margin: EdgeInsets.all(20),
                    child: Text(
                      '苹果官方认证',
                      style: TextStyle(
                          height: 1.5,
                          color: Color.fromRGBO(112, 112, 112, 1.0),
                          fontSize: 17 * ScaleW(context),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                  )), //1。
                  Center(
                      // width: 200 * ScaleW(context),
                      // margin: EdgeInsets.only(top: 5),
                      child: Container(
                    width: 250 * ScaleW(context),
                    child: Text(
                      '还差一步！为了增加您的账户安全性请安装苹果官方认证的设备设备证书',
                      style: TextStyle(
                          // height: 1.5,
                          color: Color.fromRGBO(112, 112, 112, 1.0),
                          fontSize: 12 * ScaleW(context),
                          fontWeight: FontWeight.w300,
                          decoration: TextDecoration.none),
                    ),
                  )),
                  Container(
                    margin: EdgeInsets.only(bottom: 5, top: 20),
                    child: FlatButton(
                      // minWidth: 300,
                      onPressed: () {
                        Navigator.pop(context);
                        callback();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            height: 40 * ScaleW(context),
                            image: AssetImage(
                                "images/3.0x/rwxq/tk_rhxz/rwxq-tc-rhxz-btm.png"),
                          ),
                          Text(
                            '立即安装',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15 * ScaleW(context),
                              color: Color.fromRGBO(250, 250, 250, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) //最后按钮
                ],
              )), //内柔
        ],
      ),
    );
  }
}

//试玩奖励
class DialogTryPlayAward extends Dialog {
  final String awardMoney;
  final String total;
  Callback callback;
  DialogTryPlayAward(this.awardMoney, this.total, this.callback);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Stack(
        alignment: Alignment.center,
        overflow: Overflow.visible,
        children: [
          Positioned(
              // top: 10,
              child: Image(
            height: 330 * ScaleW(context),
            image: AssetImage("images/3.0x/rwxq/tk_wcrw/rwxq_lqjlcg_bg@3x.png"),
          )), //背景图
          Positioned(
              top: 330 * ScaleW(context) * 0.5 - 30,
              child: Column(
                children: [
                  Container(
                    height: 108 * ScaleW(context),
                    width: 200 * ScaleW(context),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "images/3.0x/rwxq/tk_wcrw/rwxq_lqjlcg_bg_01@3x.png"),
                        // fit: BoxFit.cover,
                      ),
                    ),
                    // margin: EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 13 * ScaleW(context)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '+',
                                style: TextStyle(
                                    color: Color.fromRGBO(223, 109, 17, 1.0),
                                    fontSize: 25 * ScaleW(context),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 0, right: 0),
                                child: Text(
                                  awardMoney,
                                  style: TextStyle(
                                      color: Color.fromRGBO(223, 109, 17, 1.0),
                                      fontSize: 40 * ScaleW(context),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                              Text(
                                '元',
                                style: TextStyle(
                                    color: Color.fromRGBO(223, 109, 17, 1.0),
                                    fontSize: 18 * ScaleW(context),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                              )
                            ],
                          ),
                        ),
                        Container(
                            // margin: EdgeInsets.only(bottom: 20),
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '当前零钱',
                              style: TextStyle(
                                  color: Color.fromRGBO(223, 109, 17, 1.0),
                                  fontSize: 14 * ScaleW(context),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none),
                            ),
                            Text(
                              ' $total ',
                              style: TextStyle(
                                  color: Color.fromRGBO(223, 109, 17, 1.0),
                                  fontSize: 14 * ScaleW(context),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none),
                            ),
                            Text(
                              '元',
                              style: TextStyle(
                                  color: Color.fromRGBO(223, 109, 17, 1.0),
                                  fontSize: 14 * ScaleW(context),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        ))
                      ],
                    ), //
                  ), //内容
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: FlatButton(
                      // minWidth: 300,
                      onPressed: () {
                        Navigator.pop(context);
                        callback();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            height: 40 * ScaleW(context),
                            image: AssetImage(
                                "images/3.0x/rwxq/tk_rhxz/rwxq-tc-rhxz-btm.png"),
                          ),
                          Text(
                            '继续赚钱',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15 * ScaleW(context),
                              color: Color.fromRGBO(250, 250, 250, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) //最后按钮
                ],
              )),
        ],
      ),
    );
  }
}

//加载菊花
class Loading {
  static bool isShow = false;

  static showLoading(BuildContext context) {
    if (!isShow) {
      isShow = true;
      showGeneralDialog(
          context: context,
          // barrierColor: Colors.white, // 背景色
          // barrierLabel: '',
          barrierDismissible: false, // 是否能通过点击空白处关闭
          transitionDuration: const Duration(milliseconds: 150), // 动画时长
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return Align(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Theme(
                  data: ThemeData(
                    cupertinoOverrideTheme: CupertinoThemeData(
                      brightness: Brightness.dark,
                    ),
                  ),
                  child: CupertinoActivityIndicator(
                    radius: 14,
                  ),
                ),
              ),
            );
          }).then((value) {
        isShow = false;
      });
    }
  }

  static hideLoading(BuildContext context) {
    if (isShow) {
      Navigator.of(context).pop();
    }
  }
}

class MyAlert extends CupertinoAlertDialog {
  final String aTitle;
  final String aContent;
  final String okBtntitle;
  final String cancelBtntitle;
  Callback2 callback;

  MyAlert(
      {this.aTitle,
      this.aContent,
      this.okBtntitle,
      this.cancelBtntitle,
      this.callback});

  @override
  Widget build(BuildContext context) {
    return new CupertinoAlertDialog(
      title: new Text(
        aTitle,
      ),
      content: Text(aContent),
      actions: <Widget>[
        if (cancelBtntitle != null)
          Container(
            // decoration: BoxDecoration(
            //     border: Border(
            //         top: BorderSide(
            //             color: Color.fromRGBO(106, 191, 56, 1.0), width: 1.0))),
            child: FlatButton(
              child: new Text(
                cancelBtntitle,
              ),
              onPressed: () {
                Navigator.pop(context);
                callback(0);
              },
            ),
          ),
        Container(
          // decoration: BoxDecoration(
          //     border: Border(
          //         // right: BorderSide(
          //         //     color: Color.fromRGBO(106, 191, 56, 1.0), width: 1.0),
          //         top: BorderSide(
          //             color: Color.fromRGBO(106, 191, 56, 1.0), width: 1.0))),
          child: FlatButton(
            child: Text(okBtntitle),
            onPressed: () {
              Navigator.pop(context);
              callback(1);
            },
          ),
        ),
      ],
    );
  }
}
//alert弹框，类型iOS 有确定，取消按钮
// CupertinoAlertDialog(
// title: new Text(
// "标题",
// ),
// content: new Text("内容"),
// actions: <Widget>[
// new Container(
// decoration: BoxDecoration(
// border: Border(
// right: BorderSide(
// color: Color.fromRGBO(239, 41, 41, 1.0), width: 1.0),
// top: BorderSide(
// color: Color.fromRGBO(239, 41, 41, 1.0), width: 1.0))),
// child: FlatButton(
// child: new Text("确定"),
// onPressed: () {
// Navigator.pop(context);
// },
// ),
// ),
// new Container(
// decoration: BoxDecoration(
// border: Border(
// top: BorderSide(
// color: Color.fromRGBO(239, 41, 41, 1.0), width: 1.0))),
// child: FlatButton(
// child: new Text("取消"),
// onPressed: () {
// Navigator.pop(context);
// },
// ),
// )
// ],
// )
