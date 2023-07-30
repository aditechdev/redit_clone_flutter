import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/features/community/controller/community_controller.dart';
import 'package:redit_clone_flutter/features/posts/controller/post_controller.dart';
import 'package:redit_clone_flutter/models/post_model.dart';
import 'package:redit_clone_flutter/theme/pallete.dart';
import 'package:redit_clone_flutter/widget/error_text.dart';
import 'package:redit_clone_flutter/widget/loader.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;
  const PostCard(this.post, {super.key});

  void deletePost(WidgetRef ref, PostModel post, BuildContext context) {
    ref.read(postControlerProvider.notifier).deletePost(post, context);
  }

  void upVotePost(WidgetRef ref, PostModel post) {
    ref.read(postControlerProvider.notifier).upvote(post);
  }

  void downvote(WidgetRef ref, PostModel post) {
    ref.read(postControlerProvider.notifier).downvote(post);
  }

  void navigateToCommunity(String communityName, BuildContext context) {
    Routemaster.of(context).push("/r/$communityName");
  }

  void navigateToUserProfile(String uid, BuildContext context) {
    Routemaster.of(context).push("/u/$uid");

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == "image";
    final isTypeText = post.type == "text";
    final isTypeLink = post.type == "link";
    final user = ref.watch(userProvider);

    final currentTheme = ref.watch(themeModeProvider);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16)
                          .copyWith(right: 0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap:()=> navigateToCommunity(post.communityName, context),
                            child: CircleAvatar(
                              
                              radius: 16,
                              backgroundImage:
                                  NetworkImage(post.communityProfilePic),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => navigateToCommunity(
                                      post.communityName, context),
                                  child: Text(
                                    "r/${post.communityName}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => navigateToUserProfile(
                                        post.uid, context),
                                  child: Text("u/${post.userName}"))
                              ],
                            ),
                          ),
                          const Spacer(),
                          if (post.uid == user!.uid!)
                            IconButton(
                              onPressed: () => deletePost(ref, post, context),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SelectableText(
                      post.title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (isTypeImage)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          post.link ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (isTypeText)
                      Text(
                        post.description ?? "",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    if (isTypeLink)
                      Container(
                        height: 150,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        width: double.infinity,
                        child: AnyLinkPreview(
                          link: post.link!,
                          displayDirection: UIDirection.uiDirectionHorizontal,
                        ),
                      ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => upVotePost(ref, post),
                          icon: Icon(
                            Icons.arrow_circle_up,
                            // Other.up,
                            size: 30,
                            color: post.upvotes.contains(user.uid)
                                ? Colors.red
                                : null,
                          ),
                        ),
                        Text(
                          "${post.upvotes.length - post.downVotes.length == 0 ? 'vote' : post.upvotes.length - post.downVotes.length}",
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        IconButton(
                          onPressed: () => downvote(ref, post),
                          icon: Icon(
                            Icons.arrow_circle_down,
                            size: 30,
                            color: post.downVotes.contains(user.uid)
                                ? Colors.blue
                                : null,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.comment),
                            ),
                            Text(
                              post.commentCount == 0
                                  ? 'Comment'
                                  : "${post.commentCount}",
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            // IconButton(
                            //   onPressed: () {},
                            //   icon: Icon(
                            //     Other.down,
                            //     size: 30,
                            //     color: post.downVotes.contains(user.uid)
                            //         ? Colors.blue
                            //         : null,
                            //   ),
                            // ),
                          ],
                        ),
                        const Spacer(),
                        ref
                            .watch(
                                getCommunityByNameProvider(post.communityName))
                            .when(
                              data: (data) {
                                bool isModerator = data.mods.contains(post.uid);

                                return isModerator
                                    ? IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.admin_panel_settings,
                                          size: 30,
                                          color:
                                              post.downVotes.contains(user.uid)
                                                  ? Colors.blue
                                                  : null,
                                        ),
                                      )
                                    : const SizedBox();
                              },
                              error: (e, s) {
                                return ErrorTextWidget(
                                  error: e.toString(),
                                );
                              },
                              loading: () => const LoaderWidget(),
                            )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
