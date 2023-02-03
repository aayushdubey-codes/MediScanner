import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediscanner/Utils/my_prefs.dart';
import 'package:mediscanner/Utils/my_strings.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:velocity_x/velocity_x.dart';

var fontS = 20.0;
var wordSpace = 3.0;
var textPadding = 10.0;

class PanelWidget extends StatefulWidget {
  const PanelWidget(
      {Key? key, required this.scrollController, required this.panelController})
      : super(key: key);
  final ScrollController scrollController;
  final PanelController panelController;

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: MyPrefs.getTheme() == false
                ? const Color(0XFFF1F2F6)
                : Colors.grey[900],
            appBar: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: MyPrefs.getTheme() == false
                  ? const Color(0XFFF1F2F6)
                  : Colors.grey[900],
              centerTitle: true,
              bottom: TabBar(
                  mouseCursor: MouseCursor.defer,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Vx.blue400,
                  labelColor:
                      MyPrefs.getTheme() == false ? Vx.blue500 : Vx.orange400,
                  unselectedLabelColor:
                      MyPrefs.getTheme() == false ? Vx.orange400 : Vx.blue500,
                  tabs: const [
                    Tab(text: "About", icon: Icon(Icons.info_rounded)),
                    Tab(
                      text: "Disclaimer",
                      icon: Icon(Icons.close_rounded),
                    ),
                    Tab(text: "Tutorial", icon: Icon(Icons.support)),
                  ]),
            ),
            body: TabBarView(children: [
              Container(
                  width: context.screenWidth / 1.3,
                  decoration: BoxDecoration(
                    color: MyPrefs.getTheme() == false
                        ? const Color(0XFFF1F2F6)
                        : Colors.grey[900],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: EdgeInsets.only(top: context.screenWidth / 40),
                  child: Column(
                    children: [
                      Text(
                        MyPrefs.getObLang() == "en"
                            ? MyStrings.aboutEn
                            : MyStrings.aboutHi,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.lato(
                          wordSpacing: wordSpace,
                          color: MyPrefs.getTheme() == false
                              ? Colors.grey[900]
                              : Vx.white,
                          // fontWeight: FontWeight.bold,
                        ),
                      ).p(textPadding),
                      Text(
                        MyPrefs.getObLang() == "en"
                            ? "\"Awareness Is The First Step in Treatment\"\nLocation: - AITR Indore, India\nFor More Information\n\nContact Us On:- \nhelp.mediscanner@gmail.com\n\n\n\n\n\n\n\n\n\n@TEAM_MEDISCANNER"
                            : "\"जागरूकता उपचार में पहला कदम है\"\nस्थान:- AITR इंदौर, भारत\n\nअधिक जानकारी के लिए हमसे संपर्क करें: \nhelp.mediscanner@gmail.com\n\n\n\n\n\n\n\n\n\n@Team_MediScanner\nMade With Love - CSIT Department AITR, Indore",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.lato(
                          wordSpacing: wordSpace,
                          color: MyPrefs.getTheme() == false
                              ? Colors.grey[900]
                              : Vx.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ).p(textPadding),
                    ],
                  )),
              Container(
                  width: context.screenWidth / 1.3,
                  decoration: BoxDecoration(
                    color: MyPrefs.getTheme() == false
                        ? const Color(0XFFF1F2F6)
                        : Colors.grey[900],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: EdgeInsets.only(top: context.screenWidth / 40),
                  child: Column(
                    children: [
                      Text(
                        MyPrefs.getObLang() == "en"
                            ? MyStrings.disclaimerEn
                            : MyStrings.disclaimerHi,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.lato(
                          wordSpacing: wordSpace,
                          color: MyPrefs.getTheme() == false
                              ? Colors.grey[900]
                              : Vx.white,
                          // fontWeight: FontWeight.bold,
                        ),
                      ).p(10),
                      Text(
                        MyPrefs.getObLang() == "en"
                            ? "Warning: - The Medicine Information Given In The App May or May Not Be Accurate So Do Not Take Any Medicine On The Basis Of Given Information. Must Consult With Doctor Before Consuming Any Medicine."
                            : "चेतावनी:- ऐप में दी गई दवा की जानकारी सही हो भी सकती है और नहीं भी हो सकती है इसलिए दी गई जानकारी के आधार पर कोई भी दवा न लें। किसी भी दवा का सेवन करने से पहले डॉक्टर से सलाह जरूर लें।",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: GoogleFonts.lato(
                          wordSpacing: wordSpace,
                          color: MyPrefs.getTheme() == false
                              ? Colors.grey[900]
                              : Vx.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ).p(textPadding),
                    ],
                  )),
              ListView(
                controller: widget.scrollController,
                // shrinkWrap: true,
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                children: [
                  getSteps(
                      MyPrefs.getObLang() == "en"
                          ? "Step1: Select Your Prefered Medium For Selecting An Image."
                          : "चरण 1: एक छवि का चयन करने के लिए अपना पसंदीदा माध्यम चुनें।",
                      "https://i.ibb.co/CWBrwHW/Page1.jpg",
                      context),
                  getSteps(
                      MyPrefs.getObLang() == "en"
                          ? "Step 2: Crop An Image With The Help Of Croping Tool For Increasing Searching Rate And Accuracy of Information.\n\nNote : Make Sure Medicine Name Is Visible In Image"
                          : "चरण 2: खोज दर और जानकारी की सटीकता बढ़ाने के लिए क्रॉपिंग टूल की सहायता से एक छवि को क्रॉप करें।\n\nनोट: सुनिश्चित करें कि छवि में दवा का नाम दिखाई दे रहा है",
                      "https://i.ibb.co/PCnQvZL/Page2.jpg",
                      context),
                  getSteps(
                      MyPrefs.getObLang() == "en"
                          ? "Step 3: Now The App Will Automatically Search For Medicine And Shows The Result (Result May Or May Not Be Found : Try Again If Not Found)."
                          : "चरण 3: अब ऐप स्वचालित रूप से दवा की खोज करेगा और परिणाम दिखाएगा (परिणाम मिल सकता है या नहीं मिल सकता है: यदि नहीं मिला तो पुन: प्रयास करें)।",
                      "https://i.ibb.co/SnD3qzK/Page3.jpg",
                      context),
                  getSteps(
                      MyPrefs.getObLang() == "en"
                          ? "Step 4: You Will Get Multiple Results."
                          : "चरण 4: आपको कई परिणाम मिलेंगे।",
                      "https://i.ibb.co/hHk754g/Page4.jpg",
                      context),
                  getSteps(
                      MyPrefs.getObLang() == "en"
                          ? "Step 5: You Can See The Loading Icon On The Top Left Corner Of The Screen.\n Click On Cross Icon To Stop Searching if You Got The Required Information."
                          : "चरण 5: आप स्क्रीन के ऊपरी बाएँ कोने पर लोडिंग आइकन देख सकते हैं।\n आवश्यक जानकारी मिलने पर खोजना बंद करने के लिए क्रॉस आइकन पर क्लिक करें।",
                      "https://i.ibb.co/6brY1wQ/Page8.jpg",
                      context),
                  getSteps(
                      MyPrefs.getObLang() == "en"
                          ? "Step 6: Swipe Left And Right In Image Box To See Multiple Images."
                          : "चरण 6: कई छवियों को देखने के लिए छवि बॉक्स में बाएँ और दाएँ स्वाइप करें।",
                      "https://i.ibb.co/KNBFHzp/Page5.jpg",
                      context),
                  getSteps(
                      MyPrefs.getObLang() == "en"
                          ? "Step 7: Swipe Left And Right Little Bit Down From Image Box To Change Medicine or Medicine Page."
                          : "चरण 7: मेडिसिन या मेडिसिन पेज बदलने के लिए इमेज बॉक्स से बाएँ और दाएँ थोड़ा नीचे स्वाइप करें।",
                      "https://i.ibb.co/Y2QFnQ1/Page6.jpg",
                      context),
                  getSteps(
                      MyPrefs.getObLang() == "en"
                          ? "Step 8: You Can Use Text To Speech Feature To Hear A information.\n To Use This There Is A Small Sound Icon Given On Each Information Card's Top Right Corner."
                          : "चरण 8: आप किसी जानकारी को सुनने के लिए टेक्स्ट टू स्पीच सुविधा का उपयोग कर सकते हैं।\n इसका उपयोग करने के लिए प्रत्येक सूचना कार्ड के शीर्ष दाएं कोने पर एक छोटा ध्वनि चिह्न दिया गया है।",
                      "https://i.ibb.co/YL7H1Nd/Page7.jpg",
                      context),
                ],
              )
            ]),
          ).cornerRadius(20),
        ),
        buildDragHandler(),
        Text(
          MyPrefs.getObLang() == "en" ? "More About Us" : "अधिक जानकारी",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontS,
            color: MyPrefs.getTheme() == false ? Vx.gray900 : Vx.white,
          ),
        ).objectTopCenter().py(20),
      ],
    ).onTap(() {
      widget.panelController.close();
    });
  }

  buildDragHandler() {
    return Center(
      child: Container(
        alignment: Alignment.topCenter,
        width: 30,
        height: 5,
        decoration: BoxDecoration(
            color: MyPrefs.getTheme() == false ? Vx.blue500 : Vx.orange400,
            borderRadius: BorderRadius.circular(20)),
      ).objectTopCenter().p(8).onTap(() {
        widget.panelController.open();
      }),
    );
  }

  getSteps(String text, String image, BuildContext context) {
    return Container(
      width: context.screenWidth,
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
              spreadRadius: 1.0,
            )
          ]),
      child: Column(
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            softWrap: true,
            style: GoogleFonts.lato(
              wordSpacing: wordSpace,
              color: MyPrefs.getTheme() == false ? Colors.grey[900] : Vx.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.network(image).py(10),
        ],
      ).p(20),
    ).p(10);
  }
}
