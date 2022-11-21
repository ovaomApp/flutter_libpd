@Timeout(Duration(seconds: 1))

import 'package:flutter/services.dart';
import 'package:flutter_libpd/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_libpd/flutter_libpd_method_channel.dart';

void main() {
  MethodChannelFlutterLibpd platform = MethodChannelFlutterLibpd();
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<MethodCall> logs;

  setUp(() {
    logs = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(
            platform.methodChannel, (methodCall) async => logs.add(methodCall));
  });

  tearDown(() {
    logs.clear();
    TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
        .setMockMethodCallHandler(platform.methodChannel, null);
  });

  test('openPatch is properly called', () async {
    const files = [
      PatchFile('', ''),
      PatchFile('anyPatchName.pd', 'any/Path/')
    ];

    await platform.openPatch(files[0]);
    await platform.openPatch(files[1]);

    _expectLogsCallCount(logs, 2);
    _expectPatchMethodCall('openPatch', files[0], logs[0]);
    _expectPatchMethodCall('openPatch', files[1], logs[1]);
  });

  test('closePatch is properly called', () async {
    const files = [
      PatchFile('', ''),
      PatchFile('anyPatchName.pd', 'any/Path/')
    ];

    await platform.closePatch(files[0]);
    await platform.closePatch(files[1]);

    _expectLogsCallCount(logs, 2);
    _expectPatchMethodCall('closePatch', files[0], logs[0]);
    _expectPatchMethodCall('closePatch', files[1], logs[1]);
  });

  test('sendFloat is properly called', () async {
    final messages = [
      FloatMessage(value: 0.5, receiver: _anyReceiver()),
      FloatMessage(value: 0.7, receiver: _anyReceiver('2')),
    ];

    await platform.sendFloat(messages[0]);
    await platform.sendFloat(messages[1]);

    _expectLogsCallCount(logs, 2);
    _expectSendFloat(messages[0], logs[0]);
    _expectSendFloat(messages[1], logs[1]);
  });

  test('sendBang is properly called', () async {
    final messages = [
      BangMessage(receiver: _anyReceiver()),
      BangMessage(receiver: _anyReceiver('2')),
    ];

    await platform.sendBang(messages[0]);
    await platform.sendBang(messages[1]);

    _expectLogsCallCount(logs, 2);
    _expectSendBang(messages[0], logs[0]);
    _expectSendBang(messages[1], logs[1]);
  });

  test('sendSymbol is properly called', () async {
    final messages = [
      SymbolMessage(value: 's1', receiver: _anyReceiver()),
      SymbolMessage(value: 's2', receiver: _anyReceiver('2')),
    ];

    await platform.sendSymbol(messages[0]);
    await platform.sendSymbol(messages[1]);

    _expectLogsCallCount(logs, 2);
    _expectSendSymbol(messages[0], logs[0]);
    _expectSendSymbol(messages[1], logs[1]);
  });

  test('sendList is properly called', () async {
    final messages = [
      ListMessage(value: const ['s1', 0.4], receiver: _anyReceiver()),
      ListMessage(value: const ['s2', 0.6], receiver: _anyReceiver('2')),
    ];

    await platform.sendList(messages[0]);
    await platform.sendList(messages[1]);

    _expectLogsCallCount(logs, 2);
    _expectSendList(messages[0], logs[0]);
    _expectSendList(messages[1], logs[1]);
  });

  test('sendMessage is properly called', () async {
    final messages = [
      ArgumentMessage(
        value: 'm1',
        arguments: const ['s1', 0.4],
        receiver: _anyReceiver(),
      ),
      ArgumentMessage(
        value: 'm2',
        arguments: const ['s2', 0.6],
        receiver: _anyReceiver('2'),
      ),
    ];

    await platform.sendMessage(messages[0]);
    await platform.sendMessage(messages[1]);

    _expectLogsCallCount(logs, 2);
    _expectSendMessage(messages[0], logs[0]);
    _expectSendMessage(messages[1], logs[1]);
  });

  test('startAudio is properly called', () async {
    await platform.startAudio();

    _expectSimpleCall('startAudio', logs);
  });

  test('stopAudio is properly called', () async {
    await platform.stopAudio();

    _expectSimpleCall('stopAudio', logs);
  });

  group('configurePlayback is properly called', () {
    test('with all params', () async {
      const configuration = PlaybackConfiguration(
          sampleRate: 44100,
          inputNumberOfChannels: 1,
          outputNumberOfChannels: 1,
          inputEnabled: true);

      await platform.configurePlayback(configuration);

      _expectConfigurePlayback(logs, {
        'sampleRate': configuration.sampleRate,
        'inputNumberOfChannels': configuration.inputNumberOfChannels,
        'outputNumberOfChannels': configuration.outputNumberOfChannels,
        'inputEnabled': configuration.inputEnabled,
      });
    });

    test('only with sampleRate', () async {
      const configuration = PlaybackConfiguration(
        sampleRate: 68100,
        inputEnabled: false,
      );

      await platform.configurePlayback(configuration);

      _expectConfigurePlayback(logs, {
        'sampleRate': configuration.sampleRate,
        'inputEnabled': configuration.inputEnabled,
      });
    });

    test('only with inputNumberOfChannels', () async {
      const configuration = PlaybackConfiguration(
        inputNumberOfChannels: 2,
        inputEnabled: false,
      );

      await platform.configurePlayback(configuration);

      _expectConfigurePlayback(logs, {
        'inputNumberOfChannels': configuration.inputNumberOfChannels,
        'inputEnabled': configuration.inputEnabled,
      });
    });

    test('only with outputNumberOfChannels', () async {
      const configuration = PlaybackConfiguration(
        outputNumberOfChannels: 3,
        inputEnabled: false,
      );

      await platform.configurePlayback(configuration);

      _expectConfigurePlayback(logs, {
        'outputNumberOfChannels': configuration.outputNumberOfChannels,
        'inputEnabled': configuration.inputEnabled,
      });
    });

    test('only with inputEnabled', () async {
      const configuration = PlaybackConfiguration(inputEnabled: true);

      await platform.configurePlayback(configuration);

      _expectConfigurePlayback(logs, {
        'inputEnabled': configuration.inputEnabled,
      });
    });
  });

  test('dispose is properly called', () async {
    await platform.dispose();

    _expectSimpleCall('dispose', logs);
  });

  test('receiveMessageStream emits message', () async {
    const anySource = 'anySource';
    const data = {
      'source': anySource,
      'symbol': 'anySymbol',
      'value': [20]
    };

    expectLater(
      platform.receiveMessageStream(anySource),
      emits(data),
    );

    _eventChannelSendsMessage(platform.eventChannel, data);
  });

  /// TODO: Use federated Plugin instead and uncomment this test
  // test('unzip is properly called', () async {
  //   const request = UnzipRequest(
  //     filename: 'anyFilename',
  //     packageName: 'com.any.package',
  //     resourceType: 'raw',
  //   );
  //   await platform.unzip(request);

  //   _expectUnzip(request, logs);
  // });

  test('getAbsolutePath is properly called', () async {
    await platform.getAbsolutePath('anyPatch.pd');
    await platform.getAbsolutePath('anotherPatch.pd');

    expect(logs, <Matcher>[
      isMethodCall('getAbsolutePath', arguments: 'anyPatch.pd'),
      isMethodCall('getAbsolutePath', arguments: 'anotherPatch.pd'),
    ]);
  });
}

