import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mediscanner/Utils/my_prefs.dart';
import 'package:mediscanner/Utils/my_strings.dart';
import 'package:mediscanner/pages/choose_lang.dart';
import 'package:mediscanner/pages/image_selection.dart';
import 'package:mediscanner/pages/ob_pages.dart';
import 'package:mediscanner/pages/settings_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

FlutterTts tts = FlutterTts(); // ------->For TTS

class MyMethods {
  static String?
      tempImagePath; //---------> For Temp Image After Editing On Preview_page
  static String newText =
      ""; //---------> For Temp Text After Editing On Preview_page
  static Map<int, String?> addedMeds =
      {}; //----------> for Storing User Added medicine Names of Preview Page

  // *************************************This Is Splash Screen Method(start)*********************************************
  static splashScreen(bool? isObDone, bool? color){
    if (color == false) {
      MyPrefs.logoColor(true);
    } else if (color == true) {
      MyPrefs.logoColor(false);
    }
    return AnimatedSplashScreen(
        duration: 500,
        splashIconSize: 200,
        splash: Image.asset(
          "assets/images/launch_image.png",
          color: MyPrefs.getColor() == false ? Vx.orange500 : Vx.blue500,
        ),
        centered: true,
        nextScreen: isObDone! ? const ImageSelection() : const ChooseLang(),
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.rightToLeft,
        curve: Curves.easeInOut,
        backgroundColor: MyPrefs.getTheme() == false ? Vx.white : Vx.gray900);
  }
  // *************************************This Is Splash Screen Method(end)*********************************************

  //**************************************This Is TTS Methods(start)******************************************************
  static listenText(String textToSpeech, String lang) async {
    // print(await tts.getLanguages);
    // print(await tts.getVoices);
    // print(await tts.getEngines);
    /*
    for hindi:
    hi-in-x-hia-network
    hi-in-x-cfn-network

    for English:
    en-us-x-tpc-network
    en-us-x-iob-network
    en-us-x-iog-network
    en-us-x-tpf-network

    for British Accent:
    en-gb-x-gbc-network
    en-gb-x-gbc-network
    en-gb-x-gbg-network
    */
    String hindiN = "hi-in-x-hia-network";
    String hindiL = "hi-IN";
    Map<String, String> vc = {"name": MyPrefs.getObLang() == "en"? "en-gb-x-gbc-network" : hindiN, "locale": MyPrefs.getObLang() == "en"? "en-GB" : hindiL};
    await tts.setVoice(vc);
    //----> For English Language Voice(Female)
    ////-----> Setting Pitch Of Voice

    await tts.speak(textToSpeech); //-----> Speaking The Given String(param ---> textToSpeech)
  }

  static stopTts() async {
    //-----> Method For Stopping TTS
    await tts.stop();
  }
  //**************************************This Is TTS Methods(end)******************************************************

  //*************************************This Is Onboarding(Tutorial) Page Methods(start)*******************************************

  //--------------------main Onbording(Tutorial) method---------------------------
  static onboarding(BuildContext context, int obPageno, var img) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Vx.gray900,
        body: Container(
          width: context.screenWidth / 1.05,
          height: context.screenHeight / 1.08,
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(4, 4),
                  color: Vx.black,
                  blurRadius: 5.0,
                ),
                BoxShadow(
                  offset: Offset(-4, -4),
                  color: Vx.gray700,
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                )
              ]),
          child: Stack(children: [
            //------> skip Button Method Called.........
            MyMethods.obSkipButton(context, obPageno),

            SizedBox(
              height: context.screenWidth / 10,
            ),

            //------> onBording(tutorial) image Method Called.........
             Container(margin: const EdgeInsets.only(bottom: 200), child: img)
                .w(context.screenWidth / 1.5)
                .h(context.screenHeight / 1.5)
                .objectCenter(),
            //------> Bottom Arc Method Called.........
            obbottomArc(context, obPageno)
          ]),
        ).centered(),
      ),
    );
  }

  //--------------------------skip button Method--------------------------
  static obSkipButton(BuildContext context, int obPageno) {
    return obPageno != 3
        ? Container(
            margin: EdgeInsets.only(
                top: context.screenWidth / 30, right: context.screenWidth / 30),
            height: context.screenHeight / 40,
            child: FittedBox(
              child: Text(
                MyPrefs.getObLang() == "en" ? "Skip" : "छोड़ें",
                style: GoogleFonts.lato(color: Vx.white),
              ).onInkTap(() async {
                await MyPrefs.isObDone(true);
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.scale,
                        alignment: Alignment.center,
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 100),
                        child: const ImageSelection()));
              }),
            ),
          ).objectTopRight()
        : const SizedBox();
  }

  //----------------------Next page nevigator button------------------------
  static obNextbutton(BuildContext context, int obPageno) {
    return Container(
            width: context.screenWidth / 3,
            height: 70,
            decoration: BoxDecoration(
                color: const Color(0XFFF1F2F6),
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(4, 4),
                    color: Vx.gray400,
                    blurRadius: 5.0,
                  ),
                  BoxShadow(
                    offset: Offset(-4, -4),
                    color: Vx.white,
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  )
                ]),
            child: obPageno != 3
                ? const Icon(
                    CupertinoIcons.arrow_right,
                    color: Vx.gray900,
                  ).onInkTap(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            alignment: Alignment.center,
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 300),
                            child: obPageno == 1
                                ? const Onboarding2()
                                : const Onboarding3()));
                  }).centered()
                : Center(
                        child: creatText(
                            context.screenWidth / 20,
                            Vx.gray900,
                            MyPrefs.getObLang() == "en"
                                ? "Get Started"
                                : "शुरू करें",
                            context,
                            true))
                    .onInkTap(() async {
                    await MyPrefs.isObDone(true);
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.center,
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 300),
                            child: const ImageSelection()));
                  }))
        .onInkTap(() {
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft,
              alignment: Alignment.center,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300),
              child: obPageno == 1
                  ? const Onboarding2()
                  : (obPageno == 2
                      ? const Onboarding3()
                      : const ImageSelection())));
    }).centered();
  }

