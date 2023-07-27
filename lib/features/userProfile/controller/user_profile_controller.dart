import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/core/providers/storage_repository_providers.dart';
import 'package:redit_clone_flutter/core/utils.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/features/userProfile/repository/user_profile_repository.dart';
import 'package:redit_clone_flutter/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _profileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _profileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void editUserProfile(
      {required File? profileFile,
      required File? bannerFile,
      required BuildContext context,
      required String name}) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;

    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/profile', id: user.uid!, file: profileFile);

      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(profilePic: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'users/banner', id: user.uid!, file: bannerFile);

      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(banner: r),
      );
    }

    user = user.copyWith(name: name);
    final res = await _profileRepository.editUserProfile(user);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        _ref.read(userProvider.notifier).update(
              (state) => user,
            );
        showSnackBar(context, "${user.name} Updated Successfully");
        Routemaster.of(context).pop();
      },
    );
  }
}


final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    ref: ref,
    storageRepository: ref.watch(storageRepositoryProvider), userProfileRepository: ref.watch(userProfileRepositoryProvider),
  );
});

// final userCommunityProvider = StreamProvider((ref) {
//   var communityController = ref.watch(communityControlerProvider.notifier);

//   return communityController.getUserCommunity();
// });

// final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
//   var communityController = ref.watch(communityControlerProvider.notifier);

//   return communityController.getCommunityByName(name);
// });

// final searchCommunityProvider = StreamProvider.family((ref, String name) {
//   var communityController = ref.watch(communityControlerProvider.notifier);

//   return communityController.searchCommunity(name);
// });
