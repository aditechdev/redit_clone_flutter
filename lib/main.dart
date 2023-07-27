import 'package:color_log/color_log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/models/user_model.dart';
import 'package:redit_clone_flutter/router.dart';
import 'package:redit_clone_flutter/theme/pallete.dart';
import 'package:redit_clone_flutter/widget/error_text.dart';
import 'package:redit_clone_flutter/widget/loader.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    clog.info("Firebase setup successfully");
  } catch (e) {
    clog.error(e.toString());
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  getUserData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Redit Clone',
              theme: ref.watch(themeModeProvider),
              routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
                if (data != null) {
                  if (userModel == null) {
                    getUserData(ref, data);
                  }
                  clog.debug(userModel.toString());
                  if (userModel != null) {
                    return loggedInRoutes;
                  }
                }
                return loggedOutRoutes;
              }),
              routeInformationParser: const RoutemasterParser(),
              // home: const LoginScreen(),
            );
          },
          error: (e, s) => ErrorTextWidget(
            error: e.toString(),
          ),
          loading: () => const LoaderWidget(),
        );
  }
}
