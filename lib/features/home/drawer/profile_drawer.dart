import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/theme/pallete.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userProvider);

    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user?.profilePic ?? ""),
            radius: 70,
          ),
          const SizedBox(
            height: 10,
          ),
          // const Divider(),
          Text(
            'u/${user!.name!}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          ListTile(
            title: const Text("Profile"),
            leading: const Icon(Icons.person),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Logout"),
            leading: Icon(
              Icons.logout,
              color: Pallete.redColor,
            ),
            onTap: () => logOut(ref),
          ),

          CupertinoSwitch(
              value: true,
              onChanged: (v) {
                v = !v;
              })
        ],
      )),
    );
  }
}
