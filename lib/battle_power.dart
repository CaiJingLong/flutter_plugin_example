import 'dart:async';

import 'package:flutter/services.dart';

class BattlePower {
  static const MethodChannel _channel = const MethodChannel('battle_power');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<int> requestNativeAdd(int x, int y) async {
    int result = await _channel.invokeMethod('add', {"x": x, "y": y});
    return result;
  }

  static const BasicMessageChannel<dynamic> runTimer = const BasicMessageChannel("run_time", StandardMessageCodec());

  static void initMessageHandler() {
    print("initMessageHandler");
    runTimer.setMessageHandler((dynamic value) {
      // 接收到的时间
      int time = value;
      print("value = $time");
    });
  }
}
