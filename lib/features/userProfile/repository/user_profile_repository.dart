import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redit_clone_flutter/core/failures.dart';
import 'package:redit_clone_flutter/core/firebase_constants.dart';
import 'package:redit_clone_flutter/core/providers/firebase_providers.dart';
import 'package:redit_clone_flutter/models/post_model.dart';
import 'package:redit_clone_flutter/models/user_model.dart';

import '../../../core/type_def.dart';

class UserProfileRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserProfileRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  FutureVoid editUserProfile(UserModel userModel) async {
    try {
      return right(_users.doc(userModel.uid).update(userModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failures(e.toString()));
    }
  }

    Stream<List<PostModel>> getUserPost(String uid) {
    return _post
        .where("uid", isEqualTo: uid)
        .orderBy("dateTime", descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => PostModel.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.userCollection);

   CollectionReference get _post =>
      _firebaseFirestore.collection(FirebaseConstants.postsCollection);
}

final userProfileRepositoryProvider = Provider(
  (ref) => UserProfileRepository(
    firebaseFirestore: ref.watch(
      firestoreProvider,
    ),
  ),
);
