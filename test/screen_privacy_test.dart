import 'package:flutter_test/flutter_test.dart';
import 'package:screen_privacy/screen_privacy_platform_interface.dart';
import 'package:screen_privacy/screen_privacy_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenPrivacyPlatform
    with MockPlatformInterfaceMixin
    implements ScreenPrivacyPlatform {
  @override
  Future<bool> disablePrivacyScreen() async {
    return true;
  }

  @override
  Future<bool> disableScreenshot() async {
    return true;
  }

  @override
  Future<bool> enablePrivacyScreen() async {
    return true;
  }

  @override
  Future<bool> enableScreenshot() async {
    return true;
  }

  @override
  Future<bool> isScreenshotDisabled() async {
    return true;
  }

  @override
  Stream<bool> tryToCaptureScreen() async* {
    yield true;
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
