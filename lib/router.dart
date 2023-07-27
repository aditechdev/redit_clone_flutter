import 'package:flutter/material.dart';
import 'package:redit_clone_flutter/features/auth/screens/login_screen.dart';
import 'package:redit_clone_flutter/features/community/screens/community_screen.dart';
import 'package:redit_clone_flutter/features/community/screens/create_community_screen.dart';
import 'package:redit_clone_flutter/features/community/screens/edit_community_screen.dart';
import 'package:redit_clone_flutter/features/community/screens/mod_tools_screen.dart';
import 'package:redit_clone_flutter/features/home/screens/home_screens.dart';
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
    
  },
);