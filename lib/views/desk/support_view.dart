import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';

import '../../services/aut_service.dart';
import '../../widgets/app_sliver_app_bar.dart';
import '../../widgets/constant.dart';

class SupportView extends StatefulWidget {
  @override
  _SupportViewState createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  final _autService = GetIt.I.get<AutService>();
  TextEditingController _controller = TextEditingController();
  var _obscureText = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appSliverAppBar("پشتیبانی"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "ثبت پیام",
                      style: Get.textTheme.bodyLarge?.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.support_agent_outlined)
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  maxLines: 3,
                  controller: _controller,
                  obscureText: _obscureText.value,
                  decoration: InputDecoration(
                    labelText: "پیام",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: MAIN_COLOR),
                  onPressed: () {
                    _autService.sendReport(_controller.text);
                    _controller.clear();
                    Fluttertoast.showToast(msg: "ثبت شد");
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: Get.width * 0.9,
                      child: Center(
                          child: Text(
                        "ثبت",
                        style: Get.textTheme.bodyLarge
                            ?.copyWith(color: Colors.white),
                      ))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
