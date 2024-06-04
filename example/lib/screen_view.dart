import 'package:flutter/material.dart';

class ScreenView extends StatelessWidget {
  const ScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Text(
            '''
     Within each of us lies a dormant genius, waiting to be awakened. It is not a gift bestowed upon a select few, but a potential that resides within every human being. It is the spark of curiosity that ignites our minds, the drive to explore and understand, the relentless pursuit of knowledge and progress. The journey to unleash this genius is not always easy. It requires dedication, perseverance, and a willingness to step outside our comfort zones. It demands a relentless pursuit of excellence, a thirst for knowledge, and an unwavering belief in the power of our own potential. So, let us break free from the shackles of self-doubt and embrace the journey of becoming. Let us cultivate the seeds of genius within us, and watch as they blossom into a world of innovation, creativity, and positive change.
      ''',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
