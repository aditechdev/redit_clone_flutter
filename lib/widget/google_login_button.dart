import 'package:flutter/material.dart';
import 'package:redit_clone_flutter/r.dart';
import 'package:redit_clone_flutter/theme/pallete.dart';

class GoogleLoginButtonWidget extends StatelessWidget {
  const GoogleLoginButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Image.asset(
        AssetImages.googleImage,
        width: 40,
      ),
      label: const Text(
        "Continue with Google",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.greyColor,
        minimumSize: const Size(
          double.infinity,
          50,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
