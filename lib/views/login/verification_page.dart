import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/login/user_info.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:pinput/pinput.dart';

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
  TextEditingController _pinController = TextEditingController();

  void _cancelTimer() {
    timer?.cancel();
  }

  @override
  void initState() {
    _startTimer();

    _pinController.addListener(() {
      if (_pinController.text.length == 4) {
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
                        Center(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Pinput(
                              controller: _pinController,
                              length: 4,
                              // focusNode: _focusNode,
                              autofocus: true,

                              // listenForMultipleSmsOnAndroid: true,
                              // inputFormatters: [NumberInputFormatter],
                              hapticFeedbackType:
                                  HapticFeedbackType.lightImpact,
                              onCompleted: (_) {},
                              cursor: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 9),
                                    width: 22,
                                    height: 1,
                                    // color: focusedBorderColor,
                                  ),
                                ],
                              ),

                              errorPinTheme:
                                  errorPinTheme(Get.theme, fontSize: 30),
                              defaultPinTheme:
                                  defaultPinTheme(Get.theme, fontSize: 30),
                              focusedPinTheme:
                                  focusedPinTheme(Get.theme, fontSize: 30),
                              submittedPinTheme:
                                  submittedPinTheme(Get.theme, fontSize: 30),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  PinTheme focusedPinTheme(ThemeData theme, {double fontSize = 0}) =>
      defaultPinTheme(theme, fontSize: fontSize).copyDecorationWith(
        color: theme.colorScheme.primary.withOpacity(0.3),
        border: Border.all(color: Colors.green, width: 5),
        borderRadius: BorderRadius.circular(_PIN_CODE_WIDTH / 2),
      );

  PinTheme submittedPinTheme(ThemeData theme, {double fontSize = 0}) =>
      defaultPinTheme(theme, fontSize: fontSize).copyWith(
        decoration: defaultPinTheme(theme, fontSize: fontSize)
            .decoration!
            .copyWith(color: Colors.green),
      );

  PinTheme errorPinTheme(ThemeData theme, {double fontSize = 0}) => PinTheme(
        width: _PIN_CODE_WIDTH,
        height: _PIN_CODE_HEIGHT,
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 2,
          color: theme.colorScheme.onError,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          border: Border.all(color: theme.focusColor, width: 2),
          borderRadius: BorderRadius.circular(_PIN_CODE_WIDTH / 2),
        ),
      );
  final _PIN_CODE_HEIGHT = 70.0;
  final _PIN_CODE_WIDTH = 50.0;

  PinTheme defaultPinTheme(ThemeData theme, {double fontSize = 0}) => PinTheme(
        width: _PIN_CODE_WIDTH,
        height: _PIN_CODE_HEIGHT,
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
          height: 2,
        ),
        decoration: BoxDecoration(
          color: theme.hoverColor,
          border: Border.all(color: theme.focusColor, width: 2),
          borderRadius: BorderRadius.circular(_PIN_CODE_WIDTH / 2),
        ),
      );

  Future<void> _next() async {
    _loading.value = true;
    var res = await _autService.sendVerificationCode(_pinController.text);
    _loading.value = false;
    if (res.isEmpty) {
      Get.to(UserInfo());
    } else {
      Fluttertoast.showToast(msg: res);
    }
  }
}
