import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/core/providers/storage_repository_providers.dart';
import 'package:redit_clone_flutter/core/utils.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/features/posts/repository/post_repository.dart';
import 'package:redit_clone_flutter/models/community_model.dart';
import 'package:redit_clone_flutter/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController(
      {required Ref ref,
      required StorageRepository storageRepository,
      required PostRepository postRepository})
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost(
      {required BuildContext context,
      required String title,
      required CommunityModel selectedCommunity,
      required String description}) async {
    state = true;

    String postId = const Uuid().v4();

    final user = _ref.read(userProvider);
    final PostModel post = PostModel(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downVotes: [],
        commentCount: 0,
        userName: user?.name ?? "",
        uid: user?.uid ?? "",
        type: 'text',
        dateTime: DateTime.now(),
        awards: [],
        description: description);

    final res = await _postRepository.createPost(post, user!.uid!);
    state = false;

    res.fold(
      (l) => showSnackBar(context, "$l"),
      (r) {
        showSnackBar(context, "Posted Successfully");
        Routemaster.of(context).pop();
      },
    );
  }

  void shareLinkPost(
      {required BuildContext context,
      required String title,
      required CommunityModel selectedCommunity,
      required String link}) async {
    state = true;

    String postId = const Uuid().v4();

    final user = _ref.read(userProvider);
    final PostModel post = PostModel(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downVotes: [],
        commentCount: 0,
        userName: user?.name ?? "",
        uid: user?.uid ?? "",
        type: 'link',
        dateTime: DateTime.now(),
        awards: [],
        link: link);

    final res = await _postRepository.createPost(post, user!.uid!);
    state = false;

    res.fold(
      (l) => showSnackBar(context, "$l"),
      (r) {
        showSnackBar(context, "Posted Successfully");
        Routemaster.of(context).pop();
      },
    );
  }

  void shareImagePost(
      {required BuildContext context,
      required String title,
      required CommunityModel selectedCommunity,
      required File? file}) async {
    state = true;

    String postId = const Uuid().v4();

    final user = _ref.read(userProvider);

    final imageRes = await _storageRepository.storeFile(
      path: '/posts/${selectedCommunity.name}',
      id: postId,
      file: file,
    );

    imageRes.fold(
      (l) => showSnackBar(context, "$l"),
      (r) async {
        final PostModel post = PostModel(
            id: postId,
            title: title,
            communityName: selectedCommunity.name,
            communityProfilePic: selectedCommunity.avatar,
            upvotes: [],
            downVotes: [],
            commentCount: 0,
            userName: user?.name ?? "",
            uid: user?.uid ?? "",
            type: 'image',
            dateTime: DateTime.now(),
            awards: [],
            link: r);

        final res = await _postRepository.createPost(post, user!.uid!);
        state = false;

        res.fold(
          (l) => showSnackBar(context, "$l"),
          (r) {
            showSnackBar(context, "Posted Successfully");
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  Stream<List<PostModel>> fetchUserPost(List<CommunityModel> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPost(communities);
    } else {
      return Stream.value([]);
    }
  }
}

final postControlerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    postRepository: ref.watch(postRepositoryProvider),
    ref: ref,
    storageRepository: ref.watch(storageRepositoryProvider),
  );
});

final userPostProvider =
    StreamProvider.family((ref, List<CommunityModel> communities) {
  final postController = ref.watch(postControlerProvider.notifier);
  return postController.fetchUserPost(communities);
});
