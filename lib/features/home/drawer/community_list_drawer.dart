import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/community/controller/community_controller.dart';
import 'package:redit_clone_flutter/widget/loader.dart';
import 'package:routemaster/routemaster.dart';

class CommunityList extends ConsumerWidget {
  const CommunityList({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
            title: const Text("Community"),
            leading: const Icon(Icons.add),
            onTap: () => navigateToCreateCommunity(context),
          ),
          ref.watch(userCommunityProvider).when(
                data: (communities) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (context, index) {
                        var community = communities[index];
                        return ListTile(
                          title: Text('r/${community.name}'),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          onTap: () {},
                        );
                      },
                    ),
                  );
                },
                error: (e, s) {
                  return ErrorWidget(e.toString());
                },
                loading: () => const LoaderWidget(),
              )
        ],
      )),
    );
  }
}
