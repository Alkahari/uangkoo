import 'package:flutter/material.dart';
import 'package:uangkoo/API/Authentications.dart';
import 'package:uangkoo/main.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
      Duration(seconds: 2),
      () async {
        Authentications().checkToken(context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: getLength("width", context),
        height: getLength("height", context),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: MyText(
                "Uangkoo",
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
