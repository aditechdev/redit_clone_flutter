import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/features/community/controller/community_controller.dart';
import 'package:redit_clone_flutter/models/community_model.dart';
import 'package:redit_clone_flutter/widget/loader.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String? name;
  const CommunityScreen({super.key, this.name});

  void navigateToModToolsScreen(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(
      WidgetRef ref, BuildContext context, CommunityModel community) {
    ref
        .read(communityControlerProvider.notifier)
        .joinCommmunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
        // appBar: AppBar(),
        body: ref.watch(getCommunityByNameProvider(name!)).when(
              data: (community) {
                return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          // pinned: true,
                          floating: true,
                          snap: true,
                          expandedHeight: 150,
                          flexibleSpace: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  community.banner,
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverList(
                              delegate: SliverChildListDelegate([
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(community.avatar),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "r/${community.name}",
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                community.mods.contains(user!.uid ?? "")
                                    ? OutlinedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25)),
                                        onPressed: () =>
                                            navigateToModToolsScreen(context),
                                        child: const Text("Mod Tools"))
                                    : OutlinedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25)),
                                        onPressed: () => joinCommunity(
                                            ref, context, community),
                                        child: Text(
                                            community.members.contains(user.uid ?? "") ? "Joined" : "Join"))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child:
                                  Text("${community.members.length} members"),
                            )
                          ])),
                        )
                      ];
                    },
                    body: Container());

                // const Column(
                //   children: [
                //     Text("data"),
                //   ],
                // );
              },
              error: (e, s) => ErrorWidget(e),
              loading: () => const LoaderWidget(),
            ));
  }
}
