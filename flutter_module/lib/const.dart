import 'package:flutter/material.dart';

final Color AppThemeColor = Color.fromRGBO(89, 138, 239, 0.9921568627450981);

//屏幕宽度
double ScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double ScreenHeight(BuildContext context) => MediaQuery.of(context).size.height;
double ScaleW(BuildContext context) => MediaQuery.of(context).size.width / 375;
