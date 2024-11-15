import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_quest/features/onboarding/widgets/onboard_btn.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:home_quest/utils/extensions.dart';
import 'package:home_quest/utils/image_path_gen.dart';
import 'package:home_quest/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  double _opacity = 0;
  final _image = AssetImage(genJpgImagePath("house"));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() => _opacity = 1);
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(_image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(1),
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: _image,
            filterQuality: FilterQuality.low,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.black.withOpacity(0.6),
            ),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Connecting you to the perfect property or client, all in one place\n\n",
                    style: kTextStyle(24, color: Colors.white, isBold: true),
                    textAlign: TextAlign.center,
                  ).padX(20),
                  spaceY(20),
                ],
              ),
            ),
            Positioned(
              bottom: 15,
              child: Column(
                children: [
                  Text(
                    "Start exploring today and make real estate simple.",
                    style: kTextStyle(17, color: Colors.white),
                  ),
                  spaceY(25),
                  const OnboardBtn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
