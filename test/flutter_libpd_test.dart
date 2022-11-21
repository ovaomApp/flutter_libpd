import 'package:flutter/services.dart';
import 'package:flutter_libpd/flutter_libpd.dart';
import 'package:flutter_libpd/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_libpd/flutter_libpd_platform_interface.dart';
import 'package:flutter_libpd/flutter_libpd_method_channel.dart';
import 'helpers/mock_flutter_libpd_platform_barrel.dart';

void main() {
  test('$MethodChannelFlutterLibpd is the default instance', () {
    final FlutterLibpdPlatform initialPlatform = FlutterLibpdPlatform.instance;
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLibpd>());
  });

  group('openPatch', () {
    test('requests patch opening', () async {
      final wrapper = _makeSUT();

      await wrapper.sut.openPatch(_anyPatchFile());

      expect(wrapper.fakePlatform.receivedMessages, [
        OpenPatchMessage(_anyPatchFile()),
      ]);
    });

    test('fails on patch opening error', () async {
      final wrapper = _makeSUT();

      wrapper.fakePlatform.completePatchOpeningWithError(_anyError());

      _expectThrowsPlatformException(
        wrapper.sut.openPatch(_anyPatchFile()),
      );
    });
  });

  test('closePatch requests patch closing', () async {
    final wrapper = _makeSUT();

    await wrapper.sut.closePatch(_anyPatchFile());

    expect(wrapper.fakePlatform.receivedMessages, [
      ClosePatchMessage(_anyPatchFile()),
    ]);
  });

  group('unzip', () {
    test('requests file unzipping', () async {
      final wrapper = _makeSUT();

      await wrapper.sut.unzip(_anyUnzipRequest());

      expect(wrapper.fakePlatform.receivedMessages, [
        UnzipFileMessage(_anyUnzipRequest()),
      ]);
    });

    test('fails on file unzipping error', () async {
      final wrapper = _makeSUT();

      wrapper.fakePlatform.completeFileUnzippingWithError(_anyError());

      _expectThrowsPlatformException(
        wrapper.sut.unzip(_anyUnzipRequest()),
      );
    });
  });

  group('getAbsolutePath', () {
    test('gets path of patch file', () async {
      final wrapper = _makeSUT();
      wrapper.fakePlatform
          .completeGettingAbsolutePath(_anyPatchFile().path, null);

      final absPath = await wrapper.sut.getAbsolutePath(_anyPatchFile().name);

      expect(wrapper.fakePlatform.receivedMessages, [
        GetAbsolutePathMessage(_anyPatchFile().name),
      ]);
      expect(absPath, '${_anyPatchFile().path}${_anyPatchFile().name}');
    });

    test('does not get path of patch file on error', () async {
      final wrapper = _makeSUT();
      wrapper.fakePlatform
          .completeGettingAbsolutePath(_anyPatchFile().path, _anyError());

      final absPath = await wrapper.sut.getAbsolutePath(_anyPatchFile().name);

      expect(absPath, null);
    });
  });

  group('configure playback', () {
    test('requests playback configuration', () async {
      final wrapper = _makeSUT();

      await wrapper.sut.configurePlayback(_anyPlayConfiguration());

      expect(wrapper.fakePlatform.receivedMessages, [
        ConfigurePlaybackMessage(_anyPlayConfiguration()),
      ]);
    });

    test('fails on playback configuration error', () async {
      final wrapper = _makeSUT();

      wrapper.fakePlatform.completePlaybackConfigurationWithError(_anyError());

      _expectThrowsPlatformException(
        wrapper.sut.configurePlayback(_anyPlayConfiguration()),
      );
    });
  });

  test('startAudio requests audio state changing', () async {
    final wrapper = _makeSUT();

    await wrapper.sut.startAudio();

    expect(wrapper.fakePlatform.receivedMessages, const [
      StartAudioMessage(),
    ]);
  });

  test('stopAudio requests audio state changing', () async {
    final wrapper = _makeSUT();

    await wrapper.sut.stopAudio();

    expect(wrapper.fakePlatform.receivedMessages, const [
      StopAudioMessage(),
    ]);
  });

  group('Send X Message', () {
    test('sends it successfully', () async {
      final wrapper = _makeSUT();

      await wrapper.sut.sendFloat(_anyFloatMessage());
      expect(
        wrapper.fakePlatform.receivedMessages[0],
        SendFloatMessage(_anyFloatMessage()),
      );

      await wrapper.sut.sendBang(_anyBangMessage());
      expect(
        wrapper.fakePlatform.receivedMessages[1],
        SendBangMessage(_anyBangMessage()),
      );

      await wrapper.sut.sendSymbol(_anySymbolMessage());
      expect(
        wrapper.fakePlatform.receivedMessages[2],
        SendSymbolMessage(_anySymbolMessage()),
      );

      await wrapper.sut.sendList(_anyListMessage());
      expect(
        wrapper.fakePlatform.receivedMessages[3],
        SendListMessage(_anyListMessage()),
      );

      await wrapper.sut.sendMessage(_anyArgumentMessage());
      expect(
        wrapper.fakePlatform.receivedMessages[4],
        SendMessage(_anyArgumentMessage()),
      );

      expect(wrapper.fakePlatform.receivedMessages.length, 5);
    });

    test('fails on error', () {
      final wrapper = _makeSUT();

      wrapper.fakePlatform.completeMessageSendingWithError(_anyError());

      _expectThrowsPlatformException(
        wrapper.sut.sendFloat(_anyFloatMessage()),
      );

      _expectThrowsPlatformException(
        wrapper.sut.sendBang(_anyBangMessage()),
      );

      _expectThrowsPlatformException(
        wrapper.sut.sendSymbol(_anySymbolMessage()),
      );

      _expectThrowsPlatformException(
        wrapper.sut.sendList(_anyListMessage()),
      );

      _expectThrowsPlatformException(
        wrapper.sut.sendMessage(_anyArgumentMessage()),
      );
    });
  });

  test('receiveMessageStream emits message', () {
    final wrapper = _makeSUT();

    expectLater(
      wrapper.sut.receiveMessageStream(_anyReceiver()),
      emits(_anyReceiveStreamMessage()),
    );

    wrapper.fakePlatform.sendReceiveMessage(_anyReceiveStreamMessage());

    expect(wrapper.fakePlatform.receivedMessages, [
      ReceiveMessageStream(_anyReceiver()),
    ]);
  });

  test('dispose requests states cleaning', () async {
    final wrapper = _makeSUT();

    await wrapper.sut.dispose();

    expect(wrapper.fakePlatform.receivedMessages, const [
      DisposeMessage(),
    ]);
  });
}

