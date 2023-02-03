import 'package:shared_preferences/shared_preferences.dart';

class MyPrefs {
  static SharedPreferences? myprefs;
  static var temp = myprefs;
  static const _keyBool = 'obDone';
  static const _keyString = 'lang';
  static const _keyColor = 'color';
  static const _keyTheme = 'theme';

  static Future init() async => myprefs = await SharedPreferences.getInstance();

  static isObDone(bool obDone) async =>
      await myprefs!.setBool(_keyBool, obDone);
  static myLang(String lang) async =>
      await myprefs!.setString(_keyString, lang);
  static logoColor(bool logoC) async =>
      await myprefs!.setBool(_keyColor, logoC);
  static theme(bool thm) async => await myprefs!.setBool(_keyTheme, thm);
  static bool? getObBool() => myprefs!.getBool(_keyBool);
  static String? getObLang() => myprefs!.getString(_keyString);
  static bool? getColor() => myprefs!.getBool(_keyColor);
  static bool? getTheme() => myprefs!.getBool(_keyTheme);
}
