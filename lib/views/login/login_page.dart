import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/views/login/register.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../services/aut_service.dart';
import '../../widgets/constant.dart';
import '../desk/splash_screen.dart';
import 'forget_password.dart';

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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
              height: 200,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    height: 200,
                    width: width + 20,
                    child: FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Container(
                            child: SvgPicture.asset(
                          'assets/icons/login.svg',
                          height: 200.0,
                        ))),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                      duration: Duration(milliseconds: 1500),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 11),
                            child: Image.asset(
                              "assets/ChopoLogo.png",
                              width: 55,
                              height: 40,
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1700),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                  color: Color.fromRGBO(71, 108, 68, .3)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(71, 108, 68, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ]),
                          child: TextField(
                            controller: _usernameController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "نام کاربری",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade700)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                  color: Color.fromRGBO(71, 108, 68, .3)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(71, 108, 68, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                )
                              ]),
                          child: Obx(() => TextField(
                                obscureText: _obscureText.value,
                                controller: _passwordController,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  labelText: "رمزعبور",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _obscureText.value = !_obscureText.value;
                                    },
                                    icon: _obscureText.isTrue
                                        ? Icon(CupertinoIcons.eye)
                                        : Icon(CupertinoIcons.eye_slash),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 3, color: Colors.red),
                                    //<-- SEE HERE
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: TextButton(
                          onPressed: () {
                            Get.to(() => ForgetPassword());
                          },
                          child: Text(
                            "بازیابی رمز عبور",
                            style: TextStyle(
                                color: Color.fromRGBO(71, 108, 68, 1)),
                          ))),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: Column(children: [
                    Center(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (_loading.isFalse) {
                            _next();
                          }
                        },
                        child: Container(
                          width: 500,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                  colors: BUTTON_GRADIANT_COLOR)),
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
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                  colors: BUTTON_GRADIANT_COLOR1)),
                          child: OutlinedButton(
                            onPressed: () {
                              Get.to(() => Register());
                            },
                            child: const Text("ثبت نام",
                                style: TextStyle(
                                    fontFamily: 'GeneralSans',
                                    fontWeight: FontWeight.w500)),
                          )),
                    )
                  ]))
                ],
              ),
            )
          ],
        ),
      ),
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
        Get.off(() => SplashScreen());
        // Get.off(() => DesktopView(
        //       needToCheckUpdate: false,
        //     ));
      } else {
        Fluttertoast.showToast(msg: "نام کاربری یا رمز عبور اشتباه است");
      }
    });
  }
}
