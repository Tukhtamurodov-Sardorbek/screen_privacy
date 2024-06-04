import 'dart:async';

import 'package:flutter/material.dart';
import 'package:screen_privacy/screen_privacy.dart';
import 'package:screen_privacy_example/screen_view.dart';

// Only in iOS detect screenshot event
class IOSScreenshotDetectorScreen extends StatefulWidget {
  const IOSScreenshotDetectorScreen({super.key});

  @override
  State<IOSScreenshotDetectorScreen> createState() =>
      _IOSScreenshotDetectorScreenState();
}

class _IOSScreenshotDetectorScreenState
    extends State<IOSScreenshotDetectorScreen> {
  late StreamSubscription? listener;

  @override
  void initState() {
    super.initState();
    listener = ScreenPrivacy().tryToCaptureScreen().listen((event) {
      print('LOOK: $event');
      if (event) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Warning"),
              content: Text(
                  "For security reasons, we do not allow you to take a screenshot or record your screen"),
            );
          },
        );
        Future.delayed(const Duration(milliseconds: 600), () {
          Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ScreenView();
  }

  @override
  void dispose() {
    listener?.cancel();
    super.dispose();
  }
}
