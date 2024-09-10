import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/desk/splash_screen.dart';
import 'package:frappe_app/views/desk/desk_view.dart';
import 'package:frappe_app/views/login/forget_password.dart';
import 'package:frappe_app/views/login/register.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _autService = GetIt.I.get<AutService>();

  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  final _loading = false.obs;

  final _obscureText = true.obs;

  Future<void> saveLogin() async {
    var s = await SharedPreferences.getInstance();
    s.setBool("login", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("حساب کاربری ندارید؟"),
                    SizedBox(
                      width: 6,
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(() => Register());
                        },
                        child: Text(
                          "ثبت نام",
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        ))
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (_loading.isFalse) {
                  _next();
                }
              },
              child: Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(colors: GRADIANT_COLOR)),
                child: Obx(() => _loading.isTrue
                    ? Center(child: CircularProgressIndicator())
                    : Center(
                        child: Text(
                        "ورود",
                        style: Get.textTheme.bodyLarge
                            ?.copyWith(color: Colors.black),
                      ))),
              ),
            ),
          ],
        ),
      ),
      body: Container(
          width: double.infinity,
          // height: Get.height*0,
          decoration: BoxDecoration(
            color: Colors.white
              // image: DecorationImage(
              //   image: AssetImage("assets/icons/background.jpg"),
              //   fit: BoxFit.cover,
              // ),
              ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "خوش آمدید",
                      style: Get.textTheme.displaySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "نام کاربری و رمز عبور خود را وارد کنید.",
                      style: Get.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "نام کاربری",
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 3, color: Colors.red),
                          //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() => TextField(
                          obscureText: _obscureText.value,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "رمزعبور",
                            suffixIcon: IconButton(
                              onPressed: () {
                                _obscureText.value = !_obscureText.value;
                              },
                              icon: !_obscureText.isTrue
                                  ? Icon(CupertinoIcons.eye)
                                  : Icon(CupertinoIcons.eye_slash),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(width: 3, color: Colors.red),
                              //<-- SEE HERE
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.to(() => ForgetPassword());
                            },
                            child: Text("بازیابی رمز عبور")),
                      ],
                    ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              ),
            ],
          )),
    );
  }

  void _next() {
    _loading.value = true;
    _autService
        .login(
      username: _usernameController.text,
      password: _passwordController.text,
    )
        .then((res) {
      _loading.value = false;
      if (res.$1) {
        saveLogin();
        Get.off(() =>SplashScreen());
        // Get.off(() => DesktopView(
        //       needToCheckUpdate: false,
        //     ));
      } else {
        Fluttertoast.showToast(msg: "خطایی رخ داده است");
      }
    });
  }
}
