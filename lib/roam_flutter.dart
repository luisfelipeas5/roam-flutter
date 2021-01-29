import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef void RoamCallBack({
  @required String roamStatus,
  Map<dynamic, dynamic> location,
  List<Map<dynamic, dynamic>> roamEvents,
  Map<dynamic, dynamic> roamUser,
});

class RoamFlutter {
  static const String METHOD_INITIALIZE = "initialize";
  static const String METHOD_GET_CURRENT_LOCATION = "getCurrentLocation";
  static const MethodChannel _channel = const MethodChannel('roam_flutter');
  static RoamCallBack _callBack;

  static Future<bool> initialize({
    @required String publishKey,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'publishKey': publishKey
    };
    final bool result = await _channel.invokeMethod(METHOD_INITIALIZE, params);
    _channel.setMethodCallHandler(_methodCallHandler);
    return result;
  }

  static Future<void> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'callback':
        _callBack(
          roamStatus: call.arguments['roamStatus'],
          location: call.arguments['location'],
          roamEvents: call.arguments['roamEvents'],
          roamUser: call.arguments['roamUser'],
        );
        break;
      default:
        print('This normally shouldn\'t happen.');
    }
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
