import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediscanner/Utils/methods.dart';
import 'package:mediscanner/Utils/my_prefs.dart';
import 'package:mediscanner/pages/ob_pages.dart';
import 'package:page_transition/page_transition.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Utils/my_strings.dart';
import 'image_selection.dart';

class ChooseLang extends StatefulWidget {
  const ChooseLang({Key? key}) : super(key: key);

  @override
  State<ChooseLang> createState() => _ChooseLangState();
}

class _ChooseLangState extends State<ChooseLang> {
  //*******************************************Created Variables(start)***********************************************************
  //For Checking onboarding(Tutorial) Status ----> IsDone or Not
  bool? obDone;
  bool con1 = true;
  bool con2 = true;
  dynamic img1;
  //*******************************************Created Variables(end)***********************************************************

  @override
  void initState() {
    //-----> This Is Initial State
    super.initState();
    img1 = Image.asset(MyStrings.ob);
    //----->Checkig Onboarding Prefrences on device And Storing It to 'ObDone' Variable
    obDone = MyPrefs.getObBool() ?? false;
    //----->if onbording Is Not Done Than It Will Speak The Text On 'Choose Language' Screen else not
    if (obDone != true) {
      MyMethods.listenText("भाषा चुनें", "hi");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            MyPrefs.getTheme() == false ? const Color(0XFFF1F2F6) : Colors.grey[900],
        body: Container(
          width: context.screenWidth / 1.05,
          height: context.screenHeight / 1.08,
          decoration: BoxDecoration(
              color: MyPrefs.getTheme() == false
                  ? const Color(0XFFF1F2F6)
                  : Colors.grey[900],
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(4, 4),
                  color: MyPrefs.getTheme() == false ? Vx.gray400 : Vx.black,
                  blurRadius: 7.0,
                ),
                BoxShadow(
                  offset: const Offset(-4, -4),
                  color: MyPrefs.getTheme() == false ? Vx.white : Vx.gray700,
                  blurRadius: 7.0,
                  spreadRadius: 1.0,
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // --------> Getting Upper Arc Using Method
              MyMethods.chooseLangUpArc(context),
              //--------> Getting Hindi Language Container
              const Spacer(
                flex: 6,
              ),
              Container(
                //----->Outer Decoration
                // margin: EdgeInsets.only(bottom: context.screenHeight / 10),
                height: context.screenHeight / 10,
                width: context.screenWidth / 2,
                decoration: BoxDecoration(
                    color: MyPrefs.getTheme() == false
                        ? const Color(0XFFF1F2F6)
                        : Colors.grey[900],
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: con1?[
                      BoxShadow(
                        offset: const Offset(4, 4),
                        color:
                            MyPrefs.getTheme() == false ? Vx.gray400 : Vx.black,
                        blurRadius: 5.0,
                      ),
                      BoxShadow(
                        offset: const Offset(-4, -4),
                        color:
                            MyPrefs.getTheme() == false ? Vx.white : Vx.gray700,
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                      )
                    ]:[]),
                //------> Inner Text
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  height: context.screenWidth / 50,
                  child: FittedBox(
                          child: Text(
                    "हिंदी",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Vx.orange500,
                      fontWeight: FontWeight.bold,
                      fontSize: context.screenWidth / 20,
                    ),
                  ).centered())
                      .p(context.screenWidth / 15),
                ),
              ).objectCenter().onInkTap(() async {
                await MyPrefs.myLang("hi");
                // ignore: unnecessary_statements, use_build_context_synchronously
                obDone == true ? context.pop() : null;
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.scale,
                        alignment: Alignment.center,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 150),
                        child: obDone == false
                            ? Onboarding1(img1: img1)
                            : const ImageSelection()));
              }),
              const Spacer(
                flex: 1,
              ),
              //--------> Getting English Language Container
              Container(
                //----->Outer Decoration
                // margin: EdgeInsets.only(top: context.screenHeight / 6),

                height: context.screenHeight / 10,
                width: context.screenWidth / 2,
                decoration: BoxDecoration(
                    color: MyPrefs.getTheme() == false
                        ? const Color(0XFFF1F2F6)
                        : Colors.grey[900],
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(4, 4),
                        color:
                            MyPrefs.getTheme() == false ? Vx.gray400 : Vx.black,
                        blurRadius: 5.0,
                      ),
                      BoxShadow(
                        offset: const Offset(-4, -4),
                        color:
                            MyPrefs.getTheme() == false ? Vx.white : Vx.gray700,
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                      )
                    ]),
                //------> Inner Text
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 50),
                  height: context.screenWidth / 50,
                  child: FittedBox(
                          child: Text(
                    "English",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      color: Vx.blue500,
                      fontWeight: FontWeight.bold,
                      fontSize: context.screenWidth / 20,
                    ),
                  ).centered())
                      .p(context.screenWidth / 15),
                ),
              ).objectCenter().onInkTap(() async {
                await MyPrefs.myLang("en");
                // ignore: unnecessary_statements
                obDone == true ? context.pop() : null;
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.scale,
                        alignment: Alignment.center,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 150),
                        child: obDone == false
                            ?  Onboarding1(img1: img1)
                            : const ImageSelection()));
              }),
              const Spacer(
                flex: 7,
              ),
            ],
          ),
        ).centered(),
      ),
    );
  }
}
