import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'log.dart';

class MD5Util {
  static String generateMd5(Map map) {
    var key = "SGO2sl3mxckui(xkdsfjkk-324i983^sss^";
    Map params = Map.from(map);
    params["key"] = key;
    var keys = params.keys.toList();
    keys.sort();

    var url = '';
    keys.forEach((element) {
      if (element != keys.first) {
        url = url + '&';
      }
      printLog(element, StackTrace.current);
      var keyValue = element + '=' + params[element];
      url = url + keyValue;
    });
    // printLog(url, StackTrace.current);
    // return md5.convert(utf8.encode(url)).toString();
    var content = new Utf8Encoder().convert(url);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return digest.toString();
  }
}
