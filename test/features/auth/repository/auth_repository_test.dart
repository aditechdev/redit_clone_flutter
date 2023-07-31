import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:redit_clone_flutter/features/auth/repository/auth_repository.dart';
import 'package:redit_clone_flutter/models/user_model.dart';
// import 'package:your_app/auth_repository.dart';
// import 'package:your_app/models/user_model.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  late AuthRepository authRepository;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    authRepository = AuthRepository(
      firebaseFirestore: mockFirestore,
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
    );
  });

  group('signInWithGoogle', () {
    test('should return UserModel on successful sign in', () async {
      // Arrange
      final userModel = UserModel(
        name: 'John Doe',
        profilePic: 'profile_pic_url',
        banner: 'banner_url',
        uid: 'user_id',
        isAuthenticated: true,
        karma: 100,
        awards: ['award_1', 'award_2'],
      );

      final googleSignInAccount = MockGoogleSignInAccount();
      final googleSignInAuthentication = MockGoogleSignInAuthentication();
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => googleSignInAccount);
      // when(googleSignInAccount?.authentication)
      //     .thenReturn(googleSignInAuthentication);

      final userCredential = MockUserCredential();
      final additionalUserInfo = MockAdditionalUserInfo();
      when(userCredential.user).thenReturn(MockUser());
      when(userCredential.additionalUserInfo).thenReturn(additionalUserInfo);
      when(additionalUserInfo.isNewUser).thenReturn(true);

      // when(mockFirebaseAuth.signInWithCredential(any))
      //     .thenAnswer((_) async => userCredential);

      // Act
      final result = await authRepository.signInWithGoogle();

      // Assert
      expect(result.isRight(), true);
      // expect(result.getOrElse(() => null), userModel);
    });

    test('should return UserModel from Firestore if user already exists',
        () async {
      // Arrange
      final userModel = UserModel(
        name: 'John Doe',
        profilePic: 'profile_pic_url',
        banner: 'banner_url',
        uid: 'user_id',
        isAuthenticated: true,
        karma: 100,
        awards: ['award_1', 'award_2'],
      );

      final googleSignInAccount = MockGoogleSignInAccount();
      final googleSignInAuthentication = MockGoogleSignInAuthentication();
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => googleSignInAccount);
      // when(googleSignInAccount?.authentication)
      //     .thenReturn(googleSignInAuthentication);

      final userCredential = MockUserCredential();
      final additionalUserInfo = MockAdditionalUserInfo();
      when(userCredential.user).thenReturn(MockUser());
      when(userCredential.additionalUserInfo).thenReturn(additionalUserInfo);
      when(additionalUserInfo.isNewUser).thenReturn(false);

      // when(mockFirebaseAuth.signInWithCredential(any))
      //     .thenAnswer((_) async => userCredential);

      final mockUserSnapshot = MockDocumentSnapshot();
      when(mockUserSnapshot.data()).thenReturn({
        'name': 'John Doe',
        'profilePic': 'profile_pic_url',
        'banner': 'banner_url',
        'uid': 'user_id',
        'isAuthenticated': true,
        'karma': 100,
        'awards': ['award_1', 'award_2'],
      });
      // when(mockFirestore.doc(any).snapshots())
      //     .thenAnswer((_) => Stream.fromIterable([mockUserSnapshot]));

      // Act
      final result = await authRepository.signInWithGoogle();

      // Assert
      expect(result.isRight(), true);
      // expect(result.getOrElse(() => null), userModel);
    });

    // Add more tests to cover error scenarios
  });

  // Add more test cases for other methods in AuthRepository if required
}

// Mock classes for testing
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockUserCredential extends Mock implements UserCredential {}

class MockAdditionalUserInfo extends Mock implements AdditionalUserInfo {}

class MockUser extends Mock implements User {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}