// Helpers

void _eventChannelSendsMessage(EventChannel eventChannel, dynamic data) async {
  TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
      .handlePlatformMessage(eventChannel.name,
          eventChannel.codec.encodeSuccessEnvelope(data), null);
}

void _expectSimpleCall(
  String methodName,
  List<MethodCall> logs,
) {
  expect(logs, <Matcher>[isMethodCall(methodName, arguments: null)]);
}

void _expectUnzip(
  UnzipRequest request,
  List<MethodCall> logs,
) {
  expect(
    logs,
    <Matcher>[
      isMethodCall('unzip', arguments: <String, String>{
        'packageName': request.packageName,
        'resourceType': request.resourceType,
        'filename': request.filename,
      })
    ],
  );
}

void _expectConfigurePlayback(
  List<MethodCall> logs,
  Map<String, dynamic> arguments,
) {
  expect(
    logs,
    <Matcher>[isMethodCall('configurePlayback', arguments: arguments)],
  );
}

void _expectLogsCallCount(List<MethodCall> logs, int count) {
  expect(logs.length, count);
}

void _expectSendFloat(FloatMessage message, MethodCall call) {
  expect(
    call,
    isMethodCall('sendFloat', arguments: <String, Object>{
      'value': message.value,
      'receiver': message.receiver,
    }),
  );
}

void _expectSendBang(BangMessage message, MethodCall call) {
  expect(
    call,
    isMethodCall(
      'sendBang',
      arguments: message.receiver,
    ),
  );
}

void _expectSendSymbol(SymbolMessage message, MethodCall call) {
  expect(
    call,
    isMethodCall('sendSymbol', arguments: <String, Object>{
      'symbol': message.value,
      'receiver': message.receiver,
    }),
  );
}

void _expectSendList(ListMessage message, MethodCall call) {
  expect(
    call,
    isMethodCall('sendList', arguments: <String, Object>{
      'list': message.value,
      'receiver': message.receiver,
    }),
  );
}

void _expectSendMessage(ArgumentMessage message, MethodCall call) {
  expect(
    call,
    isMethodCall('sendMessage', arguments: <String, Object>{
      'message': message.value,
      'arguments': message.arguments,
      'receiver': message.receiver,
    }),
  );
}

void _expectPatchMethodCall(String methodName, PatchFile file, MethodCall log) {
  expect(
    log,
    isMethodCall(methodName, arguments: <String, Object>{
      'patchName': file.name,
      'path': file.path,
    }),
  );
}

String _anyReceiver([String? name]) => 'anyReceiver${name ?? ''}';