//--------------------The Bottom Arc of ob(tutorial page)-----------------------
  static obbottomArc(BuildContext context, int obPageNo) {
    return VxArc(
      height: 30,
      edge: VxEdge.TOP,
      child: Container(
        width: context.screenWidth,
        height: context.screenHeight / 3.3,
        decoration: BoxDecoration(
            color: const Color(0XFFF1F2F6),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                offset: Offset(4, 4),
                color: Vx.gray400,
                blurRadius: 5.0,
              ),
              BoxShadow(
                offset: Offset(-4, -4),
                color: Vx.white,
                blurRadius: 5.0,
                spreadRadius: 1.0,
              )
            ]),
        child: Column(children: [
          const Spacer(
              // flex: 3,
              ),
          //Create Text Method Called(For Header Text)...........
          AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: context.screenWidth / 8,
            child: FittedBox(
              child: Text(
                (MyPrefs.getObLang() == "en"
                    ? obPageNo == 1
                        ? MyStrings.textob1
                        : obPageNo == 2
                            ? MyStrings.textob2
                            : MyStrings.textob3
                    : obPageNo == 1
                        ? MyStrings.textob1hi
                        : obPageNo == 2
                            ? MyStrings.textob2hi
                            : MyStrings.textob3hi),
                style: GoogleFonts.lato(
                  color: Vx.gray900,
                  fontSize: context.screenWidth / 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(
              // flex: 1,
              ),
          //Create Text Method Called(For Tailing Text)...........
          Text(
            (MyPrefs.getObLang() == "en"
                ? obPageNo == 1
                    ? MyStrings.blob1
                    : obPageNo == 2
                        ? MyStrings.blob2
                        : MyStrings.blob3
                : obPageNo == 1
                    ? MyStrings.blob1hi
                    : obPageNo == 2
                        ? MyStrings.blob2hi
                        : MyStrings.blob3hi),
            style: GoogleFonts.lato(
              color: Vx.gray900,
              fontSize: context.screenWidth / 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          const Spacer(
              // flex: 3,
              ),
          MyMethods.obNextbutton(context, obPageNo),
          const Spacer(
              // flex: 3,
              ),
        ]),
      ).objectBottomCenter().objectCover(),
    ).objectFill().objectBottomCenter();
  }

  //------------------------Create Text Method---------------------------------
  static creatText(double fsize, Color? mycolor, String text,
      BuildContext context, bool isBold) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      height: context.screenWidth / 12,
      child: FittedBox(
        child: Text(
          text,
          maxLines: 2,
          textAlign: TextAlign.center,
          softWrap: true,
          style: GoogleFonts.oswald(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: mycolor,
            decoration: TextDecoration.none,
            fontSize: fsize,
          ),
        ),
      ),
    ).centered();
  }

  //------------------------Onboarding(tutorial) page Image Method--------------
  static obImage(String path, wid, hig) {
    return Container(
        margin: const EdgeInsets.only(bottom: 200),
        child: Image.network(path).w(wid).h(hig).objectCenter());
  }

//*******************************This Is Onboarding(Tutorial) Page Methods(end)****************************************

//*******************************This Is Choose Language Page Methods(start)*******************************************

  //-------------This Is Upper Arc Part Of Choose Language page-----------------
  static chooseLangUpArc(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.screenHeight / 20),
      height: context.screenHeight / 8,
      width: context.screenWidth / 1.9,
      decoration: BoxDecoration(
        color: MyPrefs.getTheme() == false
            ? const Color(0XFFF1F2F6)
            : Colors.grey[900],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          const Spacer(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: context.screenWidth / 12,
            child: FittedBox(
              child: Text(
                "Choose Language",
                maxLines: 1,
                style: GoogleFonts.oswald(
                  color:
                      MyPrefs.getTheme() == false ? Vx.gray900 : Vx.white,
                  fontWeight: FontWeight.normal,
                  fontSize: context.screenWidth / 15,
                ),
              ).objectTopCenter(),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: context.screenWidth / 12,
            child: FittedBox(
              child: Text(
                "भाषा चुनें",
                maxLines: 1,
                style: GoogleFonts.oswald(
                  color:
                      MyPrefs.getTheme() == false ? Vx.gray900 : Vx.white,
                  fontWeight: FontWeight.normal,
                  fontSize: context.screenWidth / 15,
                ),
              ).objectBottomCenter(),
            ),
          ),
          const Spacer(),
        ],
      ),
    )
        .objectTopCenter()
        .innerShadow(
          offset: const Offset(4, 4),
          color: MyPrefs.getTheme() == false ? Vx.gray400 : Vx.black,
          blur: 5.0,
        )
        .innerShadow(
            offset: const Offset(-4, -4),
            color: MyPrefs.getTheme() == false ? Vx.white : Vx.gray700,
            blur: 5.0);
  }

  // boxShadow: [
  //   BoxShadow(
  //     offset: Offset(4, 4),
  //     color: MyPrefs.getTheme() == false ? Vx.gray400 : Vx.black,
  //     blurRadius: 5.0,
  //   ),
  //   BoxShadow(
  //     offset: Offset(-4, -4),
  //     color: MyPrefs.getTheme() == false ? Vx.white : Vx.gray700,
  //     blurRadius: 5.0,
  //     spreadRadius: 0.0,
  //   )
  // ]
  //-------------This Is Language Show Container Part Of Choose Language page-----------------
