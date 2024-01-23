// import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uangkoo/main.dart';
import 'package:uangkoo/pages/login_page.dart';
import 'package:uangkoo/pages/main_page.dart';

String BaseUrl = "http://192.168.43.200/uangkoo/";

class Authentications {
  var dio = Dio();

  void register(String email, String password, BuildContext context) async {
    try {
      var data = {"email": email, "password": password};
      var formData = FormData.fromMap(data);
      var result = await dio
          .post(
        "$BaseUrl/api/user/register.php",
        data: formData,
      )
          .then((value) {
        if (value.statusCode == 200) {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Center(child: Text("Success")),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text("Something went wrong"),
            ),
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void login(String email, String password, BuildContext context) async {
    try {
      var data = {
        "email": email,
        "password": password,
      };
      var formData = FormData.fromMap(data);
      Response response = await dio.post(
        "$BaseUrl/api/user/login.php",
        data: formData,
      );
      print(response.data);
      String token = response.data;

      //Simpan token ke dalam shared preferences
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString("Token", token);
      await prefs.setString("Email", email);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return MainPage();
          },
        ));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: MyText("Not logged")));
      }
    } catch (e) {
      print("ERRORR : " + e.toString());
      // Handle other errors
    }

    void checkUser(BuildContext context) async {
      var dio = Dio();
      var prefs = await SharedPreferences.getInstance();
      var Token = await prefs.getString("Token");
      try {
        dio.options.headers["accept"] = "application/json";
        if (Token!.isNotEmpty) {
          try {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MainPage();
                },
              ),
            );
          } catch (e) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const LoginPage();
                },
              ),
            );
          }
        }
      } catch (e) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const LoginPage();
            },
          ),
        );
        print(e);
      }
    }
  }

  void checkToken(BuildContext context) async {
    try {
      var Token = await getToken(context: context);
      if (Token != "" || Token != null || Token!.isNotEmpty) {
        var data = {"token": Token};
        var formData = FormData.fromMap(data);
        var result = await dio.post("$BaseUrl/", data: formData);
        print(result.statusCode);
        if (result.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MainPage();
              },
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        print(e.response!.statusCode);
        // Token expired or unauthorized, navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const LoginPage();
            },
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const LoginPage();
            },
          ),
        );
        // Handle other DioErrors
        print("DioError: $e");
        // You can add more specific error handling based on DioError type
      }
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        ),
      );
      // Handle other exceptions
      print("Error: $e");
    }
  }

  Future<String> getEmail() async {
    try {
      var token = await getToken();
      var data = {"token": token};
      var formData = FormData.fromMap(data);
      var result = await dio.post(
        "$BaseUrl/api/user/user.php",
        data: formData,
      );

      // Parse the JSON string into a Dart Map
      Map<String, dynamic> resultMap = json.decode(result.data);
      String email = resultMap["email"];
      return email;
    } catch (e) {
      print("Error: $e");
      return "error";
      // Handle errors appropriately
    }
  }

  void logout(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return const LoginPage();
      },
    ));
  }
}

Future<String?> getToken({BuildContext? context}) async {
  try {
    var prefs = await SharedPreferences.getInstance();
    var Token = await prefs.getString("Token");
    print(Token);
    return Token;
  } catch (e) {
    Navigator.pushReplacement(
        context!,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
    return "";
  }
}

Future<String?> getEmail({BuildContext? context}) async {
  try {
    var prefs = await SharedPreferences.getInstance();
    var Token = await prefs.getString("Email");
    print(Token);
    return Token;
  } catch (e) {
    Navigator.pushReplacement(
        context!,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
    return "";
  }
}
