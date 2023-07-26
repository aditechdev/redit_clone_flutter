import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redit_clone_flutter/core/failures.dart';
import 'package:redit_clone_flutter/core/firebase_constants.dart';
import 'package:redit_clone_flutter/core/providers/firebase_providers.dart';
import 'package:redit_clone_flutter/core/type_def.dart';

import '../../../models/community_model.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid createCommunity(CommunityModel communityModel) async {
    try {
      var communityDoc = await _communities.doc(communityModel.name).get();

      if (communityDoc.exists) {
        throw "Communities with the same name already exists!";
      }

      return right(
          _communities.doc(communityModel.name).set(communityModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
      // return left(Failures(e.message!));
    } catch (e) {
      return left(Failures(e.toString()));
    }
  }

  Stream<List<CommunityModel>> getCommunities(String uid) {
    return _communities.where("members", arrayContains: uid).snapshots().map(
      (event) {
        List<CommunityModel> communities = [];
        for (var e in event.docs) {
          communities.add(
            CommunityModel.fromMap(e.data() as Map<String, dynamic>),
          );
        }
        return communities;
      },
    );
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}

final communitiesRepositoryProvider = Provider<CommunityRepository>(
  (ref) {
    return CommunityRepository(
      firestore: ref.watch(firestoreProvider),
    );
  },
);
