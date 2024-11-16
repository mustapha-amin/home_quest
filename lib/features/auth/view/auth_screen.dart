import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:home_quest/shared/custom_button.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:home_quest/utils/extensions.dart';
import 'package:home_quest/utils/image_path_gen.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/textstyle.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailContrl = TextEditingController();
  TextEditingController passwordContrl = TextEditingController();
  ValueNotifier<bool> isSignUp = ValueNotifier(true);

  void toggleAuthStatus() {
    isSignUp.value = !isSignUp.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: isSignUp,
        builder: (context, isSignUp, _) {
          return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    genImagePath("auth house", ImageType.gif),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        isSignUp ? "Sign up" : "Log In",
                        style: kTextStyle(25, isBold: true),
                      ),
                    ],
                  ).padY(5),
                  TextFormField(
                    controller: emailContrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "email",
                      hintStyle: kTextStyle(16, color: Colors.grey),
                    ),
                  ),
                  spaceY(20),
                  TextFormField(
                    controller: passwordContrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "password",
                      hintStyle: kTextStyle(16, color: Colors.grey),
                    ),
                  ),
                  spaceY(40),
                  CustomButton(
                    label: isSignUp ? "Sign up" : "Log In",
                    onTap: () {},
                  ),
                  spaceY(15),
                  SizedBox(
                    width: 100.w,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            genImagePath("google", ImageType.png),
                            width: 35,
                          ),
                          spaceX(10),
                          Text(
                            "Continue with Google",
                            style: kTextStyle(18),
                          )
                        ],
                      ),
                    ),
                  ),
                  spaceY(15),
                  Text.rich(
                    TextSpan(
                      text: isSignUp
                          ? "Already have an account? "
                          : "Don't have an account? ",
                      style: kTextStyle(18),
                      children: [
                        TextSpan(
                          text: isSignUp ? "Log in" : "Sign up",
                          style: kTextStyle(18, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              toggleAuthStatus();
                            },
                        )
                      ],
                    ),
                  )
                ],
              ).padX(25),
            ),
          );
        },
      ),
    );
  }
}
