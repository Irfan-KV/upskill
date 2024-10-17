package com.example.upskill

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import com.example.upskill.nativeView.NativeTextViewFactory
import android.os.Handler
import android.os.Looper

class MainActivity: FlutterActivity() {
    private val TIMER_CHANNEL = "com.example.timer"
    private val TIMER_CONTROL_CHANNEL = "com.example.timerControl"
    private val VIEW_TYPE = "native-text-view"
    private var timerHandler: Handler? = null
    private var timerRunnable: Runnable? = null
    private var timerValue = 0

    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register the platform view.
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(VIEW_TYPE, NativeTextViewFactory())

        timerHandler = Handler(Looper.getMainLooper())
        timerRunnable = object : Runnable {
            override fun run() {
                timerValue++
                timerHandler?.postDelayed(this, 1000)
                // Notify all active listeners
                eventSink?.success(timerValue)
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, TIMER_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    timerValue = 0
                    eventSink = null
                }
            }
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TIMER_CONTROL_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startTimer" -> {
                    timerHandler?.post(timerRunnable!!)
                    result.success(null)
                }
                "stopTimer" -> {
                    timerHandler?.removeCallbacks(timerRunnable!!)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
