import 'package:flutter/material.dart';
import 'package:redit_clone_flutter/r.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          AssetImages.logo,
          height: 40,
        ),
      ),
      body: const Column(
        children: [Text("data")],
      ),
    );
  }
}
