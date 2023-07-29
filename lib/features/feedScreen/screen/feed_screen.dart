import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/community/controller/community_controller.dart';
import 'package:redit_clone_flutter/features/posts/controller/post_controller.dart';
import 'package:redit_clone_flutter/widget/error_text.dart';
import 'package:redit_clone_flutter/widget/loader.dart';
import 'package:redit_clone_flutter/widget/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunityProvider).when(
        data: (community) {
          return ref.watch(userPostProvider(community)).when(
                data: (posts) {
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                    var post = posts[index];
                    return PostCard(
                      post = post,
                    );
                  });
                },
                error: (e, s) {
                  print(e);
                  return ErrorTextWidget(
                    error: e.toString(),
                  );
                },
                loading: () => const LoaderWidget(),
              );
        },
        error: (e, s) {
          print(e);
          return ErrorTextWidget(
            error: e.toString(),
          );
        },
        loading: () => const LoaderWidget());
    // return const Center(
    //   child: Text("Feed Screen"),
    // );
  }
}
