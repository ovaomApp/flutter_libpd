import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_libpd_platform_interface.dart';
import 'models/models.dart';

/// An implementation of [FlutterLibpdPlatform] that uses method channels.
class MethodChannelFlutterLibpd extends FlutterLibpdPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_libpd');

  /// The event channel used to interact with the native platform.
  @visibleForTesting
  final eventChannel =
      const EventChannel('flutter_libpd_receive_message_stream');

  /// Patch
  static const _patchNameKey = 'patchName';
  static const _pathKey = 'path';

  @override
  Future<void> openPatch(PatchFile file) async {
    await methodChannel.invokeMethod<void>('openPatch', {
      _patchNameKey: file.name,
      _pathKey: file.path,
    });
  }

  @override
  Future<void> closePatch(PatchFile file) async {
    await methodChannel.invokeMethod<void>('closePatch', {
      _patchNameKey: file.name,
      _pathKey: file.path,
    });
  }

  /// Android Only
  @override
  Future<void> unzip(UnzipRequest request) async {
    /// TODO: Use federated Plugin instead
    if (Platform.isAndroid) {
      await methodChannel.invokeMethod<void>('unzip', <String, String>{
        'packageName': request.packageName,
        'filename': request.filename,
        'resourceType': request.resourceType
      });
    }
  }

  @override
  Future<String?> getAbsolutePath(String filename) {
    return methodChannel.invokeMethod<String?>('getAbsolutePath', filename);
  }

  /// Messages

  static const _receiverKey = 'receiver';

  @override
  Future<void> sendFloat(FloatMessage message) async {
    await methodChannel.invokeMethod<void>('sendFloat', {
      'value': message.value,
      _receiverKey: message.receiver,
    });
  }

  @override
  Future<void> sendBang(BangMessage message) async {
    await methodChannel.invokeMethod<void>('sendBang', message.receiver);
  }

  @override
  Future<void> sendSymbol(SymbolMessage message) async {
    await methodChannel.invokeMethod<void>('sendSymbol', {
      'symbol': message.value,
      _receiverKey: message.receiver,
    });
  }

  @override
  Future<void> sendList(ListMessage message) async {
    await methodChannel.invokeMethod<void>('sendList', {
      'list': message.value,
      _receiverKey: message.receiver,
    });
  }

  @override
  Future<void> sendMessage(ArgumentMessage message) async {
    await methodChannel.invokeMethod<void>('sendMessage', {
      'message': message.value,
      'arguments': message.arguments,
      _receiverKey: message.receiver,
    });
  }

  @override
  Stream<Map<String, dynamic>> receiveMessageStream(String source) {
    return eventChannel.receiveBroadcastStream([source]).map(
        (it) => Map<String, dynamic>.from(it));
  }

  /// Audio

  @override
  Future<void> startAudio() async {
    await methodChannel.invokeMethod<void>('startAudio');
  }

  @override
  Future<void> stopAudio() async {
    await methodChannel.invokeMethod<void>('stopAudio');
  }

  @override
  Future<void> configurePlayback(PlaybackConfiguration configuration) async {
    await methodChannel.invokeMethod<void>(
        'configurePlayback',
        <String, dynamic>{
          'sampleRate': configuration.sampleRate,
          'inputNumberOfChannels': configuration.inputNumberOfChannels,
          'outputNumberOfChannels': configuration.outputNumberOfChannels,
          'inputEnabled': configuration.inputEnabled,
        }..removeWhere((_, value) => value == null));
  }

  /// Dispose

  @override
  Future<void> dispose() async {
    await methodChannel.invokeMethod<void>('dispose');
  }
}
