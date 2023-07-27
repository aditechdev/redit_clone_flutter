import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/community/controller/community_controller.dart';
import 'package:redit_clone_flutter/widget/loader.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;

  SearchCommunityDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
        data: (communities) {
          return ListView.builder(
              itemCount: communities.length,
              itemBuilder: ((context, index) {
                var community = communities[index];
                return Ink(
                  color: Colors.grey[350],
                  child: ListTile(
                    tileColor: Colors.black38,
                    focusColor: Colors.black38,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(community.avatar),
                    ),
                    title: Text("r/${community.name}"),
                    onTap: () =>
                        navigateToCommunityScreen(context, community.name),
                  ),
                );
              }));
        },
        error: (e, s) => ErrorWidget(e.toString()),
        loading: () => const LoaderWidget());
  }

  void navigateToCommunityScreen(BuildContext context, String name) {
    Routemaster.of(context).push('/r/$name');
  }
}
