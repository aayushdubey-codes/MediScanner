import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediscanner/Utils/methods.dart';
import 'package:mediscanner/Utils/my_prefs.dart';
import 'package:mediscanner/Utils/panel_widget.dart';
import 'package:mediscanner/pages/image_selection.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:velocity_x/velocity_x.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final panController = PanelController();
  var isTapped = false;
  Future<bool> goBack() async {
    var isDone = false;
    await Navigator.pushReplacement(
        context,
        PageTransition(
          child: const ImageSelection(),
          curve: Curves.easeInOut,
          type: PageTransitionType.scale,
          duration: const Duration(milliseconds: 150),
          reverseDuration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
        ));
    isDone = true;
    return isDone;
  }

  @override
  Widget build(BuildContext context) {
    double _panelHeightOpen = context.screenHeight * 0.9;
    double _panelHeightClosed = context.screenHeight * 0.06;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => goBack(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: MyPrefs.getTheme() == false
                ? const Color(0XFFF1F2F6)
                : Colors.grey[900],
            body: SlidingUpPanel(
              controller: panController,
              minHeight: _panelHeightClosed,
              maxHeight: _panelHeightOpen,
              parallaxEnabled: true,
              parallaxOffset: 0.6,
              margin: const EdgeInsets.only(right: 3, left: 3),
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              body: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: context.screenHeight / 1.03,
                width: context.screenWidth / 1.05,
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
                        spreadRadius: 1.0,
                      )
                    ]),
                child: Column(
                  children: [
                    //------> This Is Heading Function Of Setting Page
                    MyMethods.settingPageTopHeading(context),
                    SizedBox(
                      height: context.screenHeight / 12,
                      width: context.screenWidth,
                    ),

                    //------> This Is 1st Button Function Of Setting Page
                    MyMethods.settingPageButtons(context, "ls"),
                    SizedBox(
                      height: context.screenHeight / 20,
                      width: context.screenWidth,
                    ),

                    //------> This Is 2nd Button Function Of Setting Page
                    MyMethods.settingPageButtons(context, "rb"),
                    SizedBox(
                      height: context.screenHeight / 20,
                      width: context.screenWidth,
                    ),

                    //------> This Is 3rd Button Function Of Setting Page
                    MyMethods.settingPageButtons(context, "sf"),
                    const Spacer(),
                    AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      width: context.screenWidth / 3.8,
                      height: context.screenHeight / 18,
                      decoration: BoxDecoration(
                          color: MyPrefs.getTheme() == false
                              ? const Color(0XFFF1F2F6)
                              : Colors.grey[900],
                          borderRadius: BorderRadius.circular(100.0),
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
                          isTapped || MyPrefs.getTheme() == true
                              ? AnimatedContainer(
                                  curve: Curves.easeInOutCirc,
                                  duration: const Duration(milliseconds: 500),
                                  width: context.screenHeight / 20,
                                  height: context.screenHeight / 20,
                                  decoration: BoxDecoration(
                                      color: MyPrefs.getTheme() == false
                                          ? const Color(0XFFF1F2F6)
                                          : Colors.grey[900],
                                      borderRadius:
                                          BorderRadius.circular(100.0),
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
                                  child: const Icon(
                                    Icons.dark_mode,
                                    color: Vx.orange400,
                                  )).objectCenterRight().onInkTap(() async {
                                  await MyPrefs.theme(false);
                                  setState(() {
                                    isTapped = false;
                                  });
                                })
                              : AnimatedContainer(
                                  curve: Curves.easeInOutCirc,
                                  duration: const Duration(milliseconds: 500),
                                  width: context.screenHeight / 20,
                                  height: context.screenHeight / 20,
                                  decoration: BoxDecoration(
                                      color: Vx.blue500,
                                      borderRadius:
                                          BorderRadius.circular(100.0),
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
                                  child: const Icon(
                                    Icons.wb_sunny,
                                    color: Vx.orange400,
                                  )).objectCenterLeft().onInkTap(() async {
                                  await MyPrefs.theme(true);
                                  setState(() {
                                    isTapped = true;
                                  });
                                }),
                          isTapped || MyPrefs.getTheme() == true
                              ? AnimatedContainer(
                                  height: context.screenWidth / 15,
                                  duration: const Duration(seconds: 1),
                                  child: FittedBox(
                                    child: Text(
                                      "Dark",
                                      style: GoogleFonts.oswald(
                                          fontSize: context.screenWidth / 30,
                                          fontWeight: FontWeight.bold,
                                          color: Vx.white),
                                    ).objectCenterLeft().px(10),
                                  ),
                                ).objectCenterLeft().onInkTap(() async {
                                  await MyPrefs.theme(false);
                                  setState(() {
                                    isTapped = false;
                                  });
                                })
                              : AnimatedContainer(
                                  height: context.screenWidth / 15,
                                  duration: const Duration(seconds: 1),
                                  child: FittedBox(
                                    child: Text(
                                      "Light",
                                      style: GoogleFonts.oswald(
                                        fontSize: context.screenWidth / 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ).objectCenterRight().px(10),
                                  ),
                                ).objectCenterRight().onInkTap(() async {
                                  await MyPrefs.theme(true);
                                  setState(() {
                                    isTapped = true;
                                  });
                                }),
                        ],
                      ),
                    ),
                    const Spacer(
                      flex: 5,
                    ),

                    //------> This Is Bottom Arc Function Of Setting Page
                  ],
                ),
              ).centered(),
            ),
          ),
        ),
      ),
    );
  }
}
