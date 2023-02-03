import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediscanner/Utils/my_prefs.dart';
import 'package:mediscanner/pages/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await MyPrefs.init();
  if (MyPrefs.getColor() == null) {
    MyPrefs.logoColor(true);
  }
  if (MyPrefs.getObLang() == null) {
    await MyPrefs.myLang("hi");
  }
  if (MyPrefs.getObBool() == null) {
    await MyPrefs.isObDone(false);
  }
  if (MyPrefs.getTheme() == null) {
    await MyPrefs.theme(false);
  }
  runApp(const MediScanner());
}

class MediScanner extends StatelessWidget {
  const MediScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
