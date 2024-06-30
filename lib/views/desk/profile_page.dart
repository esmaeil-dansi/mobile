import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/desk/advertisement_page.dart';
import 'package:frappe_app/views/login/login_page.dart';
import 'package:frappe_app/widgets/attach_image.dart';
import 'package:frappe_app/widgets/circle_avatar_widget.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/edit_profile_page.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/AvatarWidget.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _autService = GetIt.I.get<AutService>();
  final _notification = true.obs;
  final _isDarkMode = Get.isDarkMode.obs;
  late SharedPreferences _sharedPreferences;
  var _obscureText = false.obs;

  @override
  void initState() {
    GetIt.I.get<AutService>().fetchAdvertisement(DateTime.now());
    SharedPreferences.getInstance().then((value) => _sharedPreferences = value);
    _autService.getFirstNameAndLastName();
    _autService.getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "حساب کاربری",
            textAlign: TextAlign.center,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              margin: const EdgeInsets.only(top: 2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        AvatarWidget(
                          avatar: _autService.getUserImage(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "اطلاعات کاربری",
                                style: Get.textTheme.bodyMedium,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.to(() => EditProfilePage());
                                  },
                                  child: Row(
                                    children: [
                                      Text("ویرایش"),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.edit,
                                        size: 15,
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _autService.getFullName(),
                                style: Get.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 4,
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Obx(() => _notification.value
                                    ? Icon(
                                        Icons.notifications_active,
                                      )
                                    : Icon(
                                        Icons.notifications_off_rounded,
                                      )),
                                SizedBox(
                                  width: 15,
                                ),
                                Text("اعلان")
                              ],
                            ),
                            Obx(() => Switch(
                                value: _notification.value,
                                onChanged: (_) {
                                  _notification.value = _;
                                  _sharedPreferences.setBool("notification", _);
                                }))
                          ],
                        ),
                        Divider(),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.bottomSheet(Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15)),
                                border: Border.all(width: 0.1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "تغییر رمز عبور",
                                          style: Get.textTheme.bodyLarge
                                              ?.copyWith(fontSize: 18),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.key)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Obx(() => TextField(
                                          obscureText: _obscureText.value,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                _obscureText.value =
                                                    !_obscureText.value;
                                              },
                                              icon: !_obscureText.isTrue
                                                  ? Icon(CupertinoIcons.eye)
                                                  : Icon(
                                                      CupertinoIcons.eye_slash),
                                            ),
                                            labelText: "رمز عبور جدید",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: MAIN_COLOR),
                                      onPressed: () {
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
                            ));
                          },
                          child: SizedBox(
                            height: 37,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.key,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text("تغییر رمز")
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 37,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.phone),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text("تماس با ما")
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 37,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outlined),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text("درباره ما")
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.bottomSheet(Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15)),
                                border: Border.all(width: 0.1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "ثبت پیام",
                                          style: Get.textTheme.bodyLarge
                                              ?.copyWith(fontSize: 18),
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
                                      obscureText: _obscureText.value,
                                      decoration: InputDecoration(
                                        labelText: "پیام",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: MAIN_COLOR),
                                      onPressed: () {
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
                            ));
                          },
                          child: SizedBox(
                            height: 37,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.support_agent_outlined),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text("پشتیبانی")
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.to(() => AdvertisementPage());
                          },
                          child: SizedBox(
                            height: 37,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.insert_drive_file_outlined),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text("اطلاعیه")
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 37,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outlined),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text("نسخه\t 2.3")
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Divider(
                          thickness: 4,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          content: Text("از خروج مطمنید؟"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.pop(_);
                                                },
                                                child: Text("لغو")),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.pop(_);
                                                  await _autService.logout();
                                                  Get.offAll(() => Login());
                                                },
                                                child: Text(
                                                  "بله",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                          ],
                                        ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'خروج از حساب ',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.red),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
