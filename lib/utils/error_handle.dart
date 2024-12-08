import 'dart:async';

import 'package:flutter/material.dart';

void handleError(void Function() body) {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  runZonedGuarded(body, (error, statck) async {
    await reportError(error, statck);
  });
}

Future<void> reportError(Object error, StackTrace stack) async {
  // 上报错误消息
}
