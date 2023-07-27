import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/core/providers/storage_repository_providers.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/features/community/repository/community_repository.dart';
import 'package:redit_clone_flutter/models/community_model.dart';
import 'package:redit_clone_flutter/r.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/utils.dart';

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void creatCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? "";
    CommunityModel community = CommunityModel(
      id: name,
      name: name,
      banner: AssetsNetwork.bannerDefault,
      avatar: AssetsNetwork.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => () {
              showSnackBar(context, "${community.name} created successfully");
              Routemaster.of(context).pop();
            });
  }

  Stream<List<CommunityModel>> getUserCommunity() {
    final uid = _ref.read(userProvider)?.uid ?? "";

    return _communityRepository.getCommunities(uid);
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity(
      {required File? profileFile,
      required File? bannerFile,
      required BuildContext context,
      required CommunityModel communityModel}) async {
    if (profileFile != null) {
      state = true;
      final res = await _storageRepository.storeFile(
          path: 'communities/profile',
          id: communityModel.name,
          file: profileFile);

      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => communityModel = communityModel.copyWith(avatar: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/banner',
          id: communityModel.name,
          file: bannerFile);

      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => communityModel = communityModel.copyWith(banner: r),
      );
    }
    final res = await _communityRepository.editCommunity(communityModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, "${communityModel.name} Updated Successfully");
        Routemaster.of(context).pop();
      },
    );
  }
}

final communityControlerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
    communityRepository: ref.watch(communitiesRepositoryProvider),
    ref: ref,
    storageRepository: ref.watch(storageRepositoryProvider),
  );
});

final userCommunityProvider = StreamProvider((ref) {
  var communityController = ref.watch(communityControlerProvider.notifier);

  return communityController.getUserCommunity();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  var communityController = ref.watch(communityControlerProvider.notifier);

  return communityController.getCommunityByName(name);
});
