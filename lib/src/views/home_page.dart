import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MethodChannel channel = MethodChannel("com.example.app/methods");

Future<void> callNativeMethod() async {
  String argument;
  String method;
  if (Platform.isAndroid) {
    argument = "Hello Kotlin!";
    method = "myKotlinMethod";
  } else if (Platform.isIOS) {
    argument = "Hello Swift!";
    method = "mySwiftMethod";
  } else {
    throw UnsupportedError("This platform is not supported");
  }

  final String result = await channel.invokeMethod(method, argument);

  debugPrint("result: $result");
}

Future<dynamic> platformCallHandler(MethodCall call) async {
  switch (call.method) {
    case "myFlutterMethod":
      debugPrint("arguments: ${call.arguments}");
      return Future.value("called from Native!");
    // エラーを返す時
    // return Future.error('error message!!');
    default:
      debugPrint("Unknowm method ${call.method}");
      throw MissingPluginException();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    channel.setMethodCallHandler(platformCallHandler);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            ElevatedButton(
              onPressed: callNativeMethod,
              child: Text("callNativeMethod"),
            ),
          ],
        ),
      ),
    );
  }
}
