import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screen_privacy_platform_interface.dart';

/// An implementation of [ScreenPrivacyPlatform] that uses method channels.
class MethodChannelScreenPrivacy extends ScreenPrivacyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_privacy');

  @visibleForTesting
  final eventChannel = const EventChannel('screen_privacy/events');

  void _debugPrint(String? text) {
    if (kDebugMode) {
      print(text);
    }
  }

  @override
  Future<bool> disableScreenshot() async {
    final result = await methodChannel.invokeMethod<bool>('disableScreenshot');
    return result ?? false;
  }

  @override
  Future<bool> enableScreenshot() async {
    final result = await methodChannel.invokeMethod<bool>('enableScreenshot');
    return result ?? false;
  }

  @override
  Future<bool> isScreenshotDisabled() async {
    final result =
        await methodChannel.invokeMethod<bool>('isScreenshotDisabled');
    return result ?? false;
  }

  @override
  Stream<bool> tryToCaptureScreen() async* {
    if (Platform.isIOS) {
      Stream<bool?> scanResultsStream =
          eventChannel.receiveBroadcastStream().cast();

      final buffer = BufferStream.listen(scanResultsStream);

      await for (final item in buffer.stream) {
        _debugPrint('tryToCaptureScreen event: $item');
        yield item ?? false;
      }
    }
  }

  @override
  Future<bool> enablePrivacyScreen() async {
    final result =
        await methodChannel.invokeMethod<bool>('enablePrivacyScreen');
    return result ?? false;
  }

  @override
  Future<bool> disablePrivacyScreen() async {
    final result =
        await methodChannel.invokeMethod<bool>('disablePrivacyScreen');
    return result ?? false;
  }
}

class BufferStream<T> {
  final Stream<T> _inputStream;
  late final StreamSubscription? _subscription;
  late final StreamController<T> _controller;

  BufferStream.listen(this._inputStream) {
    _controller = StreamController<T>(
      onCancel: () {
        _subscription?.cancel();
      },
      onPause: () {
        _subscription?.pause();
      },
      onResume: () {
        _subscription?.resume();
      },
      onListen: () {}, // inputStream is already listened to
    );

    // Start listening to the inputStream immediately
    _subscription = _inputStream.listen(
      (data) {
        _controller.add(data);
      },
      onError: (e) {
        _controller.addError(e);
      },
      onDone: () {
        _controller.close();
      },
      cancelOnError: false,
    );
  }

  void close() {
    _subscription?.cancel();
    _controller.close();
  }

  Stream<T> get stream async* {
    yield* _controller.stream;
  }
}
