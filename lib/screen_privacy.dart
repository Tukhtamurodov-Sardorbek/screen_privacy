import 'screen_privacy_platform_interface.dart';

class ScreenPrivacy {
  Future<bool> disableScreenshot() {
    return ScreenPrivacyPlatform.instance.disableScreenshot();
  }

  Future<bool> enableScreenshot() {
    return ScreenPrivacyPlatform.instance.enableScreenshot();
  }

  Future<bool> isScreenshotDisabled() {
    return ScreenPrivacyPlatform.instance.isScreenshotDisabled();
  }

  Stream<bool> tryToCaptureScreen() {
    return ScreenPrivacyPlatform.instance.tryToCaptureScreen();
  }

  Future<bool> enablePrivacyScreen() {
    return ScreenPrivacyPlatform.instance.enablePrivacyScreen();
  }

  Future<bool> disablePrivacyScreen() {
    return ScreenPrivacyPlatform.instance.disablePrivacyScreen();
  }
}
