import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: false,
        leading: IconButton(
          splashRadius: 25,
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: const Icon(Icons.search)),
          IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user!.profilePic!),
              ))
        ],
      ),
      body: Center(
        child: Text(user.name ?? "xxxxxxx"),
      ),
    );
  }
}
