import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/features/auth/repository/auth_repository.dart';
import 'package:redit_clone_flutter/features/home/drawer/community_list_drawer.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            splashRadius: 25,
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: const Icon(Icons.search)),
          IconButton(
              splashRadius: 25,
              onPressed: () {
                // FirebaseAuth.instance
                ref.read(authRepositoryProvider).logout();
                Routemaster.of(context).pop();
              },
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user!.profilePic!),
              ))
        ],
      ),
      body: Center(
        child: Text(user.name ?? "xxxxxxx"),
      ),
      drawer: const CommunityList(),
    );
  }
}
