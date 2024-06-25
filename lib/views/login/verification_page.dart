import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/login/user_info.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerificationPage extends StatefulWidget {
  String phoneNumber;

  VerificationPage(this.phoneNumber);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  var time = 30.obs;
  Timer? timer;
  final _loading = false.obs;

  void _cancelTimer() {
    timer?.cancel();
  }

  @override
  void initState() {
    _startTimer();

    SmsAutoFill().listenForCode;
    _textController.addListener(() {
      if (_textController.text.length == 4) {
        _next();
      }
    });
    super.initState();
  }

  void _startTimer() {
    timer?.cancel();
    time.value = 30;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time > 0) {
        time.value = time.value - 1;
      } else {
        _cancelTimer();
      }
    });
  }

  final _autService = GetIt.I.get<AutService>();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(() => time.value > 0
              ? Text("ارسال دوباره کد تایید تا" + "\t" + time.string)
              : TextButton(
                  onPressed: () {
                    _autService.sendSms(widget.phoneNumber);
                    _startTimer();
                  },
                  child: Text("ارسال مجدد کد تایید"))),
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
                      "بعدی",
                      style: Get.textTheme.bodyLarge
                          ?.copyWith(color: Colors.black),
                    ))),
            ),
          )
        ],
      ),
      appBar: AppBar(),
      body: Container(
          height: Get.height,
          width: double.infinity,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/icons/background.jpg"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "کد تایید را وارد کنید",
                              style: Get.textTheme.displaySmall
                                  ?.copyWith(fontSize: 28),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Text(
                              "کد فعال سازی را به شماره" +
                                  "\t" +
                                  "${widget.phoneNumber}" +
                                  "\t" +
                                  "فرستادیم",
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("شماره موبایل اشتباه است؟"),
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("ویرایش"))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: PinFieldAutoFill(
                              controller: _textController,
                              autoFocus: true,
                              decoration: UnderlineDecoration(
                                // gapSpace: 20,
                                textStyle: TextStyle(
                                  fontSize: 40,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                                colorBuilder: FixedColorBuilder(Colors.black),
                              ),
                              onCodeSubmitted: (_) => _next(),
                              codeLength: 4),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future<void> _next() async {
    _loading.value = true;
    var res = await _autService.sendVerificationCode(_textController.text);
    _loading.value = false;
    if (res.isEmpty) {
      Get.to(UserInfo());
    } else {
      Fluttertoast.showToast(msg: res);
    }
  }
}
