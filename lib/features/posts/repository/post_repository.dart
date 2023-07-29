import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redit_clone_flutter/core/failures.dart';
import 'package:redit_clone_flutter/core/firebase_constants.dart';
import 'package:redit_clone_flutter/core/providers/firebase_providers.dart';
import 'package:redit_clone_flutter/core/type_def.dart';
import 'package:redit_clone_flutter/models/community_model.dart';
import 'package:redit_clone_flutter/models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  FutureVoid createPost(PostModel post, String userId) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failures(e.toString()));
    }
  }

  Stream<List<PostModel>> fetchUserPost(List<CommunityModel> communities) {
    return _posts
        .where('communityName',
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid deletePost(PostModel post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      return left(Failures(e.toString()));
    }
  }

  void upvote(PostModel post, String userId) {}

  CollectionReference get _posts =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);
}

final postRepositoryProvider = Provider(
    (ref) => PostRepository(firebaseFirestore: ref.watch(firestoreProvider)));
