import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:color_log/color_log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redit_clone_flutter/core/failures.dart';
import 'package:redit_clone_flutter/core/firebase_constants.dart';
import 'package:redit_clone_flutter/core/providers/firebase_providers.dart';
import 'package:redit_clone_flutter/core/type_def.dart';
import 'package:redit_clone_flutter/models/user_model.dart';
import 'package:redit_clone_flutter/r.dart';

class AuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.userCollection);

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      var googleAuth = await googleSignInAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      clog.info(userCredential.user?.email ?? "");
      late UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          awards: [],
          banner: AssetsNetwork.avatarDefault,
          isAuthenticated: true,
          karma: 0,
          name: userCredential.user?.displayName ?? "No Name",
          profilePic:
              userCredential.user?.photoURL ?? AssetsNetwork.avatarDefault,
          uid: userCredential.user?.uid,
        );
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      clog.error(e.toString());
      left(Failures(e.toString()));
      throw "Something went wrong";
    }
  }

  Future<void> logout() async {
    _googleSignIn.signOut();
    // _firebaseFirestore.terminate();

    // _firebaseFirestore.clearPersistence();

    await _firebaseAuth.signOut();
  }

  Stream<UserModel> getUserData(String uid) => _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(
          event.data() as Map<String, dynamic>,
        ),
      );

  Stream<User?> get getAuthStateChange => _firebaseAuth.authStateChanges();
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    firebaseFirestore: ref.read(firestoreProvider),
    firebaseAuth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);
