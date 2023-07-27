import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/features/community/controller/community_controller.dart';
import 'package:redit_clone_flutter/widget/loader.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String? name;
  const AddModsScreen({super.key, this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> modsUid = {};
  int ctr = 0;

  void addMods(String uid) {
    modsUid.add(uid);
    setState(() {});
  }

  void removeMods(String uid) {
    modsUid.remove(uid);
    setState(() {});
  }

  void saveModerator() {
    ref
        .read(communityControlerProvider.notifier)
        .addMods(widget.name!, modsUid.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveModerator,
            icon: const Icon(
              Icons.done,
            ),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name!)).when(
            data: (community) {
              return ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (context, index) {
                  var memeber = community.members[index];

                  return ref.watch(getUserDataProvider(memeber)).when(
                        data: (user) {
                          if (community.mods.contains(memeber) && ctr == 0) {
                            modsUid.addAll(community.mods);
                          }
                          ctr++;

                          return CheckboxListTile(
                            value: modsUid.contains(memeber),
                            onChanged: (value) {
                              if (value!) {
                                addMods(memeber);
                              } else {
                                removeMods(memeber);
                              }
                            },
                            title: Text(user.name ?? ""),
                          );
                        },
                        error: (e, s) => ErrorWidget(e.toString()),
                        loading: () => const LoaderWidget(),
                      );
                },
              );
            },
            error: (e, s) => ErrorWidget(e.toString()),
            loading: () => const LoaderWidget(),
          ),
    );
  }
}
