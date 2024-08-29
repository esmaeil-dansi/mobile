import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/views/login/resetPqssword.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../services/aut_service.dart';
import '../../widgets/constant.dart';

class ForgetPassword extends StatelessWidget {
  final _autService = GetIt.I.get<AutService>();
  var _usernameController = TextEditingController();
  var _codeController = TextEditingController();
  final _loading = false.obs;

  final codeIsSend = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (_loading.isFalse) {
              if (codeIsSend.value) {
                _sendCode();
              } else {
                _sendSms();
              }
            }
          },
          child: Container(

            width: 100,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(colors: GRADIANT_COLOR)),
            child: Obx(() => _loading.isTrue
                ? Center(child: CircularProgressIndicator())
                : Center(
                    child: Text(
                    "بعدی",
                    style:
                        Get.textTheme.bodyLarge?.copyWith(color: Colors.black),
                  ))),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("بازیابی رمز عبور"),
      ),
      body: Container(
        color: Colors.white,
        child: Obx(() => codeIsSend.isTrue
            ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text("کد اعتبار سنجی برای شما پیامک شد"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        decoration: InputDecoration(
                          labelText: "کد اعتبار سنجی",
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
            )
            : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text("کد ملی خود را وارد کنید"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        maxLength: 10,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "کد ملی",
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 3, color: Colors.red),
                            //<-- SEE HERE
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
            )),
      ),
    );
  }

  Future<void> _sendSms() async {
    _loading.value = true;
    var res = await _autService.forgetPassword(_usernameController.text);
    if (res.isEmpty) {
      codeIsSend.value = true;
    } else {
      Fluttertoast.showToast(msg: res);
    }
    _loading.value = false;
  }

  Future<void> _sendCode() async {
    _loading.value = true;
    var res = await _autService.setForgetPassCode(
        _codeController.text, _usernameController.text);
    if (res.isEmpty) {
      Get.to(() => ResetPassword(
            code: _codeController.text,
            username: _usernameController.text,
          ));
    } else {
      Fluttertoast.showToast(msg: res);
    }
    _loading.value = false;
  }
}
