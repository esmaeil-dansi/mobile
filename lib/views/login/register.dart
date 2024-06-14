import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/login/verification_page.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class Register extends StatelessWidget {
  final _textController = TextEditingController();
  final _autService = GetIt.I.get<AutService>();
  final _loading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GestureDetector(
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
                gradient: LinearGradient(colors: test)),
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
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Container(
              width: double.infinity,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage("assets/icons/background.jpg"),
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Image.asset(
                  //   "assets/icons/login_title.png",
                  //   height: 200,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 80,
                            ),
                            Row(
                              children: [
                                Text(
                                  "خوش آمدید",
                                  style: Get.textTheme.displaySmall,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text(
                                  "شماره موبایل خود را وارد کنید.",
                                  style: Get.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 55,
                                child: TextField(
                                  controller: _textController,
                                  keyboardType: TextInputType.phone,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                  onSubmitted: (_) => _next(),
                                  decoration: InputDecoration(
                                    labelText: "شماره تلفن",
                                    hintText: "09121234567",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    suffixIcon: IconButton(
                                      icon: Icon(CupertinoIcons.clear_circled),
                                      onPressed: () {
                                        _textController.clear();
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 3, color: Colors.red),
                                      //<-- SEE HERE
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  void _next() {
    if (_textController.text.isEmpty || _textController.text.length < 11) {
      Fluttertoast.showToast(msg: "َشماره تلفن را درست وارد کنید");
    } else {
      _loading.value = true;
      _autService.sendSms(_textController.text).then((res) {
        _loading.value = false;
        if (res.isEmpty) {
          Get.to(() => VerificationPage(_textController.text));
        } else {
          Fluttertoast.showToast(msg: res);
        }
      });
    }
  }
}