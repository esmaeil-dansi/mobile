import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/views/login/login_page.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../services/aut_service.dart';
import '../../widgets/constant.dart';

class ResetPassword extends StatefulWidget {
  String code;
  String username;

  ResetPassword({required this.code, required this.username});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _autService = GetIt.I.get<AutService>();

  var _passwordController = TextEditingController();

  var _rPasswordController = TextEditingController();

  final _loading = false.obs;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (_loading.isFalse) {
                _reset();
              }
            },
            child: Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(colors: GRADIANT_COLOR)
              ),
              child: Obx(() => _loading.isTrue
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: Text(
                      "بعدی",
                      style: Get.textTheme.bodyLarge
                          ?.copyWith(color: Colors.black),
                    ))),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text("رمز عبور جدید"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _passwordController,
                  validator: (c) {
                    if (c == null ||
                        c.isEmpty ||
                        c != _rPasswordController.text) {
                      return "کدواژه با تکرار کدواژه یکسان نیست.";
                    }
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "کدواژه",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _rPasswordController,
                  validator: (c) {
                    if (c == null ||
                        c.isEmpty ||
                        c != _passwordController.text) {
                      return "کدواژه با تکرار کدواژه یکسان نیست.";
                    }
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "تکرار کدواژه",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ));
  }

  Future<void> _reset() async {
    if (_formKey.currentState?.validate() ?? false) {
      String pattern = r'(^(?=.*[a-z])(?=.*[A-Z]).{8,}$)';

      RegExp regExp = new RegExp(pattern);
      if (regExp.hasMatch(_passwordController.text)) {
        _loading.value = true;
        var res = await _autService.resetPassword(
            widget.code, widget.username, _passwordController.text);
        if (res.isEmpty) {
          Get.offAll(() => Login());
        } else {
          Fluttertoast.showToast(msg: res);
        }
        _loading.value = false;
      } else {
        Fluttertoast.showToast(
            msg:
                "اندازه کدواژه باید حداقل 8 باشد و شامل حداقل یک حرف لاتین بزرگ و یک حرف لاتین کوچک باشد");
      }
    }
  }
}
