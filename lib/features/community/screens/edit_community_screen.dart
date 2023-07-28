import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/core/utils.dart';
import 'package:redit_clone_flutter/features/community/controller/community_controller.dart';
import 'package:redit_clone_flutter/models/community_model.dart';
import 'package:redit_clone_flutter/r.dart';
import 'package:redit_clone_flutter/theme/pallete.dart';
import 'package:redit_clone_flutter/widget/loader.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String? name;
  const EditCommunityScreen({super.key, this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

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

  void save(CommunityModel communityModel) {
    ref.read(communityControlerProvider.notifier).editCommunity(
        profileFile: profileFile,
        bannerFile: bannerFile,
        context: context,
        communityModel: communityModel);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(communityControlerProvider);
    var currentTheme = ref.watch(themeModeProvider);
    return ref.watch(getCommunityByNameProvider(widget.name ?? "")).when(
        data: (community) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              title: Text(
                "Edit community",
                style: TextStyle(
                  color: currentTheme.textTheme.bodyLarge!.color!,
                ),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  splashRadius: 25,
                  onPressed: () => save(community),
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
                                          : (community.banner.isEmpty ||
                                                  community.banner ==
                                                      AssetsNetwork
                                                          .bannerDefault)
                                              ? const Center(
                                                  child: Icon(Icons
                                                      .camera_enhance_rounded),
                                                )
                                              : Image.network(
                                                  community.banner,
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
                                            community.avatar,
                                          ),
                                        ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          );
        },
        error: (e, s) {
          return ErrorWidget(e.toString());
        },
        loading: () => const LoaderWidget());
  }
}
