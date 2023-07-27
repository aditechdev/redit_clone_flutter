import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redit_clone_flutter/core/failures.dart';
import 'package:redit_clone_flutter/core/firebase_constants.dart';
import 'package:redit_clone_flutter/core/providers/firebase_providers.dart';
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

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.userCollection);
}

final userProfileRepositoryProvider = Provider(
  (ref) => UserProfileRepository(
    firebaseFirestore: ref.watch(
      firestoreProvider,
    ),
  ),
);
