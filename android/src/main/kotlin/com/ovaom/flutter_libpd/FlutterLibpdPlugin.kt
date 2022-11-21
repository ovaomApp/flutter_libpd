package com.ovaom.flutter_libpd

import android.content.Context
import android.content.res.Resources
import androidx.annotation.NonNull
import com.ovaom.flutter_libpd.event_channel.ReceiveMessageStreamHandler
import com.ovaom.flutter_libpd.helpers.*
import com.ovaom.flutter_libpd.pd_controller.PdController
import com.ovaom.flutter_libpd.pd_controller.pd_audio_manager.PdAudioManagerImpl
import com.ovaom.flutter_libpd.pd_controller.pd_message_receiver.PdMessageReceiver
import com.ovaom.flutter_libpd.pd_controller.pd_message_receiver.PdMessageReceiverImpl
import com.ovaom.flutter_libpd.pd_controller.pd_messenger.PdMessengerImpl
import com.ovaom.flutter_libpd.pd_controller.pd_patch_file_manager.PdPatchFileManagerImpl

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel
import java.io.File

/** FlutterLibpdPlugin */
class FlutterLibpdPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    lateinit var pdController: PdController
    private lateinit var pdMessageReceiver: PdMessageReceiver
    lateinit var scope: CoroutineScope
    private lateinit var context: Context

    val filesDir: File
        get() = context.filesDir
    val resources: Resources
        get() = context.resources

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        scope = CoroutineScope(Job() + Dispatchers.Main)
        pdController = PdController(
            PdMessengerImpl(),
            PdPatchFileManagerImpl(),
            PdAudioManagerImpl(flutterPluginBinding.applicationContext)
        )
        pdMessageReceiver = PdMessageReceiverImpl()
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_libpd")
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(
            flutterPluginBinding.binaryMessenger,
            "flutter_libpd_receive_message_stream"
        )
        eventChannel.setStreamHandler(ReceiveMessageStreamHandler(pdMessageReceiver))
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "openPatch" -> openPatch(call, result)
            "closePatch" -> closePatch(call, result)
            "getAbsolutePath" -> getAbsolutePath(call, result)
            "unzip" -> unzip(call, result)
            "sendFloat" -> sendFloat(call, result)
            "sendBang" -> sendBang(call, result)
            "sendSymbol" -> sendSymbol(call, result)
            "sendList" -> sendList(call, result)
            "sendMessage" -> sendMessage(call, result)
            "configurePlayback" -> configurePlayback(call, result)
            "startAudio" -> startAudio(result)
            "stopAudio" -> stopAudio(result)
            "dispose" -> dispose(result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        scope.cancel()
        pdMessageReceiver.dispose()
        pdController.dispose()
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }
}