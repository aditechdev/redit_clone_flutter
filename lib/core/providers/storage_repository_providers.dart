import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:redit_clone_flutter/core/failures.dart';
import 'package:redit_clone_flutter/core/providers/firebase_providers.dart';
import 'package:redit_clone_flutter/core/type_def.dart';

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile(
      {required String path, required String id, required File? file}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);

      UploadTask uploadTask = ref.putFile(file!);

      final snapshot = await uploadTask;

      // var downloadUrl = await snapshot.ref.getDownloadURL();
      // log("downloadUrl $downloadUrl");

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failures(e.toString()));
    }
  }
}

final storageRepositoryProvider = Provider(
    (ref) => StorageRepository(firebaseStorage: ref.watch(storageProvider)));