//*******************************This Is Choose Language Page Methods(end)*******************************************

//************************************This Image Selection Methods(start)*******************************************
  //------------------------Image Selection Page Arc's--------------------------

  //------------------------Image Selection Page Setting Icon--------------------------
  static imgSelectionSettingicon(BuildContext context) {
    return Icon(
      Icons.settings,
      color: MyPrefs.getTheme() == false ? Vx.gray900 : Vx.white,
      size: context.screenWidth / 15,
    )
        .p(10)
        .objectTopRight()
        .onInkTap(() {
          Navigator.pushReplacement(
              context,
              PageTransition(
                child: const Settings(),
                curve: Curves.easeInOut,
                type: PageTransitionType.scale,
                duration: const Duration(milliseconds: 150),
                reverseDuration: const Duration(milliseconds: 150),
                alignment: Alignment.center,
              ));
        })
        .objectCover()
        .objectTopRight();
  }

  static imageEdit(imagePath) async {
    CroppedFile? newImage;
    MyMethods.tempImagePath = imagePath;
    ImageCropper imageCropper = ImageCropper();
    if (imagePath != "") {
      newImage = await imageCropper.cropImage(
          sourcePath: imagePath,
          uiSettings: [
            AndroidUiSettings(
          lockAspectRatio: false,
          statusBarColor: MyPrefs.getTheme() == false
              ? const Color(0XFFF1F2F6)
              : Colors.grey[900],
          toolbarWidgetColor: MyPrefs.getTheme() == false
              ? Colors.grey[900]
              : const Color(0XFFF1F2F6),
          toolbarColor: MyPrefs.getTheme() == false
              ? const Color(0XFFF1F2F6)
              : Colors.grey[900],
          toolbarTitle: MyPrefs.getObLang() == "hi"
              ? "फ़ोटो संपादित करें"
              : "Edit Photo"),
    ]
      );
      return newImage;
    } else {
      return;
    }
  }
//**********************************************This Image Selection Methods(end)********************************************

