import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'constant.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _athService = GetIt.I.get<AutService>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idController = TextEditingController();

  @override
  void initState() {
    _nameController.text = _athService.getName;
    _lastNameController.text = _athService.getLastName;
    _idController.text = _athService.getUsername;
    _athService.getFirstNameAndLastName().then((value) {
      _nameController.text = value.$1;
      _lastNameController.text = value.$2;
      _idController.text = value.$3;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ویرایش اطلاعات"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SingleChildScrollView(
              child: Container(
                height: Get.height * 0.74,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "نام",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: "نام خانوادگی",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: "نام کاربری",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: Get.width * 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: MAIN_COLOR),
                  onPressed: () async {
                    // var res = await _athService.editProfile(
                    //     name: _nameController.text,
                    //     lName: _lastNameController.text,
                    //     username: "test");
                    // if (res) {
                    //   Fluttertoast.showToast(msg: "انجام شد");
                    // } else {
                    //   Fluttertoast.showToast(msg: "خطایی رخ داه است");
                    //   Get.back();
                    // }
                  },
                  child: Text(
                    "ثبت",
                    style: const TextStyle(fontSize: 21, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
