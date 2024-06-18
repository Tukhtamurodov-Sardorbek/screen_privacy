import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screen_privacy_method_channel.dart';

abstract class ScreenPrivacyPlatform extends PlatformInterface {
  /// Constructs a ScreenPrivacyPlatform.
  ScreenPrivacyPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenPrivacyPlatform _instance = MethodChannelScreenPrivacy();

  /// The default instance of [ScreenPrivacyPlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenPrivacy].
  static ScreenPrivacyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenPrivacyPlatform] when
  /// they register themselves.
  static set instance(ScreenPrivacyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> disableScreenshot();

  Future<bool> enableScreenshot();

  Future<bool> enablePrivacyScreen();

  Future<bool> disablePrivacyScreen();

  Future<bool> isScreenshotDisabled();

  /// Only for iOS devices
  Stream<bool> tryToCaptureScreen();
}
