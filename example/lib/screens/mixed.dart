import 'package:flutter/material.dart';
import 'package:screen_privacy_example/screen_privacy_handler.dart';
import 'package:screen_privacy_example/screen_view.dart';

// Both screenshot and screen privacy are disabled
class MixedScreen extends StatefulWidget {
  const MixedScreen({super.key});

  @override
  State<MixedScreen> createState() => _MixedScreenState();
}

class _MixedScreenState extends State<MixedScreen>
    with ScreenPrivacyMixin<MixedScreen> {
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
    return const ScreenView();
  }
}
