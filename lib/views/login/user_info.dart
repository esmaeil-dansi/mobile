import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/login/login_page.dart';
import 'package:frappe_app/widgets/checkBox.dart';
import 'package:frappe_app/widgets/city_selector.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../widgets/progressbar_wating.dart';

class UserInfo extends StatefulWidget {
  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _autService = GetIt.I.get<AutService>();
  var _damdar = false;
  var _taminUser = false;
  final _name = TextEditingController();

  final _lastName = TextEditingController();

  final _pass = TextEditingController();

  final _newPass = TextEditingController();

  final _province = TextEditingController();

  final _nationId = TextEditingController();

  final _bio = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("فرم کاربری"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_sharp),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: _name,
                                  validator: (d) {
                                    if (d == null || d.isEmpty) {
                                      return "نمی تواند خالی باشد";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "نام",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: _lastName,
                                  validator: (d) {
                                    if (d == null || d.isEmpty) {
                                      return "نمی تواند خالی باشد";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "نام خانوادگی",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: _nationId,
                                  validator: (d) {
                                    if (d == null || d.isEmpty) {
                                      return "نمی تواند خالی باشد";
                                    } else if (d.length < 10) {
                                      return "کد ملی معتبر نمی باشد";
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "کد ملی",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                provinceSelector((_) {
                                  _province.text = _;
                                }, _province.text),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: _bio,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: "معرفی مختصر",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: _pass,
                                  validator: (c) {
                                    if (c == null ||
                                        c.isEmpty ||
                                        c != _newPass.text) {
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
                                  height: 8,
                                ),
                                TextFormField(
                                  controller: _newPass,
                                  validator: (c) {
                                    if (c == null ||
                                        c.isEmpty ||
                                        c != _pass.text) {
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
                                SizedBox(
                                  height: 8,
                                ),
                                TitleCheckBox(
                                    "در صورت هماهنگی با شرکت » تامین کننده هستم»",
                                    (c) {
                                  _taminUser = c;
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MAIN_COLOR),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (_province.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "استان مورد نظر را انتخاب کنید");
                            } else {
                              String pattern =
                                  r'(^(?=.*[a-z])(?=.*[A-Z]).{8,}$)';

                              RegExp regExp = new RegExp(pattern);
                              if (regExp.hasMatch(_pass.text)) {
                                Progressbar.showProgress();
                                var state = await _autService
                                    .nationalCodeIsAvailable(_nationId.text);
                                switch (state) {
                                  case FetchNationalStatus.Failed:
                                    Fluttertoast.showToast(
                                        msg:
                                            "این شماره ملی از قبل ثبت شده است");
                                    break;
                                  case FetchNationalStatus.Success:
                                    if (await _autService.sendInfo(
                                        password: _pass.text,
                                        tamin: _taminUser,
                                        nationalId: _nationId.text,
                                        province: _province.text,
                                        bio: _bio.text,
                                        firstname: _name.text,
                                        lastname: _lastName.text)) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "ثبت نام با موفقیت انجام شد لطفا ورود کنید");
                                      Get.offAll(() => Login());
                                    }
                                    break;
                                  case FetchNationalStatus.Error:
                                    Fluttertoast.showToast(
                                        msg:
                                            "خطایی در استعلام شماره ملی رخ داده است");
                                    break;
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "اندازه کدواژه باید حداقل 8 باشد و شامل حداقل یک حرف لاتین بزرگ و یک حرف لاتین کوچک باشد");
                              }
                            }
                          }
                        },
                        child: Text(
                          "ثبت",
                          style: const TextStyle(
                              fontSize: 21, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
