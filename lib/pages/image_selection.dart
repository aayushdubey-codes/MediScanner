import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediscanner/Utils/methods.dart';
import 'package:mediscanner/Utils/my_prefs.dart';
import 'package:mediscanner/pages/find_medicine.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';


class ImageSelection extends StatefulWidget {
  const ImageSelection({Key? key}) : super(key: key);

  @override
  State<ImageSelection> createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
//*********************************Creating Variables(start)********************************************
  File oldImage =
      File(""); // ------> Variable For Selected Image(Before Editing)

  // ignore: prefer_typing_uninitialized_variables
  var newImage; // ------> Variable For Selected Image(After Editing)
  var map = {};
  List keyList = [];

  // -------> For Checking Image Is Selected Or Not
  var check = 0;
  // -------> For Checking Is User Selecting Image(true ---> Waiting For Image To Select, false ----> image Selected)
  bool inprocess = false;

//*********************************Creating Variables(end)********************************************

  myOCR() async {
    final TextRecognizer textRecognizer =
        GoogleVision.instance.textRecognizer();
    final File file = File(newImage.path);
    final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(file);
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          final Rect? boundingBox = element.boundingBox;
          final String? text = element.text;
          Size rsize = boundingBox!.size;
          var high = rsize.height;
          var widt = rsize.width;
          var full = high * widt;
          map.putIfAbsent(full, () => text.toString());
        }
      }
    }
    // print(map.keys.toString());
    textRecognizer.close();
    keyList = map.keys.toList();
    keyList.sort((b, a) => a.compareTo(b));
  }

  @override
  void initState() {
    super.initState();
    if (MyPrefs.getObBool() == false) {
      MyPrefs.getObLang() == "hi"
          ? MyMethods.listenText("माध्यम चुने", "hi")
          : MyMethods.listenText("Select Mode", "en");
    }
  }

  //------> Getting Image Function....
  Future getImage(var source) async {
    try {
      setState(() {
        map.clear();
        keyList.clear();
        inprocess = true;
      });
      final image = await ImagePicker().pickImage(
          source: source == 0 ? ImageSource.camera : ImageSource.gallery);
      if (image == null) {
        check = 1;
        return;
      } else {
        check = 0;
      }
      MyMethods.tempImagePath = image.path;
      final tempimage = File(MyMethods.tempImagePath.toString());
      setState(() {
        oldImage = tempimage;
      });
    } on PlatformException {
      VxToast.show(context, msg: "Permission Denied!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: !inprocess
            ? Scaffold(
                backgroundColor: MyPrefs.getTheme() == false
                    ? const Color(0XFFF1F2F6)
                    : Colors.grey[900],
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
                          spreadRadius: 1.0,
                        )
                      ]),
                  child: Stack(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            //---------------------------Top Stack Design------------------------
                            Stack(children: [
                              // MyMethods.imgSelectionArcs(context, false),
                              MyMethods.imgSelectionSettingicon(context),
                              // MyMethods.imgSelectionStripDesign(
                              //     100, Vx.yellow400, 0, 0, false),
                              // MyMethods.imgSelectionStripDesign(
                              //     140, Vx.red600, 0, 38, false),
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                margin: EdgeInsets.only(
                                    top: context.screenHeight / 20),
                                width: context.screenWidth / 2,
                                height: context.screenHeight / 20,
                                decoration: BoxDecoration(
                                  color: MyPrefs.getTheme() == false
                                      ? const Color(0XFFF1F2F6)
                                      : Colors.grey[900],
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: FittedBox(
                                  child: Text(
                                    MyPrefs.getObLang() == "en"
                                        ? "Select Mode"
                                        : "माध्यम चुने",
                                    style: GoogleFonts.lato(
                                      fontSize: context.screenWidth / 18,
                                      color: MyPrefs.getTheme() == false
                                          ? Colors.grey[900]
                                          : Vx.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ).objectCenter(),
                                ).p(context.screenWidth / 50),
                              )
                                  .objectTopCenter()
                                  .innerShadow(
                                    offset: const Offset(4, 4),
                                    color: MyPrefs.getTheme() == false
                                        ? Vx.gray400
                                        : Vx.black,
                                    blur: 2.0,
                                  )
                                  .innerShadow(
                                      offset: const Offset(-4, -4),
                                      color: MyPrefs.getTheme() == false
                                          ? Vx.white
                                          : Vx.gray700,
                                      blur: 2.0),
                            ]),

                            //********************************************Main Selection Card(start)************************************************
                            SizedBox(height: context.screenHeight / 8),
                            Column(
                              children: [
                                //This Is Camera Icon With inkResponse
                                Container(
                                  width: context.screenWidth / 2,
                                  height: context.screenHeight / 5,
                                  decoration: BoxDecoration(
                                      color: MyPrefs.getTheme() == false
                                          ? const Color(0XFFF1F2F6)
                                          : Colors.grey[900],
                                      borderRadius: BorderRadius.circular(32.0),
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
                                          spreadRadius: 1.0,
                                        )
                                      ]),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(
                                        CupertinoIcons.camera,
                                        color: Color(0xff2879ff),
                                        size: 80,
                                      ).objectTopCenter().onInkTap(() async {
                                        setState(() {
                                          inprocess = true;
                                        });
                                        await getImage(0);
                                        if (MyMethods.tempImagePath != null) {
                                          newImage = await MyMethods.imageEdit(
                                              MyMethods.tempImagePath);
                                        }
                                        MyMethods.tempImagePath = null;
                                        if (check == 0 && newImage != null) {
                                          await myOCR();
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  child: FindingMedicine(
                                                    myMap: map,
                                                  ),
                                                  type:
                                                      PageTransitionType.scale,
                                                  alignment: Alignment.center,
                                                  curve: Curves.easeInOut,
                                                  duration: const Duration(
                                                      milliseconds: 100)));
                                        }
                                        setState(() {
                                          inprocess = false;
                                        });
                                      }).centered(),
                                      AnimatedContainer(
                                        duration: const Duration(seconds: 1),
                                        height: context.screenWidth / 18,
                                        child: FittedBox(
                                          child: Text(
                                            MyPrefs.getObLang() == "en"
                                                ? "Camera"
                                                : "कैमरा",
                                            style: GoogleFonts.lato(
                                              fontSize:
                                                  context.screenWidth / 18,
                                              color: MyPrefs.getTheme() == false
                                                  ? Colors.grey[900]
                                                  : Vx.white,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ).objectBottomCenter(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ).onInkTap(() async {
                                  setState(() {
                                    inprocess = true;
                                  });
                                  await getImage(0);
                                  if (MyMethods.tempImagePath != null) {
                                    newImage = await MyMethods.imageEdit(
                                        MyMethods.tempImagePath);
                                  }
                                  MyMethods.tempImagePath = null;
                                  if (check == 0 && newImage != null) {
                                    await myOCR();
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: FindingMedicine(
                                              myMap: map,
                                            ),
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.center,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 100)));
                                  }
                                  setState(() {
                                    inprocess = false;
                                  });
                                }).centered(),

                                //This is Sized Box B/W Camera Text And Gallary Icon
                                const SizedBox(
                                  height: 40,
                                  width: 100,
                                ),

                                //This Is Gallary Icon with Inkresponse..
                                Container(
                                  width: context.screenWidth / 2,
                                  height: context.screenHeight / 5,
                                  decoration: BoxDecoration(
                                      color: MyPrefs.getTheme() == false
                                          ? const Color(0XFFF1F2F6)
                                          : Colors.grey[900],
                                      borderRadius: BorderRadius.circular(32.0),
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
                                          spreadRadius: 1.0,
                                        )
                                      ]),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkResponse(
                                        radius: 60,
                                        onTap: () async {
                                          setState(() {
                                            inprocess = true;
                                          });
                                          await getImage(1);
                                          if (MyMethods.tempImagePath != null) {
                                            newImage =
                                                await MyMethods.imageEdit(
                                                    MyMethods.tempImagePath);
                                          }
                                          MyMethods.tempImagePath = null;
                                          if (check == 0 && newImage != null) {
                                            await myOCR();
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    child: FindingMedicine(
                                                      myMap: map,
                                                    ),
                                                    type: PageTransitionType
                                                        .scale,
                                                    alignment: Alignment.center,
                                                    curve: Curves.easeInOut,
                                                    duration: const Duration(
                                                        milliseconds: 100)));
                                          }
                                          setState(() {
                                            inprocess = false;
                                          });
                                        },
                                        child: const Icon(
                                          CupertinoIcons.photo,
                                          color: Color(0xffff7f27),
                                          size: 80,
                                        ),
                                      ).objectCenter(),
                                      AnimatedContainer(
                                        duration: const Duration(seconds: 1),
                                        height: context.screenWidth / 18,
                                        child: FittedBox(
                                          child: Text(
                                            MyPrefs.getObLang() == "en"
                                                ? "Gallery"
                                                : "गेलरी",
                                            style: GoogleFonts.lato(
                                              fontSize:
                                                  context.screenWidth / 18,
                                              color: MyPrefs.getTheme() == false
                                                  ? Colors.grey[900]
                                                  : Vx.white,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ).objectCenter(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ).onInkTap(() async {
                                  setState(() {
                                    inprocess = true;
                                  });
                                  await getImage(1);
                                  if (MyMethods.tempImagePath != null) {
                                    newImage = await MyMethods.imageEdit(
                                        MyMethods.tempImagePath);
                                  }
                                  MyMethods.tempImagePath = null;
                                  if (check == 0 && newImage != null) {
                                    await myOCR();
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: FindingMedicine(
                                              myMap: map,
                                            ),
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.center,
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                                milliseconds: 100)));
                                  }
                                  setState(() {
                                    inprocess = false;
                                  });
                                }).centered(),
                              ],
                            ).objectContain().p(20).centered().p(12),

                            const Spacer(),
                            //********************************************Main selection Card(end)**********************************************
                          ]),

                      //------> This Is Bottom Arc Function Of Setting Page
                      Container(
                        width: context.screenWidth / 2.6,
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
                        margin:
                            EdgeInsets.only(bottom: context.screenWidth / 30),
                        child: Row(
                          children: [
                            const Spacer(),
                            Image.asset(
                              "assets/images/ps.png",
                              scale: 15,
                            ).p(5),
                            Text(
                              MyPrefs.getObLang() == "en"
                                  ? "Rate Us"
                                  : "हमें प्रोत्साहित करे",
                              style: GoogleFonts.oswald(
                                fontSize: context.screenWidth / 25,
                                color: MyPrefs.getTheme() == false
                                    ? Vx.black
                                    : Vx.white,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ).onInkTap(() {
                          launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.devappment.mediscanner"),mode: LaunchMode.externalNonBrowserApplication);
                        }),
                      ).objectBottomCenter()
                    ],
                  ),
                ).centered())
            : Scaffold(
                backgroundColor: MyPrefs.getTheme() == false
                    ? const Color(0XFFF1F2F6)
                    : Colors.grey[900],
                body: Container(
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
                                spreadRadius: 1.0,
                              )
                            ]),
                        child: Column(
                          children: [
                            const Spacer(),
                            CircularProgressIndicator(
                              strokeWidth: 2,
                              backgroundColor: Vx.orange400,
                              color: Colors.blueAccent[700],
                            ).centered().p(10),
                            MyMethods.creatText(
                                12,
                                MyPrefs.getTheme() == false
                                    ? Colors.grey[900]
                                    : Colors.white,
                                "Waiting....",
                                context,
                                false),
                            const Spacer(),
                          ],
                        ).centered().p(5))
                    .backgroundColor(Vx.gray900),
              ));
  }
}
