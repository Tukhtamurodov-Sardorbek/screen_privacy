import 'screen_privacy_platform_interface.dart';

class ScreenPrivacy {
  Future<void> disableScreenshot() {
    return ScreenPrivacyPlatform.instance.disableScreenshot();
  }

  Future<void> enableScreenshot() {
    return ScreenPrivacyPlatform.instance.enableScreenshot();
  }

  Future<bool> isScreenshotDisabled() {
    return ScreenPrivacyPlatform.instance.isScreenshotDisabled();
  }

  Stream<bool> tryToCaptureScreen() {
    return ScreenPrivacyPlatform.instance.tryToCaptureScreen();
  }

  Future<void> enablePrivacyScreen() {
    return ScreenPrivacyPlatform.instance.enablePrivacyScreen();
  }

  Future<void> disablePrivacyScreen() {
    return ScreenPrivacyPlatform.instance.disablePrivacyScreen();
  }
}
