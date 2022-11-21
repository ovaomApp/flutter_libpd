import 'flutter_libpd_platform_interface.dart';
import 'models/models.dart';

class FlutterLibpd {
  FlutterLibpdPlatform get _instance => FlutterLibpdPlatform.instance;

  // Patch

  /// May throw [PlatformException]
  Future<void> openPatch(PatchFile file) {
    return _instance.openPatch(file);
  }

  Future<void> closePatch(PatchFile file) {
    return _instance.closePatch(file);
  }

  Future<void> unzip(UnzipRequest request) {
    return _instance.unzip(request);
  }

  Future<String?> getAbsolutePath(String filename) {
    return _instance.getAbsolutePath(filename);
  }

  // Messages

  /// May throw [PlatformException]
  Future<void> sendFloat(FloatMessage message) {
    return _instance.sendFloat(message);
  }

  /// May throw [PlatformException]
  Future<void> sendBang(BangMessage message) {
    return _instance.sendBang(message);
  }

  /// May throw [PlatformException]
  Future<void> sendSymbol(SymbolMessage message) {
    return _instance.sendSymbol(message);
  }

  /// May throw [PlatformException]
  Future<void> sendList(ListMessage message) {
    return _instance.sendList(message);
  }

  /// May throw [PlatformException]
  Future<void> sendMessage(ArgumentMessage message) {
    return _instance.sendMessage(message);
  }

  Stream<Map<String, dynamic>> receiveMessageStream(String source) {
    return _instance.receiveMessageStream(source);
  }

  // Audio

  Future<void> startAudio() {
    return _instance.startAudio();
  }

  Future<void> stopAudio() {
    return _instance.stopAudio();
  }

  /// May throw [PlatformException]
  Future<void> configurePlayback(PlaybackConfiguration configuration) {
    return _instance.configurePlayback(configuration);
  }

  // Dispose

  Future<void> dispose() {
    return _instance.dispose();
  }
}
