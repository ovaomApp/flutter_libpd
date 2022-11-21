import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_libpd/flutter_libpd_platform_interface.dart';
import 'package:flutter_libpd/models/models.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'received_messages.dart';

class MockFlutterLibpdPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLibpdPlatform {
  final receivedMessages = <ReceivedMessage>[];

  void _throwErrorIfNeeded({PlatformException? error}) {
    if (error != null) {
      throw error;
    }
  }

  // Patch

  PlatformException? _patchOpeningError;

  void completePatchOpeningWithError(PlatformException error) {
    _patchOpeningError = error;
  }

  @override
  Future<void> openPatch(PatchFile file) async {
    receivedMessages.add(OpenPatchMessage(file));
    _throwErrorIfNeeded(error: _patchOpeningError);
  }

  @override
  Future<void> closePatch(PatchFile file) async {
    receivedMessages.add(ClosePatchMessage(file));
  }

  PlatformException? _fileUnzippingError;

  void completeFileUnzippingWithError(PlatformException error) {
    _fileUnzippingError = error;
  }

  @override
  Future<void> unzip(UnzipRequest request) async {
    receivedMessages.add(UnzipFileMessage(request));
    _throwErrorIfNeeded(error: _fileUnzippingError);
  }

  String _patchPath = '';
  Exception? _patchPathError;

  void completeGettingAbsolutePath(String path, Exception? error) {
    _patchPath = path;
    _patchPathError = error;
  }

  @override
  Future<String?> getAbsolutePath(String filename) async {
    receivedMessages.add(GetAbsolutePathMessage(filename));
    return _patchPathError == null ? '$_patchPath$filename' : null;
  }

  // Messages

  PlatformException? _messageSendingError;

  void completeMessageSendingWithError(PlatformException error) {
    _messageSendingError = error;
  }

  @override
  Future<void> sendFloat(FloatMessage message) async {
    receivedMessages.add(SendFloatMessage(message));
    _throwErrorIfNeeded(error: _messageSendingError);
  }

  @override
  Future<void> sendBang(BangMessage message) async {
    receivedMessages.add(SendBangMessage(message));
    _throwErrorIfNeeded(error: _messageSendingError);
  }

  @override
  Future<void> sendSymbol(SymbolMessage message) async {
    receivedMessages.add(SendSymbolMessage(message));
    _throwErrorIfNeeded(error: _messageSendingError);
  }

  @override
  Future<void> sendList(ListMessage message) async {
    receivedMessages.add(SendListMessage(message));
    _throwErrorIfNeeded(error: _messageSendingError);
  }

  @override
  Future<void> sendMessage(ArgumentMessage message) async {
    receivedMessages.add(SendMessage(message));
    _throwErrorIfNeeded(error: _messageSendingError);
  }

  final _receiveMessageController = StreamController<Map<String, dynamic>>();

  void sendReceiveMessage(Map<String, dynamic> message) {
    _receiveMessageController.add(message);
  }

  @override
  Stream<Map<String, dynamic>> receiveMessageStream(String source) {
    receivedMessages.add(ReceiveMessageStream(source));
    return _receiveMessageController.stream;
  }

  // Audio

  PlatformException? _playbackConfigError;

  void completePlaybackConfigurationWithError(PlatformException error) {
    _playbackConfigError = error;
  }

  @override
  Future<void> configurePlayback(PlaybackConfiguration configuration) async {
    receivedMessages.add(ConfigurePlaybackMessage(configuration));
    _throwErrorIfNeeded(error: _playbackConfigError);
  }

  @override
  Future<void> startAudio() async {
    receivedMessages.add(const StartAudioMessage());
  }

  @override
  Future<void> stopAudio() async {
    receivedMessages.add(const StopAudioMessage());
  }

  // Dispose

  @override
  Future<void> dispose() async {
    receivedMessages.add(const DisposeMessage());
  }
}
