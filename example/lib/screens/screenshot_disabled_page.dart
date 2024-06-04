import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen_privacy_example/screen_privacy_handler.dart';
import 'package:screen_privacy_example/screen_view.dart';

// Only screenshot disabled
class ScreenshotDisabledScreen extends StatefulWidget {
  const ScreenshotDisabledScreen({super.key});

  @override
  State<ScreenshotDisabledScreen> createState() =>
      _ScreenshotDisabledScreenState();
}

class _ScreenshotDisabledScreenState extends State<ScreenshotDisabledScreen>
    with ScreenPrivacyMixin<ScreenshotDisabledScreen> {
  @override
  bool blockScreenshot() {
    return true;
  }

  @override
  bool enablePrivacyScreen() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return const ScreenView();
  }
}
