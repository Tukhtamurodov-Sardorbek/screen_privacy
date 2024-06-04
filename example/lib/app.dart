import 'package:flutter/material.dart';
import 'package:screen_privacy_example/screens/ios_screenshot_detector_page.dart';
import 'package:screen_privacy_example/screens/mixed.dart';
import 'package:screen_privacy_example/screens/privacy_screen_disabled_page.dart';
import 'package:screen_privacy_example/screens/screenshot_disabled_page.dart';

part 'button_view.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/mixedScreen': (_) => const MixedScreen(),
        '/screenshotDisabledScreen': (_) => const ScreenshotDisabledScreen(),
        '/privacyScreenDisabledScreen': (_) =>
            const PrivacyScreenDisabledScreen(),
        '/iOSScreenshotDetectorScreen': (_) =>
            const IOSScreenshotDetectorScreen(),
      },
      home: const _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: CustomScrollView(
        slivers: List.generate(
            4,
            (index) => _ButtonView(
                  onPressed: () {
                    if (index == 0) {
                      Navigator.pushNamed(context, '/screenshotDisabledScreen');
                    } else if (index == 1) {
                      Navigator.pushNamed(
                          context, '/privacyScreenDisabledScreen');
                    } else if (index == 2) {
                      Navigator.pushNamed(context, '/mixedScreen');
                    } else {
                      Navigator.pushNamed(
                          context, '/iOSScreenshotDetectorScreen');
                    }
                  },
                  title:
                      'Open ${index == 0 ? 'Screenshot disabled' : index == 1 ? 'Screen Privacy disabled' : index == 2 ? 'Both Screenshot and Screen Privacy disabled' : 'Detect Screenshot in iOS'} Page',
                )),
      ),
    );
  }
}
