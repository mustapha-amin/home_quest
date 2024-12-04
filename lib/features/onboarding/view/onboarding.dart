import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';
import 'package:home_quest/services/onboarding_settings.dart';
import 'package:home_quest/shared/custom_button.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/utils/image_path.dart';
import 'package:home_quest/core/extensions/navigations.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:sizer/sizer.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  double _opacity = 0;
  final _image = const AssetImage(ImagePaths.house);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
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
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              color: Colors.black.withOpacity(0.6),
            ),
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Connecting you to the perfect property or client, all in one place\n\n",
                    style: kTextStyle(24, color: Colors.white, isBold: true),
                    textAlign: TextAlign.center,
                  ).padX(20),
                  spaceY(20),
                  Text(
                    "Start exploring today and make real estate simple.",
                    style: kTextStyle(17, color: Colors.white),
                  ),
                  spaceY(25),
                  CustomButton(
                    color: Colors.brown,
                    label: "Get Started",
                    onTap: () {
                      try {
                        ref.read(onBoardingSettingsProvider).passOnboarding();
                        context.replace(const AuthScreen());
                      } catch (e) {
                        log("Error: ${e.toString()}");
                      }
                    },
                  ).padX(20),
                ],
              ).padY(10),
            ),
          ],
        ),
      ),
    );
  }
}
