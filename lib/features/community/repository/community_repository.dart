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

  FutureVoid joinCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update({
        "members": FieldValue.arrayUnion([userId])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failures(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userId) async {
    try {
      return right(_communities.doc(communityName).update({
        "members": FieldValue.arrayRemove([userId])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failures(e.toString()));
    }
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map(
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

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map((event) =>
        CommunityModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editCommunity(CommunityModel communityModel) async {
    try {
      return right(
          _communities.doc(communityModel.name).update(communityModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failures(e.toString()));
    }
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(
       await _communities.doc(communityName).update(
          {"mods": uids},
        ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failures(e.toString()));
    }
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
