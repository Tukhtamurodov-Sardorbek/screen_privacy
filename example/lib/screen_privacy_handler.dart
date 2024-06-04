import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:screen_privacy/screen_privacy.dart';

mixin ScreenPrivacyMixin<T extends StatefulWidget> on State<T> {
  AppLifecycleListener? _listener;
  late final ScreenPrivacy _screenPrivacy;
  bool _isIOSLifecycleUnblockedScreenshot = false;

  bool blockScreenshot();

  bool enablePrivacyScreen();

  @override
  void initState() {
    super.initState();
    _screenPrivacy = ScreenPrivacy();
    _listener = Platform.isIOS && enablePrivacyScreen()
        ? AppLifecycleListener(onStateChange: _onLifecycleChanged)
        : null;

    WidgetsBinding.instance.addPostFrameCallback(_initializer);
  }

  void _initializer(Duration timeStamp) {
    if (Platform.isAndroid) {
      if (enablePrivacyScreen()) {
        _screenPrivacy.enablePrivacyScreen();
      } else if (blockScreenshot()) {
        _screenPrivacy.disableScreenshot();
      }
    } else if (Platform.isIOS) {
      if (blockScreenshot()) {
        _screenPrivacy.disableScreenshot();
      }
    }
  }

  void _onLifecycleChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _screenPrivacy.disablePrivacyScreen();
        if (_isIOSLifecycleUnblockedScreenshot) {
          _screenPrivacy.disableScreenshot();
          _isIOSLifecycleUnblockedScreenshot = false;
        }
        break;
      case AppLifecycleState.inactive:
        if (blockScreenshot()) {
          _screenPrivacy.enableScreenshot();
          _isIOSLifecycleUnblockedScreenshot = true;
        }
        _screenPrivacy.enablePrivacyScreen();

        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      if (enablePrivacyScreen()) {
        _screenPrivacy.disablePrivacyScreen();
      } else if (blockScreenshot()) {
        _screenPrivacy.enableScreenshot();
      }
    } else if (Platform.isIOS) {
      if (blockScreenshot()) {
        _screenPrivacy.enableScreenshot();
      }
    }

    _listener?.dispose();
    super.dispose();
  }
}
