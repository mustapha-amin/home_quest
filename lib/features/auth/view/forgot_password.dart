import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/core/extensions/navigations.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/auth/view/auth_screen.dart';
import 'package:home_quest/shared/custom_button.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/providers.dart';
import '../controller/auth_controller.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  ValueNotifier<bool> passwordResetLinkSent = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Forgot password",
          style: kTextStyle(20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedKey01,
            color: Colors.black,
            size: 80,
          ),
          spaceY(30),
          ListenableBuilder(
            listenable:
                Listenable.merge([emailController, passwordResetLinkSent]),
            builder: (context, _) {
              if (passwordResetLinkSent.value) {
                return Column(
                  children: [
                    Text(
                      "A password reset link has been sent to ${emailController.text}",
                      style: kTextStyle(18),
                      textAlign: TextAlign.center,
                    ),
                    spaceY(30),
                    TextButton.icon(
                      onPressed: () {
                        toggleAuthStatus(ref, false);
                        context.pop();
                      },
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.key,
                            size: 15,
                            color: Colors.blue,
                          ),
                          spaceX(8),
                          Text(
                            "Back to Sign in screen",
                            style: kTextStyle(
                              16,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "E.g example@gmail.com",
                        hintStyle: kTextStyle(16, color: Colors.grey),
                        alignLabelWithHint: true,
                        labelText: "email",
                        labelStyle: kTextStyle(16, color: Colors.grey),
                      ),
                    ),
                    spaceY(30),
                    CustomButton(
                      color: emailController.text.isEmpty
                          ? Colors.grey
                          : AppColors.brown,
                      label: "Recover password",
                      onTap: emailController.text.isEmpty
                          ? null
                          : () async {
                              ref.read(isLoading.notifier).state = true;
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .requestPwdReset(
                                    context: context,
                                    email: emailController.text.trim(),
                                    operation: () {
                                      passwordResetLinkSent.value = true;
                                    },
                                  );
                              ref.invalidate(isLoading);
                            },
                    ),
                  ],
                );
              }
            },
          )
        ],
      ).padAll(20),
    );
  }
}
