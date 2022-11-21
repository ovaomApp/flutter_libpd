import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_libpd_method_channel.dart';
import 'models/models.dart';

abstract class FlutterLibpdPlatform extends PlatformInterface {
  /// Constructs a FlutterLibpdPlatform.
  FlutterLibpdPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLibpdPlatform _instance = MethodChannelFlutterLibpd();

  /// The default instance of [FlutterLibpdPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLibpd].
  static FlutterLibpdPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLibpdPlatform] when
  /// they register themselves.
  static set instance(FlutterLibpdPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> openPatch(PatchFile file) {
    throw UnimplementedError('openPatch() has not been implemented.');
  }

  Future<void> closePatch(PatchFile file) {
    throw UnimplementedError('closePatch() has not been implemented.');
  }

  Future<void> sendFloat(FloatMessage message) {
    throw UnimplementedError('sendFloat() has not been implemented.');
  }

  Future<void> sendBang(BangMessage message) {
    throw UnimplementedError('sendBang() has not been implemented.');
  }

  Future<void> sendSymbol(SymbolMessage message) {
    throw UnimplementedError('sendSymbol() has not been implemented.');
  }

  Future<void> sendList(ListMessage message) {
    throw UnimplementedError('sendList() has not been implemented.');
  }

  Future<void> sendMessage(ArgumentMessage message) {
    throw UnimplementedError('sendMessage() has not been implemented.');
  }

  Future<void> startAudio() {
    throw UnimplementedError('startAudio() has not been implemented.');
  }

  Future<void> stopAudio() {
    throw UnimplementedError('stopAudio() has not been implemented.');
  }

  Future<void> configurePlayback(PlaybackConfiguration configuration) {
    throw UnimplementedError('configurePlayback() has not been implemented.');
  }

  Future<void> dispose() {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  Stream<Map<String, dynamic>> receiveMessageStream(String source) {
    throw UnimplementedError(
        'receiveMessageStream() has not been implemented.');
  }

  Future<void> unzip(UnzipRequest request) {
    throw UnimplementedError('unzip() has not been implemented.');
  }

  Future<String?> getAbsolutePath(String filename) {
    throw UnimplementedError('getAbsolutePath() has not been implemented.');
  }
}
