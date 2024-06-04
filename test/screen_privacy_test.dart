import 'package:flutter_test/flutter_test.dart';
import 'package:screen_privacy/screen_privacy.dart';
import 'package:screen_privacy/screen_privacy_platform_interface.dart';
import 'package:screen_privacy/screen_privacy_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenPrivacyPlatform
    with MockPlatformInterfaceMixin
    implements ScreenPrivacyPlatform {
  @override
  Future<void> disablePrivacyScreen() {
    // TODO: implement disablePrivacyScreen
    throw UnimplementedError();
  }

  @override
  Future<void> disableScreenshot() {
    // TODO: implement disableScreenshot
    throw UnimplementedError();
  }

  @override
  Future<void> enablePrivacyScreen() {
    // TODO: implement enablePrivacyScreen
    throw UnimplementedError();
  }

  @override
  Future<void> enableScreenshot() {
    // TODO: implement enableScreenshot
    throw UnimplementedError();
  }

  @override
  Future<bool> isScreenshotDisabled() {
    // TODO: implement isScreenshotDisabled
    throw UnimplementedError();
  }

  @override
  Stream<bool> tryToCaptureScreen() {
    // TODO: implement tryToCaptureScreen
    throw UnimplementedError();
  }
}

void main() {
  final ScreenPrivacyPlatform initialPlatform = ScreenPrivacyPlatform.instance;

  test('$MethodChannelScreenPrivacy is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelScreenPrivacy>());
  });

  // test('getPlatformVersion', () async {
  //   ScreenPrivacy screenPrivacyPlugin = ScreenPrivacy();
  //   MockScreenPrivacyPlatform fakePlatform = MockScreenPrivacyPlatform();
  //   ScreenPrivacyPlatform.instance = fakePlatform;
  //
  //   expect(await screenPrivacyPlugin.getPlatformVersion(), '42');
  // });
}
