import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/core/utils.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/features/userProfile/controller/user_profile_controller.dart';
import 'package:redit_clone_flutter/r.dart';
import 'package:redit_clone_flutter/theme/pallete.dart';
import 'package:redit_clone_flutter/widget/error_text.dart';
import 'package:redit_clone_flutter/widget/loader.dart';

class EditUserProfile extends ConsumerStatefulWidget {
  final String uid;
  const EditUserProfile({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditUserProfileState();
}

class _EditUserProfileState extends ConsumerState<EditUserProfile> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    var name = ref.read(userProvider)?.name ?? "";
    _nameController = TextEditingController(text: name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  selectBannerImage() async {
    var result = await pickImage();
    if (result != null) {
      setState(() {
        bannerFile = File(result.files.first.path!);
      });
    }
  }

  selectProfileImage() async {
    var result = await pickImage();
    if (result != null) {
      setState(() {
        profileFile = File(result.files.first.path!);
      });
    }
  }

  void saveProfile() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
        profileFile: profileFile,
        bannerFile: bannerFile,
        context: context,
        name: _nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(userProfileControllerProvider);
    var currentTheme = ref.watch(themeModeProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (user) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              title: Text(
                "Edit Profile",
                style: TextStyle(
                  color: currentTheme.textTheme.bodyLarge!.color!,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  splashRadius: 25,
                  onPressed: () => saveProfile(),
                  icon: const Text("Save"),
                )
              ],
            ),
            body: isLoading
                ? const LoaderWidget()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    dashPattern: const [10, 4],
                                    strokeCap: StrokeCap.round,
                                    color: currentTheme
                                        .textTheme.bodyLarge!.color!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: bannerFile != null
                                          ? Image.file(
                                              bannerFile!,
                                              fit: BoxFit.cover,
                                            )
                                          : (user.banner!.isEmpty ||
                                                  user.banner ==
                                                      AssetsNetwork
                                                          .bannerDefault)
                                              ? const Center(
                                                  child: Icon(Icons
                                                      .camera_enhance_rounded),
                                                )
                                              : Image.network(
                                                  user.banner!,
                                                  fit: BoxFit.cover,
                                                ),
                                    )),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: profileFile != null
                                      ? CircleAvatar(
                                          radius: 32,
                                          backgroundImage:
                                              FileImage(profileFile!))
                                      : CircleAvatar(
                                          radius: 32,
                                          backgroundImage: NetworkImage(
                                            user.profilePic!,
                                          ),
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              filled: true,
                              hintText: "Name",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18)),
                        ),
                      ],
                    ),
                  ),
          );
        },
        error: (e, s) {
          return ErrorTextWidget(error: e.toString());
        },
        loading: () => const LoaderWidget());
  }
}
