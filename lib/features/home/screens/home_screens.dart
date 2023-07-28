import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redit_clone_flutter/features/auth/controller/auth_controller.dart';
import 'package:redit_clone_flutter/features/home/delegates/search_community_deligate.dart';
import 'package:redit_clone_flutter/features/home/drawer/community_list_drawer.dart';
import 'package:redit_clone_flutter/features/home/drawer/profile_drawer.dart';
import 'package:redit_clone_flutter/r.dart';
import 'package:redit_clone_flutter/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var currentTheme = ref.watch(themeModeProvider);
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
              onPressed: () {
                showSearch(
                    context: context, delegate: SearchCommunityDelegate(ref));
              },
              icon: const Icon(Icons.search)),
          Builder(builder: (context) {
            return IconButton(
                splashRadius: 25,
                onPressed: () {
                  // FirebaseAuth.instance
                  displayEndDrawer(context);
                  // ref.read(authRepositoryProvider).logout();
                  // Routemaster.of(context).pop();
                },
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user!.profilePic!),
                ));
          })
        ],
      ),
      body: BottomListScreen.screen[_page],
      drawer: const CommunityList(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        onTap: onPageChange,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "",
          )
        ],
      ),
    );
  }
}

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

 

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     var user = ref.watch(userProvider);
//     var currentTheme = ref.watch(themeModeProvider);
//     return 
//   }
// }
