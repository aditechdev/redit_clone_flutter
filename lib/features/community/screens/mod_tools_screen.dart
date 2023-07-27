import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String? name;
  const ModToolsScreen({super.key, this.name});

  void navigateToEditCommunityScreen(BuildContext context) {
    Routemaster.of(context).push("/edit-community/$name");
  }

  void navigateToAddModsCommunityScreen(BuildContext context) {
    Routemaster.of(context).push("/add-mods/$name");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mod tools"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text("Add moderator"),
            onTap: () => navigateToAddModsCommunityScreen(context),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit community"),
            onTap: () => navigateToEditCommunityScreen(context),
          )
        ],
      ),
    );
  }
}
