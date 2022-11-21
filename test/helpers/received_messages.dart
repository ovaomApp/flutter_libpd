import 'package:equatable/equatable.dart';
import 'package:flutter_libpd/models/models.dart';

abstract class ReceivedMessage extends Equatable {
  const ReceivedMessage();

  @override
  List<Object> get props => [];
}

abstract class PatchMessage extends ReceivedMessage {
  final PatchFile file;

  const PatchMessage(this.file);

  @override
  List<Object> get props => [file];
}

class OpenPatchMessage extends PatchMessage {
  const OpenPatchMessage(super.file);
}

class ClosePatchMessage extends PatchMessage {
  const ClosePatchMessage(super.file);
}

class UnzipFileMessage extends ReceivedMessage {
  final UnzipRequest request;

  const UnzipFileMessage(this.request);

  @override
  List<Object> get props => [request];
}

class GetAbsolutePathMessage extends ReceivedMessage {
  final String filename;

  const GetAbsolutePathMessage(this.filename);

  @override
  List<Object> get props => [filename];
}

class StartAudioMessage extends ReceivedMessage {
  const StartAudioMessage();
}

class StopAudioMessage extends ReceivedMessage {
  const StopAudioMessage();
}

class ConfigurePlaybackMessage extends ReceivedMessage {
  final PlaybackConfiguration configuration;

  const ConfigurePlaybackMessage(this.configuration);

  @override
  List<Object> get props => [configuration];
}

class DisposeMessage extends ReceivedMessage {
  const DisposeMessage();
}

abstract class SendBaseMessage<T extends Equatable> extends ReceivedMessage {
  final T message;

  const SendBaseMessage(this.message);

  @override
  List<Object> get props => [message];
}

class SendFloatMessage extends SendBaseMessage<FloatMessage> {
  const SendFloatMessage(super.message);
}

class SendBangMessage extends SendBaseMessage<BangMessage> {
  const SendBangMessage(super.message);
}

class SendSymbolMessage extends SendBaseMessage<SymbolMessage> {
  const SendSymbolMessage(super.message);
}

class SendListMessage extends SendBaseMessage<ListMessage> {
  const SendListMessage(super.message);
}

class SendMessage extends SendBaseMessage<ArgumentMessage> {
  const SendMessage(super.message);
}

class ReceiveMessageStream extends ReceivedMessage {
  final String source;

  const ReceiveMessageStream(this.source);
}
