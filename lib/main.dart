import 'package:flutter/material.dart';
import 'package:uangkoo/pages/login_page.dart';
import 'package:uangkoo/pages/main_page.dart';
import 'package:uangkoo/pages/splashscreen_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: const SplashScreenPage(), theme: ThemeData(primarySwatch: Colors.green));
  }
}

double getLength(String type, BuildContext context) {
  var query = MediaQuery.of(context).size;

  return (type == "height") ? query.height : query.width;
}

Color PRIMARY_COLOR = Colors.green;

class MyText extends StatelessWidget {
  MyText(
    this.text, {
    this.color,
    this.fontSize,
    this.textAlign,
    this.fontWeight,
    super.key,
  });
  final String text;
  Color? color;
  double? fontSize;
  TextAlign? textAlign;
  FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      style: MyTextStyle(
          color: color ?? Colors.black,
          fontSize: fontSize ?? 12,
          fontWeight: fontWeight ?? FontWeight.normal),
    );
  }
}
MyTextStyle({color, double? fontSize, fontWeight}) {
  return TextStyle(
      fontFamily: "Source Sans",
      color: color ?? Colors.grey,
      fontSize: fontSize ?? 12.0,
      fontWeight: fontWeight ?? FontWeight.normal);
}
