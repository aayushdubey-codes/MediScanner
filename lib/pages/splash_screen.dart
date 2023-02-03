import 'package:flutter/material.dart';
import 'package:mediscanner/Utils/methods.dart';
import 'package:mediscanner/Utils/my_prefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    bool? isObDone = MyPrefs.getObBool();
    bool? logoColor = MyPrefs.getColor();
    return MyMethods.splashScreen(isObDone, logoColor);
  }
}
