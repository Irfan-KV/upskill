import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    private let VIEW_TYPE = "native-text-view"
    private let TIMER_CHANNEL = "com.example.timer"
    private let TIMER_CONTROL_CHANNEL = "com.example.timerControl"
    private var timer: Timer?
    private var timerValue = 0
    private var eventSink: FlutterEventSink?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Get the FlutterViewController.
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // Register the platform view.
        let factory = NativeTextViewFactory(messenger: controller.binaryMessenger)
        registrar(forPlugin: "NativeTextView")?.register(
            factory,
            withId: VIEW_TYPE
        )

        let eventChannel = FlutterEventChannel(name: TIMER_CHANNEL, binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(self)

        let methodChannel = FlutterMethodChannel(name: TIMER_CONTROL_CHANNEL, binaryMessenger: controller.binaryMessenger)
         methodChannel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "startTimer":
                self.startTimer()
                result(nil)
            case "stopTimer":
                self.stopTimer()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.timerValue += 1
            self.eventSink?(self.timerValue)
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension AppDelegate: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        timer?.invalidate()
        timer = nil
        timerValue = 0
        return nil
    }
}
