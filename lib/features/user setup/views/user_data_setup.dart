import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/core/enums.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/image_picker_util.dart';
import 'package:home_quest/features/user%20setup/views/user_type.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:sizer/sizer.dart';

import '../../../core/utils/textstyle.dart';
import '../../../shared/custom_button.dart';
import '../controller/user_data_controller.dart';

final pickedImageProvider = StateProvider<File?>((ref) {
  return null;
});

class UserDataSetup extends ConsumerStatefulWidget {
  const UserDataSetup({super.key});

  @override
  ConsumerState<UserDataSetup> createState() => _UserDataSetupState();
}

class _UserDataSetupState extends ConsumerState<UserDataSetup> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController phonNumberCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    phonNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.brown.withOpacity(0.2),
                    image: ref.watch(pickedImageProvider) == null
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                                ref.watch(pickedImageProvider.notifier).state!),
                          ),
                  ),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () async {
                      (await pickImage()).fold(
                        (l) => log(l),
                        (r) => ref.read(pickedImageProvider.notifier).state = r,
                      );
                    },
                    child: switch (ref.watch(pickedImageProvider) != null) {
                      true => null,
                      _ => const Icon(
                          Icons.person,
                          size: 80,
                          color: AppColors.brown,
                        )
                    },
                  ),
                ),
                const Positioned(
                  bottom: 13,
                  right: 13,
                  child: Icon(
                    Icons.camera_enhance,
                    size: 45,
                  ),
                ),
              ],
            ),
            spaceY(30),
            TextField(
              controller: nameCtrl,
              style: kTextStyle(17),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: "E.g John Doe",
                hintStyle: kTextStyle(17, color: Colors.grey),
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              ),
            ),
            spaceY(15),
            TextField(
              maxLength: 10,
              controller: phonNumberCtrl,
              style: kTextStyle(17),
              decoration: InputDecoration(
                counterText: "",
                border: const OutlineInputBorder(),
                hintText: "XXXXXXXXXX",
                hintStyle: kTextStyle(17, color: Colors.grey),
                prefixIcon:
                    Text("  +234 ", style: kTextStyle(17)).padY(18).padX(5),
                prefixIconConstraints: const BoxConstraints(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ).padX(15),
        ListenableBuilder(
          listenable: Listenable.merge([
            nameCtrl,
            phonNumberCtrl,
          ]),
          builder: (context, _) {
            bool fieldsAreFilled = nameCtrl.text.isNotEmpty &&
                (phonNumberCtrl.text.length == 10) &&
                ref.watch(pickedImageProvider) != null;
            return CustomButton(
              label: "Done",
              width: 90.w,
              color: fieldsAreFilled ? AppColors.brown : Colors.grey,
              onTap: () async {
                if (fieldsAreFilled) {
                  if (ref.watch(userTypeCtrl) == UserType.agent) {
                    ref.read(userDataNotifierProvider.notifier).updateUserData(
                          AgentModel.defaultInstance().copyWith(
                            name: nameCtrl.text.trim(),
                            phoneNumber: int.tryParse(phonNumberCtrl.text),
                          ),
                        );
                    await ref
                        .read(userRemoteDataProvider.notifier)
                        .saveUserData(
                          context,
                          ref.watch(userDataNotifierProvider),
                          ref.watch(pickedImageProvider)!,
                        );
                  } else {
                    ref.read(userDataNotifierProvider.notifier).updateUserData(
                          ClientModel.defaultInstance().copyWith(
                            name: nameCtrl.text.trim(),
                            phoneNumber: int.tryParse(phonNumberCtrl.text),
                          ),
                        );
                    await ref
                        .read(userRemoteDataProvider.notifier)
                        .saveUserData(
                          context,
                          ref.watch(userDataNotifierProvider),
                          ref.watch(pickedImageProvider)!,
                        );
                  }
                }
              },
            ).padX(10).padY(8);
          },
        )
      ],
    );
  }
}
