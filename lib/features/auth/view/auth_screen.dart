import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:home_quest/shared/custom_button.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/utils/image_path_gen.dart';
import 'package:home_quest/core/utils/regex.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/textstyle.dart';

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
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool passwordIsObscure = true;

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
            child: Column(
              children: [
                Image.asset(
                  genImagePath("home_logo", ImageType.png),
                  width: 20.w,
                ),
                Text(
                  "Wecome to HomeQuest",
                  style: kTextStyle(20, isBold: true),
                ),
                spaceY(12),
                Text(
                  "Enter you credentials to sign${isSignUp ? "up" : "in"}",
                  style: kTextStyle(15),
                ),
                spaceY(30),
                TextFormField(
                  controller: emailContrl,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "email",
                    hintStyle: kTextStyle(16, color: Colors.grey),
                  ),
                  autovalidateMode: _autovalidateMode,
                  validator: (email) {
                    if (email!.isEmpty || email == null) {
                      return "Email can' be be empty";
                    }
                    if (!isValidEmail(email)) {
                      return "Not a valid email";
                    }
                    return null;
                  },
                ),
                spaceY(20),
                TextFormField(
                  controller: passwordContrl,
                  obscureText: passwordIsObscure,
                  autovalidateMode: _autovalidateMode,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          passwordIsObscure = !passwordIsObscure;
                        });
                      },
                      icon: Icon(
                        passwordIsObscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    hintText: "password",
                    hintStyle: kTextStyle(16, color: Colors.grey),
                  ),
                  validator: (password) {
                    if (password!.isEmpty || password == null) {
                      return "Password can' be be empty";
                    }
                    if (!isValidpassword(password)) {
                      return "Password must be at least 8 characters, including a number and an uppercase letter";
                    }
                    return null;
                  },
                ),
                spaceY(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Forgot password?",
                        style: kTextStyle(16, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                spaceY(40),
                CustomButton(
                  label: isSignUp ? "Sign up" : "Log In",
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      print("Ok");
                    } else {
                      setState(() {
                        _autovalidateMode = AutovalidateMode.onUserInteraction;
                      });
                    }
                  },
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
                    style: kTextStyle(16),
                    children: [
                      TextSpan(
                        text: isSignUp ? "Log in" : "Sign up",
                        style: kTextStyle(16, color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            toggleAuthStatus();
                          },
                      )
                    ],
                  ),
                )
              ],
            ).padX(25).padY(120),
          );
        },
      ),
    );
  }
}
