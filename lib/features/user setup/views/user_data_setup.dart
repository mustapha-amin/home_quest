import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/utils/image_picker_util.dart';
import 'package:home_quest/shared/spacing.dart';
import 'package:sizer/sizer.dart';

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
  Widget build(BuildContext context) {
    return Column(
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
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        spaceY(15),
        TextField(
          controller: phonNumberCtrl,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    ).padX(15);
  }
}
