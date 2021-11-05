import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../base_widget.dart';
import '../const.dart';

class TixianFinish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color.fromRGBO(236, 242, 229, 1.0),
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage("images/3.0x/zjm_bg@3x.png"),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Stack(
        children: [
          Container(
              child: Container(
            child: ListView(
              children: [
                // appBarWidget(),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  height: 314 * ScaleW(context),
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage("images/ytjsq/ytjsq_bg01_@3x.png"),
                  //     // fit: BoxFit.cover,
                  //   ),
                  // ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Image(
                          height: 71 * ScaleW(context),
                          image: AssetImage(
                              'images/3.0x/tx/txsqcg/wxtx_sqtxycg_icon@3x.png'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(30),
                        child: Text(
                          '提现申请已提交',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18 * ScreenWidth(context) / 375,
                            color: Color.fromRGBO(0, 0, 0, 1.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 300 * ScaleW(context),
                        child: Text(
                          '10:00-17:00间发起的提现预计3小时内审核完毕，晚间非工作时间发起的提现预计次日12:00前审核完毕。请合理安排提现时间',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14 * ScreenWidth(context) / 375,
                            color: Color.fromRGBO(0, 0, 0, 1.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                tixianBtn(context) //提现按钮
              ],
            ),
          ))
        ],
      ),
    ));
    ;
  }
}

Widget appBarWidget() {
  return AppBarView(
    title: '提现申请',
    callback: () {},
  );
}

Container tixianBtn(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 20),
    child: FlatButton(
      onPressed: () {
        onBackPressed(context);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(
            height: 45 * ScaleW(context),
            image: AssetImage("images/3.0x/tx/wxtx/wxtx_btm@3x.png"),
          ),
          Text(
            '完成',
            style: TextStyle(
                color: Color.fromRGBO(250, 250, 250, 1.0),
                fontWeight: FontWeight.bold,
                fontSize: 15 * ScaleW(context)),
          ),
        ],
      ),
    ),
  );
}

void onBackPressed(BuildContext context) {
  NavigatorState navigatorState = Navigator.of(context);
  if (navigatorState.canPop()) {
    navigatorState.pop();
  } else {
    SystemNavigator.pop();
  }
}