// Helpers

_Wrapper _makeSUT() {
  FlutterLibpd flutterLibpdPlugin = FlutterLibpd();
  MockFlutterLibpdPlatform fakePlatform = MockFlutterLibpdPlatform();
  FlutterLibpdPlatform.instance = fakePlatform;

  return _Wrapper(flutterLibpdPlugin, fakePlatform);
}

void _expectThrowsPlatformException(Future<void> action) {
  expect(
    () => action,
    throwsA(isA<PlatformException>()),
  );
}

FloatMessage _anyFloatMessage() {
  return FloatMessage(value: _anyFloatValue(), receiver: _anyReceiver());
}

BangMessage _anyBangMessage() {
  return BangMessage(receiver: _anyReceiver());
}

SymbolMessage _anySymbolMessage() {
  return SymbolMessage(value: 'anySymbol', receiver: _anyReceiver());
}

ListMessage _anyListMessage() {
  return ListMessage(
    value: [_anyStringValue(), _anyFloatValue()],
    receiver: _anyReceiver(),
  );
}

ArgumentMessage _anyArgumentMessage() {
  return ArgumentMessage(
    value: _anyStringValue(),
    arguments: [_anyStringValue(), _anyFloatMessage()],
    receiver: _anyReceiver(),
  );
}

Map<String, dynamic> _anyReceiveStreamMessage() {
  return {
    'source': _anyReceiver(),
    'value': [_anyReceiver()],
    'symbol': _anyStringValue()
  };
}

String _anyStringValue() {
  return 'any';
}

double _anyFloatValue() {
  return 0.5;
}

String _anyReceiver() {
  return 'anyReceiver';
}

PlaybackConfiguration _anyPlayConfiguration() {
  return const PlaybackConfiguration(inputEnabled: true);
}

PatchFile _anyPatchFile() {
  return const PatchFile('anyPatchName.pd', 'any/Path/');
}

PlatformException _anyError() {
  return PlatformException(code: 'anyError');
}

UnzipRequest _anyUnzipRequest() {
  return const UnzipRequest(
      filename: 'anyFileName',
      packageName: 'com.any.package',
      resourceType: 'anyResourceType');
}

class _Wrapper {
  final FlutterLibpd sut;
  final MockFlutterLibpdPlatform fakePlatform;

  const _Wrapper(this.sut, this.fakePlatform);
}
