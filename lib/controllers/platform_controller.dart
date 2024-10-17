import 'dart:async';

import 'package:flutter/services.dart';

class PlatformController {
  // Define a MethodChannel with a unique name.
  static const EventChannel _eventChannel = EventChannel('com.example.timer');
  static const MethodChannel _methodChannel = MethodChannel('com.example.timerControl');
  static StreamSubscription? subscription;

  static void startTimer({required Function(int) onEvent}) {
    try {
      _methodChannel.invokeMethod('startTimer');
      subscription = _eventChannel.receiveBroadcastStream().listen((event) {
        onEvent(event);
      });
    } catch (e) {
      print(e);
    }
  }

  static void stopTimer() {
    try {
      _methodChannel.invokeMethod('stopTimer');
      subscription?.cancel();
    } catch (e) {
      print(e);
    }
  }
}
