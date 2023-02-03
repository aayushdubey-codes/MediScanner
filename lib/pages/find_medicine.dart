import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:mediscanner/Utils/methods.dart';
import 'package:mediscanner/Utils/my_prefs.dart';
import 'package:mediscanner/Utils/my_strings.dart';
import 'package:mediscanner/Utils/panel_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class FindingMedicine extends StatefulWidget {
  final Map myMap;
  const FindingMedicine({Key? key, required this.myMap}) : super(key: key);
  @override
  _FindingMedicineState createState() => _FindingMedicineState();
}

class _FindingMedicineState extends State<FindingMedicine> {
  var controller = PageController(viewportFraction: 0.98, keepPage: true);
  List<bool> listenIndiv = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  bool notFoundListenButton = false;
  bool inp = false;
  bool isSearched = false;
  String baseUrl = "https://mediscanner.herokuapp.com/api?Query=";
  List<dynamic> medData = [];
  List keyList = [];
  var itemCount = 0;
  var notFound = false;
  var blueOrange = true;
  var notConnected = false;
  var goBack = false;
  bool isLoading = false;
  bool isClickedCross = false;
  bool stopLoading = false;
  final translator = GoogleTranslator();
  final panController = PanelController();

  searchMeds(String medName) async {
    if (goBack == true || medData.length >= 15 || stopLoading) {
      return;
    }
    Uri url;
    url = Uri.parse(baseUrl + medName);
    // ignore: prefer_typing_uninitialized_variables
    var response;
    // ignore: prefer_typing_uninitialized_variables
    var html;
    try {
      response = await http.get(url);
      var body = response.body;
      html = parse(body);
    } catch (e) {
      log(e.toString());
      notConnected = true;
      VxToast.show(context,
          msg: "Internet Connection Required",
          bgColor: Colors.black,
          textSize: 20,
          position: VxToastPosition.center,
          textColor: Colors.white);
      notFound = true;
      return;
    }
    if (response.statusCode == 200) {
      final jsn = jsonDecode(html.querySelector("body")!.text.toString());

      for (var i = 0; i < jsn.length; i++) {
        if (jsn[i]['product_highlight'] == null && jsn[i]['error'] == null) {
          Map<String, dynamic> tempMap = {};
          var name = ""; //done
          var images = []; //done
          var intro = ""; //done
          var mrp1 = ""; //done
          var mrp2 = ""; //done
          var composition = ""; //done
          var uses = ""; //done
          var benifits = ""; //done
          var sideEffects = ""; //done
          var manufacturer = ""; //done
          var howItWorks = ""; //done
          var howToUse = ""; //done
          // var missedDose = ""; //done
          var saftyAdvice = "";
          var quickTips = "";
          var faqs = "";
          // try {
          name = jsn[i]['name'].toString();
          // print("The Name is ------- ------- ------ " + name);
          for (var j = 0; j < jsn[i]['image'].length; j++) {
            var temp =
                "https://onemg.gumlet.io/image/upload/a_ignore,w_400,h_400,c_fit,q_auto,f_auto" +
                    jsn[i]['image'][j].toString() +
                    ".jpg";
            images.add(temp);
          }
          intro = jsn[i]['intro'].toString();
          manufacturer = jsn[i]['manufacturer'].toString();
          composition = jsn[i]['composition'].toString();

          for (var j = 0; j < jsn[i]['mrp1'].length; j++) {
            if (jsn[i]['mrp1'][j].toString().contains(RegExp(r'[0-9]'))) {
              mrp1 += "₹" + jsn[i]['mrp1'][j].toString() + "\n\n";
            }
          }
          for (var j = 0; j < jsn[i]['mrp2'].length; j++) {
            if (jsn[i]['mrp2'][j].toString().contains(RegExp(r'[0-9]'))) {
              mrp1 += "₹" + jsn[i]['mrp2'][j].toString() + "\n\n";
            }
          }
          mrp1 = (mrp1 + "\n" + mrp2)
              .replaceAll("[", "")
              .replaceAll("]", "")
              .removeAllWhiteSpace();
          bool isBenifits = false;
          // print(
          // "Uses Len ====== ===== ===== " + jsn[i]['uses'].length.toString());
          for (var j = 0; j < jsn[i]['uses'].length; j++) {
            var temp = jsn[i]['uses'][j].toString();
            if (temp.contains("Benefits of") && isBenifits == false) {
              isBenifits = true;
            }
            if (!isBenifits) {
              uses += temp + "\n\n";
            } else {
              benifits += temp + "\n\n";
            }
          }
          benifits =
              benifits.replaceAll("Show more", "").replaceAll("Show less", "");
          for (var j = 0; j < jsn[i]['side_effects'].length; j++) {
            sideEffects += jsn[i]['side_effects'][j].toString() + "\n\n";
          }
          howItWorks = jsn[i]['how_it_works'].toString();
          howToUse = jsn[i]['how_to_use'].toString();
          // missedDose = jsn[i]['missed_dose'].toString();
          for (var j = 0; j < jsn[i]['safty_advice'].length; j++) {
            saftyAdvice += jsn[i]['safty_advice'][j].toString() + "\n\n";
          }

          // print("faqs are ........ ....... " + jsn[i]['faqs'].toString());
          for (var i in jsn[i]['quick_tips']) {
            quickTips += i.toString() + "\n\n";
          }
          quickTips = quickTips.replaceAll(" \n\n", "");
          for (var i in jsn[i]['faqs']) {
            faqs += i.toString() + "\n\n";
          }
          faqs = faqs.replaceAll("Show more", "").replaceAll("Show less", "");
          // } catch (e) {
          //   print(e);
          // }
          if (MyPrefs.getObLang() == "hi") {
            try {
              intro =
                  (await translator.translate(intro, from: "auto", to: "hi"))
                      .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              manufacturer = (await translator.translate(manufacturer,
                      from: "auto", to: "hi"))
                  .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              composition = (await translator.translate(composition,
                      from: "auto", to: "hi"))
                  .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              uses = (await translator.translate(uses, from: "auto", to: "hi"))
                  .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              benifits =
                  (await translator.translate(benifits, from: "auto", to: "hi"))
                      .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              sideEffects = (await translator.translate(sideEffects,
                      from: "auto", to: "hi"))
                  .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              howItWorks = (await translator.translate(howItWorks,
                      from: "auto", to: "hi"))
                  .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              howToUse =
                  (await translator.translate(howToUse, from: "auto", to: "hi"))
                      .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              saftyAdvice = (await translator.translate(saftyAdvice,
                      from: "auto", to: "hi"))
                  .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              quickTips = (await translator.translate(quickTips,
                      from: "auto", to: "hi"))
                  .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              faqs = (await translator.translate(faqs, from: "auto", to: "hi"))
                  .toString();
            } catch (e) {
              log(e.toString());
            }
          }
          tempMap.putIfAbsent('name', () => name);
          tempMap.putIfAbsent('images', () => images);
          tempMap.putIfAbsent('intro', () => intro);
          tempMap.putIfAbsent('mrp1', () => mrp1);
          tempMap.putIfAbsent('mrp2', () => mrp2);
          tempMap.putIfAbsent('manufacturer', () => manufacturer);
          tempMap.putIfAbsent('composition', () => composition);
          tempMap.putIfAbsent('uses', () => uses);
          tempMap.putIfAbsent('benifits', () => benifits);
          tempMap.putIfAbsent('sideEffects', () => sideEffects);
          tempMap.putIfAbsent('howItWorks', () => howItWorks);
          tempMap.putIfAbsent('howToUse', () => howToUse);
          tempMap.putIfAbsent('saftyAdvice', () => saftyAdvice);
          tempMap.putIfAbsent('quickTips', () => quickTips);
          tempMap.putIfAbsent('faqs', () => faqs);
          if (name != "null" && name != "शून्य") {
            medData.add(tempMap);
          }
          final jsonList = medData.map((item) => jsonEncode(item)).toList();
          final uniqueJsonList = jsonList.toSet().toList();
          medData = uniqueJsonList.map((item) => jsonDecode(item)).toList();
        } else if (jsn[i]['error'] == null) {
          Map<String, dynamic> tempMap = {};
          var name = ""; //done
          var images = []; //done
          var intro = ""; //done
          var mrp1 = ""; //done
          var mrp2 = ""; //done
          var composition = ""; //done
          var benifits = ""; //done
          var manufacturer = "";
          var howToUse = ""; //done
          var saftyAdvice = ""; //done
          // try {
          name = name = jsn[i]['name'].toString();
          for (var j = 0; j < jsn[i]['image'].length; j++) {
            var temp = jsn[i]['image'][j]
                .toString()
                .replaceAll("/l_watermark_346,w_120,h_120", "")
                .replaceAll("120", "400");
            images.add(temp);
          }
          manufacturer = jsn[i]['manufacturer'].toString();
          String s = "I";
          for (var j = 0; j < jsn[i]['product_information'].length; j++) {
            var temp = jsn[i]['product_information'][j].toString();
            if (temp.contains("Key Ingredients")) {
              s = "C";
            } else if (temp.contains("Key Benefits")) {
              s = "UB";
            } else if (temp.contains("Directions For Use")) {
              s = "HTU";
            } else if (temp.contains("Safety Information")) {
              s = "SI";
            }
            if (s == "I") {
              intro += temp + "\n\n";
            } else if (s == "C") {
              composition += temp + "\n\n";
            } else if (s == "UB") {
              benifits += temp + "\n\n";
            } else if (s == "HTU") {
              howToUse += temp + "\n\n";
            } else if (s == "SI") {
              saftyAdvice += temp + "\n\n";
            }
          }
          for (var j = 0; j < jsn[i]['mrp1'].length; j++) {
            if (jsn[i]['mrp1'][j].toString().contains(RegExp(r'[0-9]'))) {
              mrp1 += "₹" + jsn[i]['mrp1'][j].toString() + "\n\n";
            }
          }
          for (var j = 0; j < jsn[i]['mrp2'].length; j++) {
            if (jsn[i]['mrp2'][j].toString().contains(RegExp(r'[0-9]'))) {
              mrp1 += "₹" + jsn[i]['mrp2'][j].toString() + "\n\n";
            }
          }
          mrp1 = (mrp1 + "\n" + mrp2)
              .replaceAll("[", "")
              .replaceAll("]", "")
              .removeAllWhiteSpace();
          if (MyPrefs.getObLang() == "hi") {
            try {
              intro =
                  (await translator.translate(intro, from: "auto", to: "hi"))
                      .toString();
            } catch (e) {
              log(e.toString());
            }
            try {
              manufacturer = (await translator.translate(manufacturer,
                      from: "auto", to: "hi"))
                  .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              composition = (await translator.translate(composition,
                      from: "auto", to: "hi"))
                  .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              benifits =
                  (await translator.translate(benifits, from: "auto", to: "hi"))
                      .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              howToUse =
                  (await translator.translate(howToUse, from: "auto", to: "hi"))
                      .toString();
            } catch (e) {
              log(e.toString());
            }

            try {
              saftyAdvice = (await translator.translate(saftyAdvice,
                      from: "auto", to: "hi"))
                  .toString();
            } catch (e) {
              log(e.toString());
            }
          }
          tempMap.putIfAbsent('name', () => name);
          tempMap.putIfAbsent('images', () => images);
          tempMap.putIfAbsent('intro', () => intro);
          tempMap.putIfAbsent('mrp1', () => mrp1);
          tempMap.putIfAbsent('mrp2', () => mrp2);
          tempMap.putIfAbsent('manufacturer', () => manufacturer);
          tempMap.putIfAbsent('composition', () => composition);
          tempMap.putIfAbsent('benifits', () => benifits);
          tempMap.putIfAbsent('howToUse', () => howToUse);
          tempMap.putIfAbsent('saftyAdvice', () => saftyAdvice);
          if (name != "null" && name != "शून्य") {
            medData.add(tempMap);
          }
          final jsonList = medData.map((item) => jsonEncode(item)).toList();
          final uniqueJsonList = jsonList.toSet().toList();
          medData = uniqueJsonList.map((item) => jsonDecode(item)).toList();
        }
        if (medData.isNotEmpty) {
          if (goBack == true || stopLoading) {
            return;
          }
          setState(() {
            itemCount = medData.length;
            inp = false;
            isSearched = true;
          });
        }
      }
    } else {
      if (medData.isNotEmpty) {
        if (goBack == true || stopLoading) {
          return;
        }
        setState(() {
          itemCount = medData.length;
          inp = false;
          isSearched = true;
        });
      } else {
        setState(() {
          inp = false;
          notFound = true;
          notConnected = true;
        });
      }
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      inp = true;
    });
    looPing();
  }

  looPing() async {
    keyList = widget.myMap.keys.toList();
    keyList.sort((b, a) => a.compareTo(b));
    setState(() {
      isLoading = true;
    });
    for (int i = 0; i < keyList.length; i++) {
      if (goBack == true || medData.length >= 15) {
        break;
      }
      var title = (widget.myMap[keyList[i]]);
      await searchMeds(title);
      if (i > 5 || notConnected || stopLoading) {
        break;
      }
    }
    if (medData.isEmpty && goBack != true) {
      setState(() {
        notFound = true;
        inp = false;
      });
    }
    setState(() {
      isLoading = false;
    });
    keyList.clear();
  }

  Future<bool> goBackToPage() async {
    setState(() {
      goBack = true;
    });
    return true;
  }

  @override
  void dispose() {
    medData.clear();
    MyMethods.stopTts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double panelHeightOpen = context.screenHeight;
    double panelHeightClosed = context.screenHeight * 0.06;
    return inp
        ? WillPopScope(
            onWillPop: () => goBackToPage(),
            child: Scaffold(
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
                            backgroundColor: Vx.orange400,
                            color: Colors.blueAccent[700],
                            strokeWidth: 2,
                          ).centered().p(10),
                          MyMethods.creatText(
                              10,
                              MyPrefs.getTheme() == false
                                  ? Colors.grey[900]
                                  : Colors.white,
                              "Searching....",
                              context,
                              true),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              MyPrefs.getObLang() == "en"
                                  ? "Please Wait For Few Seconds"
                                  : "कृपया कुछ समय प्रतीक्षा करें",
                              style: TextStyle(
                                color: MyPrefs.getTheme() == false
                                    ? Colors.grey[900]
                                    : Colors.white,
                              )),
                          const Spacer(),
                        ],
                      ).centered().p(5))
                  .backgroundColor(Vx.gray900),
            ))
        : !notFound
            ? SafeArea(
                child: WillPopScope(
                  onWillPop: () => goBackToPage(),
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: Scaffold(
                      backgroundColor: MyPrefs.getTheme() == false
                          ? const Color(0XFFF1F2F6)
                          : Colors.grey[900],
                      body: SlidingUpPanel(
                        panelSnapping: true,
                        controller: panController,
                        minHeight: panelHeightClosed,
                        maxHeight: panelHeightOpen,
                        parallaxEnabled: true,
                        parallaxOffset: 0.6,
                        margin: const EdgeInsets.only(right: 3, left: 3),
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
                        ],
                        color: MyPrefs.getTheme() == false
                            ? const Color(0XFFF1F2F6)
                            : const Color.fromARGB(255, 33, 33, 33),
                        panelBuilder: (controller) => PanelWidget(
                          scrollController: controller,
                          panelController: panController,
                        ),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        body: Container(
                          width: context.screenWidth / 1.05,
                          height: context.screenHeight / 1.03,
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
                                  blurRadius: 7.0,
                                ),
                                BoxShadow(
                                  offset: const Offset(-4, -4),
                                  color: MyPrefs.getTheme() == false
                                      ? Vx.white
                                      : Vx.gray700,
                                  blurRadius: 7.0,
                                  spreadRadius: 1.0,
                                )
                              ]),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.zero,
                                width: context.screenWidth / 1.06,
                                height: context.screenWidth / 10,
                                decoration: BoxDecoration(
                                  color: MyPrefs.getTheme() == false
                                      ? const Color(0XFFF1F2F6)
                                      : Colors.grey[900],
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Row(
                                  children: [
                                    isLoading
                                        ? !isClickedCross
                                            ? Stack(
                                                children: [
                                                  //
                                                  CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    backgroundColor:
                                                        Vx.orange400,
                                                    color:
                                                        Colors.blueAccent[700],
                                                  ).px(5).objectCenterLeft(),
                                                  // const SizedBox(),
                                                  const Icon(
                                                    Icons.close_rounded,
                                                    color: Vx.red500,
                                                  ).objectCenterLeft().px(10),
                                                ],
                                              ).onTap(() {
                                                setState(() {
                                                  isClickedCross = true;
                                                  isLoading = false;
                                                  stopLoading = true;
                                                });
                                              })
                                            : const Icon(
                                                Icons.done_all_rounded,
                                                color: Vx.green500,
                                              ).px(10)
                                        : const Icon(
                                            Icons.done_all_rounded,
                                            color: Vx.green500,
                                          ).px(10),
                                    AnimatedContainer(
                                      margin: EdgeInsets.only(
                                          left: context.screenWidth / 50),
                                      duration: const Duration(seconds: 1),
                                      height: context.screenWidth / 15,
                                      child: FittedBox(
                                        child: Text(
                                          MyPrefs.getObLang() == "en"
                                              ? "Result {$itemCount}"
                                              : "परिणाम {$itemCount}",
                                          style: GoogleFonts.oswald(
                                            color: MyPrefs.getTheme() == false
                                                ? Vx.gray900
                                                : Vx.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: context.screenWidth / 10,
                                          ),
                                        ).centered(),
                                      ),
                                    ).objectCenterLeft(),
                                    const Spacer(),
                                    SizedBox(
                                      // margin: EdgeInsets.only(
                                      //     left: context.screenWidth / 5),
                                      height: context.screenWidth / 30,
                                      width: context.screenWidth / 20,
                                      // color: Vx.warmGray100,
                                      child: SmoothPageIndicator(
                                        controller: controller,
                                        count: itemCount,
                                        effect: ScrollingDotsEffect(
                                          dotHeight: context.screenWidth / 30,
                                          dotWidth: context.screenWidth / 30,
                                          fixedCenter: true,
                                          dotColor: Vx.orange400,
                                          activeDotColor: Vx.blue400,
                                        ),
                                      ),
                                    ).p(1),
                                    const Spacer(),
                                  ],
                                ),
                              )
                                  .centered()
                                  .innerShadow(
                                    offset: const Offset(2, 2),
                                    color: MyPrefs.getTheme() == false
                                        ? Vx.gray400
                                        : Vx.black,
                                    blur: 5.0,
                                  )
                                  .innerShadow(
                                      offset: const Offset(-2, -2),
                                      color: MyPrefs.getTheme() == false
                                          ? Vx.white
                                          : Vx.gray700,
                                      blur: 5.0),
                              const Spacer(
                                flex: 1,
                              ),
                              Stack(
                                children: [
                                  detailsView(),
                                ],
                              ).h(context.screenHeight / 1.1),
                              const Spacer(
                                flex: 2,
                              ),
                            ],
                          ),
                        ).centered(),
                      ),
                    ),
                  ),
                ),
              )
            : SafeArea(
                child: Scaffold(
                    backgroundColor: MyPrefs.getTheme() == false
                        ? const Color(0XFFF1F2F6)
                        : Colors.grey[900],
                    body: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      height: context.screenHeight / 1.08,
                      width: context.screenWidth / 1.05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: MyPrefs.getTheme() == false
                              ? const Color(0XFFF1F2F6)
                              : Colors.grey[900],
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(4, 4),
                              color: MyPrefs.getTheme() == false
                                  ? Vx.gray400
                                  : Colors.black,
                              blurRadius: 7.0,
                            ),
                            BoxShadow(
                              offset: const Offset(-4, -4),
                              color: MyPrefs.getTheme() == false
                                  ? Vx.white
                                  : Vx.gray700,
                              blurRadius: 7.0,
                              spreadRadius: 1.0,
                            )
                          ]),
                      child: Column(
                        children: [
                          SizedBox(
                            height: context.screenHeight / 30,
                          ),
                          MyMethods.creatText(
                              20,
                              MyPrefs.getTheme() == false
                                  ? Colors.grey[900]
                                  : const Color(0XFFF1F2F6),
                              MyPrefs.getObLang() == "en"
                                  ? "Medicine Not Found !!!"
                                  : "दवाई नहीं मिली",
                              context,
                              true),
                          const Spacer(),
                          SizedBox(
                            child: Image.asset("assets/images/NotFound.png"),
                          ).p(10),
                          const Spacer(),
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            height: context.screenHeight / 3,
                            width: context.screenWidth / 1.1,
                            decoration: BoxDecoration(
                                color: MyPrefs.getTheme() == false
                                    ? const Color(0XFFF1F2F6)
                                    : Colors.grey[900],
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(4, 4),
                                    color: MyPrefs.getTheme() == false
                                        ? Vx.gray400
                                        : Colors.black,
                                    blurRadius: 7.0,
                                  ),
                                  BoxShadow(
                                    offset: const Offset(-4, -4),
                                    color: MyPrefs.getTheme() == false
                                        ? Vx.white
                                        : Vx.gray700,
                                    blurRadius: 7.0,
                                    spreadRadius: 1.0,
                                  )
                                ]),
                            child: Column(
                              children: [
                                !notFoundListenButton
                                    ? const Icon(
                                        CupertinoIcons.volume_up,
                                        color: Vx.blue400,
                                        size: 30,
                                      ).onInkTap(() {
                                        setState(() {
                                          notFoundListenButton = true;
                                          MyMethods.listenText(
                                              MyPrefs.getObLang() == "en"
                                                  ? MyStrings.notFoundTextEng
                                                  : MyStrings.notFoundTextHi,
                                              MyPrefs.getObLang().toString());
                                        });
                                      }).objectTopRight().p(10)
                                    : const Icon(
                                        CupertinoIcons.stop_circle,
                                        color: Vx.orange500,
                                        size: 30,
                                      ).onInkTap(() {
                                        setState(() {
                                          notFoundListenButton = false;
                                          MyMethods.stopTts();
                                        });
                                      }).objectTopRight().p(10),
                                FittedBox(
                                  child: Text(
                                    MyPrefs.getObLang() == "en"
                                        ? "Try Below Points For Efficient Searching :-\n\n\t1. Capture The Image Clearly So That Text Can Be Detected\n\n\t2. Crop Unwanted Image Using Image Edit(Fast-Search)\n\n\t3. The Medicine Name Should Be Visible In Image\n\n\t4. Check Your Internet Connection"
                                        : "कुशल खोज के लिए नीचे दिए गए बिंदुओं का प्रयास करें:-\n\n\t1. फोटो को स्पष्ट रूप से कैप्चर करें ताकि टेक्स्ट का पता लगाया जा सके\n\n\t2. फोटो एडिट (फास्ट-सर्च) का उपयोग करके अवांछित फोटो हटाएं\n\n\t3. फोटो में दवा का नाम दिखाई देना चाहिए\n\n\t4. अपना इंटरनेट संपर्क जांचे",
                                    style: GoogleFonts.lato(
                                      color: MyPrefs.getTheme() == false
                                          ? Colors.grey[900]
                                          : const Color(0XFFF1F2F6),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ).p(context.screenWidth / 20),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          MyMethods.creatText(
                              context.screenWidth / 30,
                              MyPrefs.getTheme() == false
                                  ? Vx.gray900
                                  : Vx.white,
                              MyPrefs.getObLang() == "en"
                                  ? "Still Having Problem"
                                  : "अभी भी समस्या है",
                              context,
                              true),
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            height: context.screenHeight / 40,
                            width: context.screenWidth / 1.1,
                            child: FittedBox(
                              child: Text(
                                MyPrefs.getObLang() == "en"
                                    ? "Report Us"
                                    : "हमें रिपोर्ट करें",
                                style: GoogleFonts.lato(
                                  color: Vx.blue500,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ).onTap(() {
                            const url =
                                'mailto:help.mediscanner@gmail.com?subject=Title%20:%20Bug%20Report&body=Discription:%20\n%20%20';
                            launchUrl(Uri.parse(url));
                          }),
                          const Spacer(),
                        ],
                      ),
                    ).centered()),
              );
  }

  detailsView() {
    return PageView.builder(
        controller: controller,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(
              bottom: context.screenHeight / 80,
            ),
            child: Stack(children: [
              Container(
                margin: EdgeInsets.only(top: context.screenWidth / 15),
                width: context.screenWidth / 1.1,
                height: context.screenHeight / 25,
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
                        blurRadius: 7.0,
                      ),
                      BoxShadow(
                        offset: const Offset(-4, -4),
                        color:
                            MyPrefs.getTheme() == false ? Vx.white : Vx.gray700,
                        blurRadius: 7.0,
                        spreadRadius: 1.0,
                      )
                    ]),
                child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  height: context.screenWidth / 18,
                  child: FittedBox(
                    child: Text(
                      medData[index]['name'].toString(),
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: MyPrefs.getTheme() == false
                              ? Vx.gray900
                              : Vx.white),
                    ).centered().objectContain().p(5),
                  ),
                ),
              ).objectTopCenter(),
              Container(
                margin: EdgeInsets.only(top: context.screenWidth / 6),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 50),
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  shrinkWrap: true,
                  children: [
                    Container(
                      width: context.screenWidth / 1.2,
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
                              blurRadius: 7.0,
                            ),
                            BoxShadow(
                              offset: const Offset(-4, -4),
                              color: MyPrefs.getTheme() == false
                                  ? Vx.white
                                  : Vx.gray700,
                              blurRadius: 7.0,
                              spreadRadius: 1.0,
                            )
                          ]),
                      margin: EdgeInsets.only(top: context.screenWidth / 40),
                      child: SizedBox(
                          width: context.screenWidth / 1.2,
                          height: context.screenHeight / 2.5,
                          child: PageView.builder(
                              physics: const ScrollPhysics(
                                  parent: BouncingScrollPhysics()),
                              // shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: medData[index]['images'] != null
                                  ? medData[index]['images'].length
                                  : 0,
                              itemBuilder: (context, i) {
                                return SizedBox(
                                  width: context.screenWidth / 1.1,
                                  height: context.screenHeight / 2.5,
                                  child: Stack(children: [
                                    Text(
                                      "Loading..",
                                      style: TextStyle(
                                        color: MyPrefs.getTheme() == false
                                            ? Vx.gray700
                                            : Vx.white,
                                      ),
                                    ).centered(),
                                    SizedBox(
                                      width: context.screenWidth / 1.1,
                                      height: context.screenHeight / 2.5,
                                      child: Image.network(
                                        medData[index]['images'][i].toString(),
                                        scale: 5,
                                      )
                                          .p(context.screenWidth / 30)
                                          .objectContain(),
                                    )
                                  ]),
                                );
                              })),
                    ).p(context.screenWidth / 30),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                            context,
                            medData,
                            index,
                            MyPrefs.getObLang() == "hi"
                                ? "जानकारी"
                                : "Information",
                            "intro"),
                        listenButtons(index, "intro", 0),
                      ],
                    ),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                            context,
                            medData,
                            index,
                            MyPrefs.getObLang() == "hi"
                                ? "उत्पादक"
                                : "Manufacturer",
                            "manufacturer"),
                        listenButtons(index, "manufacturer", 1),
                      ],
                    ),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                            context,
                            medData,
                            index,
                            MyPrefs.getObLang() == "hi"
                                ? "दवाई की अन्य जानकारी"
                                : "Other Information",
                            "composition"),
                        listenButtons(index, "composition", 2),
                      ],
                    ),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                            context,
                            medData,
                            index,
                            MyPrefs.getObLang() == "hi"
                                ? "दवाई की कीमत"
                                : "MRP Information",
                            "mrp1"),
                        listenButtons(index, "mrp1", 3),
                      ],
                    ),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                          context,
                          medData,
                          index,
                          MyPrefs.getObLang() == "hi" ? "उपयोग" : "Uses",
                          "uses",
                        ),
                        listenButtons(index, "uses", 4),
                      ],
                    ),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                          context,
                          medData,
                          index,
                          MyPrefs.getObLang() == "hi" ? "लाभ" : "benifits",
                          "benifits",
                        ),
                        listenButtons(index, "benifits", 5),
                      ],
                    ),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                            context,
                            medData,
                            index,
                            MyPrefs.getObLang() == "hi"
                                ? "दुष्प्रभाव"
                                : "Side-Effects",
                            "sideEffects"),
                        listenButtons(index, "sideEffects", 6),
                      ],
                    ),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                            context,
                            medData,
                            index,
                            MyPrefs.getObLang() == "hi"
                                ? "दवाई कैसे काम करती है"
                                : "How Medicine Works",
                            "howItWorks"),
                        listenButtons(index, "howItWorks", 7),
                      ],
                    ),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                            context,
                            medData,
                            index,
                            MyPrefs.getObLang() == "hi"
                                ? "दवाई कैसे इस्तेमाल करे"
                                : "How To Use Medicine",
                            "howToUse"),
                        listenButtons(index, "howToUse", 8),
                      ],
                    ),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                            context,
                            medData,
                            index,
                            MyPrefs.getObLang() == "hi"
                                ? "सुरक्षा सलाह"
                                : "Safety Advice",
                            "saftyAdvice"),
                        listenButtons(index, "saftyAdvice", 9),
                      ],
                    ),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                            context,
                            medData,
                            index,
                            MyPrefs.getObLang() == "hi"
                                ? "त्वरित सुझाव"
                                : "Quick Tips",
                            "quickTips"),
                        listenButtons(index, "quickTips", 10),
                      ],
                    ),
                    Stack(
                      children: [
                        MyMethods.infoCards(
                            context,
                            medData,
                            index,
                            MyPrefs.getObLang() == "hi"
                                ? "पूछे जाने वाले प्रश्न"
                                : "Faq's",
                            "faqs"),
                        listenButtons(index, "faqs", 11),
                      ],
                    )
                  ],
                ),
              ),
            ]),
          );
        });
  }

  listenButtons(int index, String title, int listenNo) {
    var temp = medData[index][title].toString().removeAllWhiteSpace();
    return temp != "null" && temp != "" && temp != "\n"
        ? Container(
                width: context.screenWidth / 11,
                height: context.screenWidth / 11,
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
                        blurRadius: 7.0,
                      ),
                      BoxShadow(
                        offset: const Offset(-4, -4),
                        color:
                            MyPrefs.getTheme() == false ? Vx.white : Vx.gray700,
                        blurRadius: 7.0,
                        spreadRadius: 1.0,
                      )
                    ]),
                child: !listenIndiv[listenNo]
                    ? const Icon(
                        CupertinoIcons.volume_up,
                        color: Vx.blue400,
                        size: 15,
                      ).onInkTap(() {
                        setState(() {
                          listenIndiv[listenNo] = true;
                          MyMethods.listenText(medData[index][title].toString(),
                              MyPrefs.getObLang().toString());
                        });
                      })
                    : const Icon(
                        CupertinoIcons.stop_circle,
                        color: Vx.orange500,
                        size: 20,
                      ).centered().onInkTap(() {
                        setState(() {
                          listenIndiv[listenNo] = false;
                          MyMethods.stopTts();
                        });
                      }))
            .objectTopRight()
            .p(context.screenHeight / 40)
            .py(context.screenWidth / 200)
        : const SizedBox();
  }
}
