import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/core/utils.dart';
import 'package:redit_clone_flutter/features/community/controller/community_controller.dart';
import 'package:redit_clone_flutter/widget/loader.dart';
import 'package:routemaster/routemaster.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  late TextEditingController _communityNameController;
  @override
  void initState() {
    _communityNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _communityNameController.dispose();
    super.dispose();
  }

  createCommunity() {
    if (_communityNameController.text.trim().isEmpty) {
      return showSnackBar(context, "Community name cannot be empty");
    }
    ref
        .read(communityControlerProvider.notifier)
        .creatCommunity(_communityNameController.text.trim(), context);
  }

  onBackIconClick() {
    Routemaster.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControlerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 25,
          onPressed: onBackIconClick,
          icon: const Icon(
            Icons.chevron_left_outlined,
          ),
        ),
        title: const Text("Create Community"),
      ),
      body: isLoading
          ? const LoaderWidget()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Community Name")),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _communityNameController,
                    decoration: const InputDecoration(
                      hintText: "r/Community_name",
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 21,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: createCommunity,
                    child: const Text(
                      "Create Community",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
