import 'package:flutter/material.dart';
import 'package:redit_clone_flutter/features/posts/screen/add_post_screen.dart';

import 'features/feedScreen/screen/feed_screen.dart';

class AssetImages {
  static const String googleImage = "assets/images/google.png";
  static const String loginEmote = "assets/images/loginEmote.png";
  static const String logo = "assets/images/logo.png";
}

class AssetsAwards {
  static const String awesomeAnswer = "assets/awards/awesomeanswer.png";
  static const String gold = "assets/awards/gold.png";
  static const String helpful = "assets/awards/helpful.png";
  static const String platinum = "assets/awards/platinum.png";
  static const String plusone = "assets/awards/plusone.png";
  static const String rocket = "assets/awards/rocket.png";
  static const String thankyou = "assets/awards/thankyou.png";
  static const String til = "assets/awards/til.png";
}

class AssetsNetwork {
  static const bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';
}

class BottomListScreen {
  static const screen = [FeedScreen(), AddPostScreen()];
}

class Other {

  static const IconData up =
      IconData(0xe800, fontFamily: 'MyFlutterApp', fontPackage: null);
  static const IconData down =
      IconData(0xe801, fontFamily: 'MyFlutterApp', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': AssetsAwards.awesomeAnswer,
    'gold': AssetsAwards.gold,
    'platinum': AssetsAwards.platinum,
    'helpful': AssetsAwards.helpful,
    'plusone': AssetsAwards.plusone,
    'rocket': AssetsAwards.rocket,
    'thankyou': AssetsAwards.thankyou,
    'til': AssetsAwards.til,
  };
}
