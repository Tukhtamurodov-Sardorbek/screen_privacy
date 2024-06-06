# screen_privacy

This plugin provides functionalities to prevent screenshots and hide app content in the recent apps
preview for both Android and iOS platforms. This can be useful for apps displaying sensitive information or
media content.

## Usage

### Installation

Add `screen_privacy` as a dependency in your `pubspec.yaml` file.

### Import

```import 'package:screen_privacy/screen_privacy.dart';```

And then you can simply call functions of ScreenPrivacy class instance anywhere

## Fine-grained Screenshot Control:

- Disable Screenshoting:
  ```ScreenPrivacy().disableScreenshot();```
- Enable Screenshoting:
  ```ScreenPrivacy().enableScreenshot();```

## Recent App Preview Management:

- Hide App Content:
  ```ScreenPrivacy().enablePrivacyScreen();```
- Reveal App Content:
  ```ScreenPrivacy().disablePrivacyScreen();```



## Use Case with AutoRoute
This example demonstrates how to use the ScreenPrivacy plugin within an AutoRoute-based application to selectively disable screenshotting and/or hide app content in the recent apps preview for a specific page.

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:screen_privacy/screen_privacy.dart';

mixin ScreenPrivacyMixin<T extends StatefulWidget> on State<T> {
  TabsRouter? _watcher;
  AppLifecycleListener? _listener;
  VoidCallback? _navigationListener;
  bool _isNavigatedToDifferentTabRoute = false;
  bool _isIOSLifecycleUnblockedScreenshot = false;
  late final String _routeName;
  late final WindowManagerCubit _windowManager;

  bool blockScreenshot();

  bool enablePrivacyScreen();

  @override
  void initState() {
    super.initState();

    _listener = Platform.isIOS && enablePrivacyScreen()
        ? AppLifecycleListener(onStateChange: _onLifecycleChanged)
        : null;

    WidgetsBinding.instance.addPostFrameCallback(_initializer);
  }

  void _initializer(Duration timeStamp) {
    _routeName = context.router.current.name;
    _windowManager = context.read<WindowManagerCubit>();
    final shouldListenNavigation =
        blockScreenshot() || (Platform.isAndroid && enablePrivacyScreen());

    if (Platform.isAndroid) {
      if (enablePrivacyScreen()) {
        _windowManager.enablePrivacyScreen();
      } else if (blockScreenshot()) {
        _windowManager.blockScreenShot();
      }
    } else if (Platform.isIOS) {
      if (blockScreenshot()) {
        _windowManager.blockScreenShot();
      }
    }
    _watcher = shouldListenNavigation == false
        ? null
        : (context.watchTabsRouter
          ..addListener(
            _navigationListener = () {
              if (context.tabsRouter.topRoute.name == _routeName) {
                if (_isNavigatedToDifferentTabRoute) {
                  _windowManager.blockScreenShot();
                  _isNavigatedToDifferentTabRoute = false;
                }
              } else {
                if (!_isNavigatedToDifferentTabRoute) {
                  _windowManager.unblockScreenShot();
                  _isNavigatedToDifferentTabRoute = true;
                }
              }
            },
          ));
  }

  void _onLifecycleChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _windowManager.disablePrivacyScreen();
        if (_isIOSLifecycleUnblockedScreenshot) {
          _windowManager.blockScreenShot();
          _isIOSLifecycleUnblockedScreenshot = false;
        }
        break;
      case AppLifecycleState.inactive:
        if (context.tabsRouter.topRoute.name == _routeName) {
          if (blockScreenshot()) {
            _windowManager.unblockScreenShot();
            _isIOSLifecycleUnblockedScreenshot = true;
          }
          _windowManager.enablePrivacyScreen();
        }
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
        _windowManager.disablePrivacyScreen();
      } else if (blockScreenshot()) {
        _windowManager.unblockScreenShot();
      }
    } else if (Platform.isIOS) {
      if (blockScreenshot()) {
        _windowManager.unblockScreenShot();
      }
    }

    final kNavigationListener = _navigationListener;
    if (kNavigationListener != null) {
      _watcher?.removeListener(mNavigationListener);
    }
    _listener?.dispose();
    super.dispose();
  }
}
```

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../screen_privacy_helper.dart';
import '../../../../navigation/navigation.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ScreenPrivacyMixin<HomePage> {
  @override
  bool blockScreenshot() {
    return true;
  }

  @override
  bool enablePrivacyScreen() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Image(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1512850183-6d7990f42385?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
          ),
        ),
      ),
    );
  }
}
```

