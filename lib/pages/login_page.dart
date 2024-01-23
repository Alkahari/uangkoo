import 'package:flutter/material.dart';
import 'package:uangkoo/API/Authentications.dart';
import 'package:uangkoo/main.dart';
import 'package:uangkoo/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          height: getLength("height", context),
          width: getLength("width", context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                "Uangkoo",
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: PRIMARY_COLOR,
              ),
              SizedBox(
                height: 36,
              ),
              LoginTextField(
                controller: emailController,
                obscureText: false,
                icon: Icons.email_outlined,
                type: "Email",
              ),
              SizedBox(
                height: 16,
              ),
              LoginTextField(
                controller: passwordController,
                obscureText: true,
                icon: Icons.lock_outline,
                type: "Password",
              ),
              SizedBox(
                height: 32,
              ),
              LoginButton(
                text: "Login",
                onPressed: () {
                  if (emailController.value.text.isEmpty ||
                      passwordController.value.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Center(
                          child: Text("Isi semua form"),
                        ),
                      ),
                    );
                  } else {
                    var authentication = Authentications();
                    authentication.login(emailController.value.text,
                        passwordController.value.text, context);
                  }
                },
              ),
              SizedBox(
                height: 12,
              ),
              OrDivider(),
              SizedBox(
                height: 12,
              ),
              LoginButton(
                backgroundColor: Colors.grey,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterPage(),
                    ),
                  );
                },
                text: "Register",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 1,
          width: 15,
          color: Colors.black,
        ),
        SizedBox(width: 5,),
        MyText("OR", fontWeight: FontWeight.bold,),
        SizedBox(width: 5,),
        Container(
          height: 1,
          width: 15,
          color: Colors.black,
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  final void Function() onPressed;
  final String text;
  Color? backgroundColor;
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: MyText(
          text,
          color: textColor ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  LoginTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.icon,
    required this.type,
  });

  final TextEditingController controller;
  final bool obscureText;
  final IconData icon;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 0),
              blurRadius: 5,
            ),
          ]),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          hintText: type,
          hintStyle: TextStyle(
              color: PRIMARY_COLOR.withOpacity(0.8), fontFamily: "Source Sans"),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
