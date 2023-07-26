import 'package:flutter/material.dart';
import 'package:redit_clone_flutter/features/auth/screens/login_screen.dart';
import 'package:redit_clone_flutter/features/home/screens/home_screens.dart';
import 'package:routemaster/routemaster.dart';

// logOutRoutes
final loggedOutRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
  // '/feed': (_) => MaterialPage(child: FeedPage()),
  // '/settings': (_) => MaterialPage(child: SettingsPage()),
  // '/feed/profile/:id': (info) =>
  // MaterialPage(child: ProfilePage(id: info.pathParameters['id'])),
});


// logInRoutes
final loggedInRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  // '/feed': (_) => MaterialPage(child: FeedPage()),
  // '/settings': (_) => MaterialPage(child: SettingsPage()),
  // '/feed/profile/:id': (info) =>
  // MaterialPage(child: ProfilePage(id: info.pathParameters['id'])),
});
