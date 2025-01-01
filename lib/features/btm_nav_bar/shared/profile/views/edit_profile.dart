import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_quest/core/extensions/navigations.dart';
import 'package:home_quest/core/extensions/widget_exts.dart';
import 'package:home_quest/core/providers.dart';
import 'package:home_quest/core/utils/errordialog.dart';
import 'package:home_quest/core/utils/image_picker_util.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/features/user%20setup/controller/user_data_controller.dart';
import 'package:home_quest/models/agent.dart';
import 'package:home_quest/models/client.dart';
import 'package:home_quest/models/user.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/colors.dart';
import '../../../../../shared/spacing.dart';
import '../../../../../shared/user_avatar.dart';

InputDecoration _textDecoration({
  String? hintText,
}) {
  return InputDecoration(
    labelText: hintText,
    contentPadding: EdgeInsets.all(18),
    border: const OutlineInputBorder(),
    labelStyle: kTextStyle(16),
  );
}

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  File? pickedImage;


  bool nameChanged() {
    return nameCtrl.text.trim() != ref.watch(userDataStreamProvider).value!.name;
  }

  bool phoneChanged() {
    return int.parse(phoneCtrl.text.trim()) !=
        ref.watch(userDataStreamProvider).value!.phoneNumber;
  }

  @override
  void initState() {
    super.initState();
    User? user = ref.read(userDataStreamProvider).value;
    nameCtrl.text = user!.name;
    phoneCtrl.text = user.phoneNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit profile",
          style: kTextStyle(20),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              if (nameChanged() || phoneChanged() || pickedImage != null) {
                try {
                  User? user = ref.read(userDataStreamProvider).value;
                  if (user is ClientModel) {
                    user = user.copyWith(
                        name: nameCtrl.text.trim(),
                        phoneNumber: int.parse(phoneCtrl.text.trim()));
                    if (pickedImage != null) {
                      await ref
                          .read(userRemoteDataProvider.notifier)
                          .saveUserData(context, user, pickedImage);
                    } else {
                      await ref
                          .read(userRemoteDataProvider.notifier)
                          .updateField(
                              context,
                              'clients',
                              ref.watch(firebaseAuthProvider).currentUser!.uid,
                              user.toJson());
                      context.pop();
                    }
                  } else {
                    user = (user as AgentModel).copyWith(
                        name: nameCtrl.text.trim(),
                        phoneNumber: int.parse(phoneCtrl.text.trim()));
                    if (pickedImage != null) {
                      await ref
                          .read(userRemoteDataProvider.notifier)
                          .saveUserData(context, user, pickedImage);
                    } else {
                      await ref
                          .read(userRemoteDataProvider.notifier)
                          .updateField(
                              context,
                              'agents',
                              ref.watch(firebaseAuthProvider).currentUser!.uid,
                              user.toJson());
                      context.pop();
                    }
                  }
                } catch (e) {
                  showErrorDialog(context, e.toString());
                }
              } else {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 800),
                    content: Text(
                      "Nothing to change",
                      style: kTextStyle(15, color: Colors.white),
                    ),
                  ),
                );
              }
            },
            child: Text(
              "Save",
              style: kTextStyle(18, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              spaceY(10),
              Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () async {
                    final res = await pickImage();
                    res.fold(
                      (l) => log(l),
                      (r) {
                        setState(() {
                          if (r != null) {
                            pickedImage = r;
                          }
                        });
                      },
                    );
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Hero(
                        tag: 'avatar',
                        child: pickedImage != null
                            ? Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(pickedImage!),
                                  ),
                                ),
                              )
                            : UserAvatar(
                                url: ref
                                    .watch(userDataStreamProvider)
                                    .value!.profilePicture,
                                height: 40.w,
                                width: 40.w,
                              ),
                      ),
                      const Icon(
                        Icons.camera_alt,
                        size: 45,
                      )
                    ],
                  ),
                ),
              ),
              spaceY(20),
              TextField(
                style: kTextStyle(16),
                controller: nameCtrl,
                decoration: _textDecoration(
                  hintText: "Name",
                ),
              ),
              spaceY(10),
              TextField(
                controller: phoneCtrl,
                style: kTextStyle(16),
                decoration: _textDecoration(
                  hintText: "Phone Number",
                ).copyWith(
                  prefixIcon:
                      Text("  +234 ", style: kTextStyle(16)).padY(18).padX(5),
                  counterText: "",
                  prefixIconConstraints: const BoxConstraints(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
            ],
          ).padY(15).padX(18),
          if (ref.watch(userRemoteDataProvider) == true)
            const SpinKitWaveSpinner(color: AppColors.brown, size: 80)
        ],
      ),
    );
  }
}