//**********************************************This Setting Page Methods(start)********************************************

  //---------------------------------This Is Setting Buttons-----------------------------------

  static settingPageButtons(BuildContext context, String bottonType) {
    return Container(
      width: context.screenWidth / 1.3,
      height: context.screenHeight / 12,
      decoration: BoxDecoration(
          color: MyPrefs.getTheme() == false
              ? const Color(0XFFF1F2F6)
              : Colors.grey[900],
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(4, 4),
              color: MyPrefs.getTheme() == false ? Vx.gray400 : Vx.black,
              blurRadius: 5.0,
            ),
            BoxShadow(
              offset: const Offset(-4, -4),
              color: MyPrefs.getTheme() == false ? Vx.white : Vx.gray700,
              blurRadius: 5.0,
              spreadRadius: 0.0,
            )
          ]),
      child: Align(
        alignment: AlignmentDirectional.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          height: context.screenWidth / 12,
          child: FittedBox(
              child: Text(
            MyPrefs.getObLang() == "en"
                ? (bottonType == "ls"
                    ? (MyStrings.stText1)
                    : (bottonType == "rb"
                        ? MyStrings.stText2
                        : MyStrings.stText3))
                : (bottonType == "ls"
                    ? (MyStrings.stText1hi)
                    : (bottonType == "rb"
                        ? MyStrings.stText2hi
                        : MyStrings.stText3hi)),
            style: GoogleFonts.oswald(
              fontSize: context.screenWidth / 18,
              fontWeight: FontWeight.normal,
              color: MyPrefs.getTheme() == false ? Vx.gray900 : Vx.white,
            ),
          )),
        ),
      ),
    ).onInkTap(() async {
      if (bottonType == "ls") {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            PageTransition(
              child: const ChooseLang(),
              type: PageTransitionType.scale,
              alignment: Alignment.center,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 100),
              reverseDuration: const Duration(milliseconds: 100),
            ));
      } else if (bottonType == "rb") {
        const url =
            'mailto:help.mediscanner@gmail.com?subject=Title%20:%20Bug%20Report&body=Discription:%20\n%20%20';
        launchUrl(Uri.parse(url));
      } else if (bottonType == "sf") {
        await Share.share("🤞 Try New Generation App For Getting 🤞\n🏥 All The Details 💊 Of Your Daily Use Medicine\nJust By Clicking 📷 An Image Of Medicine💊\n\nClick Here To Download Now 👇👇👇👇 \n\nhttps://play.google.com/store/apps/details?id=com.devappment.mediscanner\n 🤵 @Team Mediscanner");
      }
    });
  }

//---------------------------------This Is Setting Top Heading-----------------------------------

  static settingPageTopHeading(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.screenWidth / 30),
      width: context.screenWidth / 2.5,
      height: context.screenHeight / 20,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        MyPrefs.getObLang() == "en" ? "Settings" : "सेटिंग्स",
        style: GoogleFonts.lato(
          fontSize: context.screenWidth / 14,
          fontWeight: FontWeight.normal,
          color: MyPrefs.getTheme() == false ? Vx.gray900 : Vx.white,
        ),
      ).objectCenter(),
    );
  }

//**********************************************This Setting Page Methods(end)********************************************

  //**********************************************This is Result Page Methods(start)********************************************

  static infoCards(BuildContext context, List<dynamic> medData, int index,
      String title, String contentTitle) {
    var temp = medData[index][contentTitle].toString().removeAllWhiteSpace();
    return temp != "null" && temp != "" && temp != "\n"
        ? Container(
            width: context.screenWidth / 1.1,
            decoration: BoxDecoration(
                color: MyPrefs.getTheme() == false
                    ? const Color(0XFFF1F2F6)
                    : Colors.grey[900],
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(4, 4),
                    color: MyPrefs.getTheme() == false ? Vx.gray400 : Vx.black,
                    blurRadius: 5.0,
                  ),
                  BoxShadow(
                    offset: const Offset(-4, -4),
                    color: MyPrefs.getTheme() == false ? Vx.white : Vx.gray700,
                    blurRadius: 5.0,
                    spreadRadius: 0.0,
                  )
                ]),
            margin: EdgeInsets.only(top: context.screenWidth / 40),
            child: Stack(
              children: [
                Container(
                  width: context.screenWidth / 3,
                  decoration: BoxDecoration(
                      color: MyPrefs.getTheme() == false
                          ? const Color(0XFFF1F2F6)
                          : Colors.grey[900],
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(4, 4),
                          color: MyPrefs.getTheme() == false
                              ? Vx.gray400
                              : Vx.black,
                          blurRadius: 5.0,
                        ),
                        BoxShadow(
                          offset: const Offset(-4, -4),
                          color: MyPrefs.getTheme() == false
                              ? Vx.white
                              : Vx.gray700,
                          blurRadius: 5.0,
                          spreadRadius: 0.0,
                        )
                      ]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 50),
                    height: context.screenWidth / 16,
                    child: FittedBox(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.lato(
                          color: (index % 2 == 0) ? Vx.orange500 : Vx.blue400,
                          fontWeight: FontWeight.bold,
                        ),
                      ).p(context.screenWidth / 80).centered(),
                    ),
                  ),
                ).p(context.screenWidth / 40).centered(),
                Text(
                  "\n\n\n" + medData[index][contentTitle] + "\n\n",
                  style: GoogleFonts.lato(
                      fontSize: context.screenWidth / 25,
                      color: MyPrefs.getTheme() == false
                          ? Vx.gray900
                          : Vx.white),
                ).p(context.screenWidth / 25),
              ],
            )).px(context.screenWidth / 30).py(context.screenWidth / 100)
        : const SizedBox();
  }
}
