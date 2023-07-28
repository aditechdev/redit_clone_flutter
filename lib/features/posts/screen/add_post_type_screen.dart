import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/core/utils.dart';
import 'package:redit_clone_flutter/features/community/controller/community_controller.dart';
import 'package:redit_clone_flutter/models/community_model.dart';
import 'package:redit_clone_flutter/theme/pallete.dart';
import 'package:redit_clone_flutter/widget/error_text.dart';
import 'package:redit_clone_flutter/widget/loader.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;

  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _linkController;
  File? _postFile;
  List<CommunityModel> _communites = [];

  CommunityModel? _selectedCommunity;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _linkController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  selectPost() async {
    var result = await pickImage();
    if (result != null) {
      setState(() {
        _postFile = File(result.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == "image";
    final isTypeText = widget.type == "text";
    final isTypeLink = widget.type == "link";
    final currentTheme = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Post ${widget.type}"),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Share"),
          ),
        ],

        // title: Text("$type Post Screen"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 30,
            decoration: const InputDecoration(
              filled: true,
              hintText: "Enter title here",
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(18),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (isTypeImage)
            GestureDetector(
              onTap: selectPost,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [10, 4],
                strokeCap: StrokeCap.round,
                color: currentTheme.textTheme.bodyLarge!.color!,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: _postFile != null
                      ? Image.file(
                          _postFile!,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Icon(
                            Icons.camera_enhance_rounded,
                          ),
                        ),
                ),
              ),
            ),
          if (isTypeText)
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                filled: true,
                hintText: "Enter description here",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(
                  18,
                ),
              ),
              maxLines: 5,
            ),
          if (isTypeLink)
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(
                filled: true,
                hintText: "Enter link here",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(
                  18,
                ),
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Select Community",
            ),
          ),
          ref.watch(userCommunityProvider).when(
                data: (communities) {
                  _communites = communities;

                  if (communities.isEmpty) {
                    return const SizedBox();
                  }
                  return DropdownButton(
                    value: _selectedCommunity ?? communities[0],
                    items: communities
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.name,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      _selectedCommunity = v;
                      setState(() {});
                    },
                  );
                },
                error: (e, s) => ErrorTextWidget(
                  error: e.toString(),
                ),
                loading: () => const LoaderWidget(),
              )
        ],
      ),
    );
  }
}
