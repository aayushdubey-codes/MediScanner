import 'package:flutter/cupertino.dart'; // -----> For Icon Like Iphone
import 'package:flutter/material.dart';
import 'package:mediscanner/Utils/methods.dart';
import 'package:mediscanner/Utils/my_prefs.dart';
import 'package:mediscanner/Utils/my_strings.dart';

//*********************************************First OnBoarding Page(start)******************************************************
class Onboarding1 extends StatefulWidget {
  const Onboarding1({Key? key, required this.img1}) : super(key: key);
  final dynamic img1;
  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  @override
  void initState() {
    super.initState();
    MyPrefs.getObLang() == "hi"
        ? MyMethods.listenText(
            //-------> Speak in hindi
            MyStrings.textob1hi + "\n" + MyStrings.blob1hi,
            "hi")
        : MyMethods.listenText(
            //-------> Speak in English
            MyStrings.textob1 + "\n" + MyStrings.blob1,
            "en");
  }

  @override
  Widget build(BuildContext context) {
    return MyMethods.onboarding(
        context, 1, widget.img1); //------> Calling Onboarding Method
  }
}
//*********************************************First OnBoarding Page(end)******************************************************

//*********************************************Second OnBoarding Page(start)***************************************************
class Onboarding2 extends StatefulWidget {
  const Onboarding2({Key? key}) : super(key: key);

  @override
  State<Onboarding2> createState() => _Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2> {
  dynamic img2;
  @override
  void initState() {
    super.initState();
    img2 = Image.asset(MyStrings.ob1);
    MyPrefs.getObLang() == "hi"
        ? MyMethods.listenText(
            //-------> Speak in hindi
            MyStrings.textob2hi + "\n" + MyStrings.blob2hi,
            "hi")
        : MyMethods.listenText(
            //-------> Speak in English
            MyStrings.textob2 + "\n" + MyStrings.blob2,
            "en");
  }

  @override
  Widget build(BuildContext context) {
    return MyMethods.onboarding(
        context, 2, img2); //------> Calling Onboarding Method
  }
}
//*********************************************Second OnBoarding Page(end)*****************************************************

//*********************************************Third OnBoarding Page(start)******************************************************
class Onboarding3 extends StatefulWidget {
  const Onboarding3({Key? key}) : super(key: key);

  @override
  State<Onboarding3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
  dynamic img3;
  @override
  //---------------This Is initial State----------------------------------------
  void initState() {
    super.initState();
    img3 = Image.asset(MyStrings.ob2);
    MyPrefs.getObLang() == "hi"
        ? MyMethods.listenText(
            //-------> Speak in hindi
            MyStrings.textob3hi + "\n" + MyStrings.blob3hi,
            "hi")
        : MyMethods.listenText(
            //-------> Speak in English
            MyStrings.textob3 + "\n" + MyStrings.blob3,
            "en");
  }

  @override
  Widget build(BuildContext context) {
    return MyMethods.onboarding(
        context, 3, img3); //------> Calling Onboarding Method
  }
}
//*********************************************Third OnBoarding Page(end)******************************************************



