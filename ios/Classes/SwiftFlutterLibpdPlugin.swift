import Flutter
import UIKit

public class SwiftFlutterLibpdPlugin: NSObject, FlutterPlugin {
    
    let pdController: PdController
    let bundle: Bundle
    
    public init(bundle: Bundle = Bundle.main, pdController: PdController = PdController()) {
        self.bundle = bundle
        self.pdController = pdController
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_libpd", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterLibpdPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        FlutterEventChannel(name: "flutter_libpd_receive_message_stream", binaryMessenger: registrar.messenger())
            .setStreamHandler(ReceiveMessageStreamHandler(messageReceiver: PdMessageReceiverImpl()))
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "openPatch":
            openPatch(call.arguments, result: result)
        case "closePatch":
            closePatch(call.arguments, result: result)
        case "getAbsolutePath":
            getAbsolutePath(call.arguments, result: result)
        case "sendFloat":
            sendFloat(call.arguments, result: result)
        case "sendBang":
            sendBang(call.arguments, result: result)
        case "sendSymbol":
            sendSymbol(call.arguments, result: result)
        case "sendList":
            sendList(call.arguments, result: result)
        case "sendMessage":
            sendMessage(call.arguments, result: result)
        case "configurePlayback":
            configurePlayback(call.arguments, result: result)
        case "startAudio":
            startAudio(result)
        case "stopAudio":
            stopAudio(result)
        case "dispose":
            dispose(result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
