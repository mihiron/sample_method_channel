package com.example.sample_method_channel

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.example.app/methods"
    }

    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        channel.setMethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
            when(methodCall.method){
                "myKotlinMethod" -> {
                    Log.e("Android", "arguments: ${methodCall.arguments}")
                    val response = "called from Flutter!"
                    result.success(response)
                }
                else -> {
                    result.notImplemented()
                }
            }
            callFlutterMethod()
        }

    }

    private fun callFlutterMethod() {
        channel.invokeMethod("myFlutterMethod", "Hello Flutter! by Kotlin", object : MethodChannel.Result {
            override fun success(result: Any?) {
                Log.d("Android", "result: $result")
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                Log.d("Android", "$errorCode, $errorMessage, $errorDetails")
            }
            override fun notImplemented() {
                Log.d("Android", "notImplemented")
            }
        })
    //        result.success(null)

    }

}
