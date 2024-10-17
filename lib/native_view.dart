import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeView extends StatelessWidget {
  // This is the name used to identify the platform view type for Android.
  static const String _viewType = 'native-text-view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native View'),
      ),
      body: Center(
        child: SizedBox(
          height: 50,
          width: 300,
          child: Platform.isAndroid
              ? const AndroidView(
                  viewType: _viewType,
                  creationParams: {'text': 'Hello from Flutter on Android!'},
                  creationParamsCodec: StandardMessageCodec(),
                )
              : Platform.isIOS
                  ? const UiKitView(
                      viewType: _viewType,
                      creationParams: {'text': 'Hello from Flutter on iOS!'},
                      creationParamsCodec: StandardMessageCodec(),
                    )
                  : const SizedBox(),
        ),
      ),
    );
  }
}
