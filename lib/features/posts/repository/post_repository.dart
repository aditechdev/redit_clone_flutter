import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redit_clone_flutter/core/failures.dart';
import 'package:redit_clone_flutter/core/firebase_constants.dart';
import 'package:redit_clone_flutter/core/providers/firebase_providers.dart';
import 'package:redit_clone_flutter/core/type_def.dart';
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


  CollectionReference get _posts =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);
}

final postRepositoryProvider = Provider(
    (ref) => PostRepository(firebaseFirestore: ref.watch(firestoreProvider)));
