import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/features/community/repository/community_repository.dart';
import 'package:redit_clone_flutter/models/community_model.dart';
import 'package:redit_clone_flutter/r.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/utils.dart';

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
  })  : _communityRepository = communityRepository,
        _ref = ref,
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
}

final communityControlerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  return CommunityController(
      communityRepository: ref.watch(communitiesRepositoryProvider), ref: ref);
});

final userCommunityProvider = StreamProvider((ref) {
  var communityController = ref.watch(communityControlerProvider.notifier);

  return communityController.getUserCommunity() ;
});
