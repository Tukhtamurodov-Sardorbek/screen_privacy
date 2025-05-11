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

This example showcases the utilization of the ScreenPrivacy plugin within an AutoRoute-based application, constructed with AutoTabsScaffold and BottomNavigationBar. It enables the selective prevention of screenshotting and concealment of app content in the recent apps preview specifically for a designated page. The functionality is limited to a single page, toggling between disabling/enabling screenshotting and hiding/revealing content in the recent apps preview. Note that once the page is navigated away from or a different tab route is accessed, this feature will cease to operate.

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
  late final ScreenPrivacy _screenPrivacy;

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
    _routeName = context.router.current.name;
    final shouldListenNavigation =
            blockScreenshot() || (Platform.isAndroid && enablePrivacyScreen());

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
    _watcher = shouldListenNavigation == false
            ? null
            : (context.watchTabsRouter
      ..addListener(
        _navigationListener = () {
          if (context.tabsRouter.topRoute.name == _routeName) {
            if (_isNavigatedToDifferentTabRoute) {
              _screenPrivacy.disableScreenshot();
              _isNavigatedToDifferentTabRoute = false;
            }
          } else {
            if (!_isNavigatedToDifferentTabRoute) {
              _screenPrivacy.enableScreenshot();
              _isNavigatedToDifferentTabRoute = true;
            }
          }
        },
      ));
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
        if (context.tabsRouter.topRoute.name == _routeName) {
          if (blockScreenshot()) {
            _screenPrivacy.enableScreenshot();
            _isIOSLifecycleUnblockedScreenshot = true;
          }
          _screenPrivacy.enablePrivacyScreen();
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
        _screenPrivacy.disablePrivacyScreen();
      } else if (blockScreenshot()) {
        _screenPrivacy.enableScreenshot();
      }
    } else if (Platform.isIOS) {
      if (blockScreenshot()) {
        _screenPrivacy.enableScreenshot();
      }
    }

    final mNavigationListener = _navigationListener;
    if (mNavigationListener != null) {
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
class SensitiveDataPage extends StatefulWidget {
  const SensitiveDataPage({super.key});

  @override
  State<SensitiveDataPage> createState() => _SensitiveDataPageState();
}

class _SensitiveDataPageState extends State<SensitiveDataPage> with ScreenPrivacyMixin<SensitiveDataPage> {
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


The following example shows how to use the ScreenPrivacy plugin in an AutoRoute-based application, utilizing AutoTabsScaffold and BottomNavigationBar, to disable screenshotting and/or conceal app content in the recent apps preview for the entire application.

```dart
import 'dart:io';
import 'package:flutter/material.dart';
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
```

```dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../screen_privacy_helper.dart';

@RoutePage()
class MyApp extends AutoRouter {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ScreenPrivacyMixin {
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
    return AutoTabsScaffold(
      homeIndex: 0,
      routes: const [],
      restorationId: 'AutoTabsScaffold',
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(items: const []);
      },
    );
  }
}
```
