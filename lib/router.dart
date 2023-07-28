import 'package:flutter/material.dart';
import 'package:redit_clone_flutter/features/auth/screens/login_screen.dart';
import 'package:redit_clone_flutter/features/community/screens/add_mods_screen.dart';
import 'package:redit_clone_flutter/features/community/screens/community_screen.dart';
import 'package:redit_clone_flutter/features/community/screens/create_community_screen.dart';
import 'package:redit_clone_flutter/features/community/screens/edit_community_screen.dart';
import 'package:redit_clone_flutter/features/community/screens/mod_tools_screen.dart';
import 'package:redit_clone_flutter/features/home/screens/home_screens.dart';
import 'package:redit_clone_flutter/features/posts/screen/add_post_type_screen.dart';
import 'package:redit_clone_flutter/features/userProfile/screens/edit_user_profile_screen.dart';
import 'package:redit_clone_flutter/features/userProfile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

// logOutRoutes
final loggedOutRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

// logInRoutes
final loggedInRoutes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community': (_) =>
        const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(
            name: route.pathParameters["name"],
          ),
        ),
    '/mod-tools/:name': (router) => MaterialPage(
          child: ModToolsScreen(
            name: router.pathParameters["name"],
          ),
        ),
    '/edit-community/:name': (router) => MaterialPage(
          child: EditCommunityScreen(
            name: router.pathParameters["name"],
          ),
        ),
    '/add-mods/:name': (router) => MaterialPage(
          child: AddModsScreen(
            name: router.pathParameters["name"],
          ),
        ),
    '/u/:uid': (router) => MaterialPage(
          child: UserProfileScreen(
            uid: router.pathParameters["uid"]!,
          ),
        ),
    '/edit-profile/:uid': (router) => MaterialPage(
          child: EditUserProfile(
            uid: router.pathParameters["uid"]!,
          ),
        ),
    '/add-post/:type': (router) => MaterialPage(
          child: AddPostTypeScreen(
            type: router.pathParameters["type"]!,
          ),
        ),
  },
);
