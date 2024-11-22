import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_quest/features/auth/controller/auth_controller.dart';
import 'package:home_quest/features/auth/repository/auth_repository.dart';
import 'package:home_quest/features/auth/widget/google_bttn.dart';
import 'package:home_quest/shared/custom_button.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/utils/image_path_gen.dart';
import 'package:home_quest/core/utils/regex.dart';
import 'package:sizer/sizer.dart';

import '../../../core/colors.dart';
import '../../../core/utils/textstyle.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: isSignUp,
            builder: (context, isSignUp, _) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        genImagePath("home_logo", ImageType.png),
                        width: 20.w,
                      ),
                      Text(
                        "Welcome to HomeQuest",
                        style: kTextStyle(20, isBold: true),
                      ),
                      spaceY(12),
                      Text(
                        "Enter your credentials to sign${isSignUp ? "up" : " in"}",
                        style: kTextStyle(15),
                      ),
                      spaceY(30),
                      TextFormField(
                        controller: emailContrl,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "E.g example@gmail.com",
                          hintStyle: kTextStyle(16, color: Colors.grey),
                          
                        ),
                        autovalidateMode: _autovalidateMode,
                        validator: !isSignUp ? null : (email) {
                          if (email!.isEmpty || email == null) {
                            return "Email can't be be empty";
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
                          errorMaxLines: 2,
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
                      
                        validator: !isSignUp ? null : (password) {
                          if (password!.isEmpty || password == null) {
                            return "Password can't be be empty";
                          }
                          if (!isValidpassword(password)) {
                            return "Password must be at least 8 characters, including a number and an uppercase letter";
                          }
                          return null;
                        },
                      ),
                      spaceY(20),
                      if (!isSignUp)
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
                      spaceY(20),
                      CustomButton(
                        label: isSignUp ? "Sign up" : "Log In",
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            isSignUp
                                ? ref
                                    .read(authControllerProvider.notifier)
                                    .signUp(
                                        context: context,
                                        email: emailContrl.text.trim(),
                                        password: passwordContrl.text.trim())
                                : ref
                                    .read(authControllerProvider.notifier)
                                    .signIn(
                                        context: context,
                                        email: emailContrl.text.trim(),
                                        password: passwordContrl.text.trim());
                          } else {
                            setState(() {
                              _autovalidateMode =
                                  AutovalidateMode.onUserInteraction;
                            });
                          }
                        },
                      ),
                      spaceY(15),
                      const GoogleBttn(),
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
                ),
              );
            },
          ),
          if (ref.watch(authControllerProvider))
            const SpinKitWaveSpinner(
              size: 80,
              color: AppColors.brown,
            )
        ],
      ),
    );
  }
}
