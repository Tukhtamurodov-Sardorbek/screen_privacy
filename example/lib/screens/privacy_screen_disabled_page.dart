import 'package:flutter/material.dart';
import 'package:screen_privacy_example/screen_privacy_handler.dart';
import 'package:screen_privacy_example/screen_view.dart';

// Only privacy screen disabled
class PrivacyScreenDisabledScreen extends StatefulWidget {
  const PrivacyScreenDisabledScreen({super.key});

  @override
  State<PrivacyScreenDisabledScreen> createState() =>
      _PrivacyScreenDisabledScreenState();
}

class _PrivacyScreenDisabledScreenState
    extends State<PrivacyScreenDisabledScreen>
    with ScreenPrivacyMixin<PrivacyScreenDisabledScreen> {
  @override
  bool blockScreenshot() {
    return false;
  }

  @override
  bool enablePrivacyScreen() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return const ScreenView();
  }
}
