import 'package:flutter/material.dart';
import 'package:uangkoo/API/Authentications.dart';
import 'package:uangkoo/main.dart';
import 'package:uangkoo/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                onPressed: () {
                  if (emailController.value.text.isEmpty ||
                      passwordController.value.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Center(child: Text("Isi semua form")),
                      ),
                    );
                  } else {
                    var authentication = Authentications();
                    authentication.register(emailController.value.text,
                        passwordController.value.text, context);
                  }
                },
                text: "Register",
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
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                text: "Login",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
