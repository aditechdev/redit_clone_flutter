import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/features/userProfile/controller/user_profile_controller.dart';
import 'package:redit_clone_flutter/widget/error_text.dart';
import 'package:redit_clone_flutter/widget/loader.dart';
import 'package:redit_clone_flutter/widget/post_card.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  void navigateToUserEditProfile(BuildContext context) {
    Routemaster.of(context).push("/edit-profile/$uid");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        // appBar: AppBar(),
        body: ref.watch(getUserDataProvider(uid)).when(
              data: (user) {
                return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        // pinned: true,
                        floating: true,
                        snap: true,
                        expandedHeight: 250,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                user.banner!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding:
                                  const EdgeInsets.all(20).copyWith(bottom: 70),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage:
                                    NetworkImage(user.profilePic ?? ""),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: const EdgeInsets.all(20),
                              child: OutlinedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25)),
                                  onPressed: () =>
                                      navigateToUserEditProfile(context),
                                  child: const Text("Edit Profile")),
                            )
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "u/${user.name}",
                                    style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text("${user.karma} karma"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                thickness: 2,
                              )
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                  body: ref.watch(getUserPostProvider(uid)).when(
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
                      ),
                );
              },
              error: (e, s) => ErrorTextWidget(error: e.toString()),
              loading: () => const LoaderWidget(),
            ));
  }
}
