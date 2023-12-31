import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerStatefulWidget {
  const ProfileDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends ConsumerState<ProfileDrawer> {
  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push("/u/$uid");
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeModeProvider.notifier).toggleTheme();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: () => navigateToUserProfile(context, user.uid!),
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
              value:
                  ref.watch(themeModeProvider.notifier).mode == ThemeMode.dark,
              onChanged: (v) => toggleTheme(ref))
        ],
      )),
    );
  }
}
