import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/utils/SharedPreferenceHelper.dart';
import 'package:frappe_app/utils/constants.dart';
import 'package:frappe_app/views/desk/advertisement_page.dart';
import 'package:frappe_app/views/desk/desk_view.dart';
import 'package:frappe_app/views/login/login_page.dart';
import 'package:frappe_app/widgets/circle_avatar_widget.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/edit_profile_page.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/AvatarWidget.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _autService = GetIt.I.get<AutService>();
  final _shared = GetIt.I.get<SharedPreferencesHelper>();
  final _notification = true.obs;
  var _obscureText = false.obs;
  final selectUserIsOpen = false.obs;

  @override
  void initState() {
    GetIt.I.get<AutService>().fetchAdvertisement(DateTime.now());
    _autService.getFirstNameAndLastName();
    _autService.getPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: () {
              Get.back();
            },
          ),
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
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              selectUserIsOpen.value = !selectUserIsOpen.value;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _autService.fullName(),
                                  style: Get.textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                    onPressed: () {
                                      selectUserIsOpen.value =
                                          !selectUserIsOpen.value;
                                    },
                                    icon: Obx(() => !selectUserIsOpen.value
                                        ? Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 30,
                                          )
                                        : Icon(
                                            Icons.keyboard_arrow_up_rounded,
                                            size: 30,
                                          )))
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => AnimatedSwitcher(
                              duration: Duration(milliseconds: 400),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                final offsetAnimation = Tween<Offset>(
                                  begin: Offset(0, 1), // Starts from up
                                  end: Offset(0, 0), // Ends at the center
                                ).animate(animation);
                                return SlideTransition(
                                    position: offsetAnimation, child: child);
                              },
                              child: selectUserIsOpen.value
                                  ? buildSelectAccount()
                                  : SizedBox()),
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
                                  // _sharedPreferences.setBool("notification", _);
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
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            launchUrl(Uri.parse('tel:02191693961'));
                          },
                          child: SizedBox(
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
                                  Text("نسخه\t " + VERSION)
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
                                          content: Text("از خروج مطمئن هستید؟"),
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

                                                  if (_shared.userIsLogin(
                                                      _shared
                                                          .getAnotherUser())) {
                                                    _shared.changeUser(_shared
                                                        .getAnotherUser());
                                                    Get.offAll(
                                                        () => DesktopView());
                                                  } else {
                                                    Get.offAll(() => Login());
                                                  }
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

  Widget buildSelectAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      key: Key("value"),
      children: [
        _buildUserInfo(
            name: _shared.getUserInfo(_shared.getCurrentUser()),
            avatar: _shared.getUserImage(_shared.getCurrentUser()),
            isCurrentUser: true,
            current: _shared.getCurrentUser()),
        if (_shared.userIsLogin(_shared.getAnotherUser()))
          _buildUserInfo(
              name: _shared.getUserInfo(_shared.getAnotherUser()),
              avatar: _shared.getUserImage(_shared.getAnotherUser()),
              isCurrentUser: false,
              current: _shared.getAnotherUser())
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onTap(_shared.getAnotherUser()),
              child: Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(
                    width: 10,
                  ),
                  Text("افزودن حساب")
                ],
              ),
            ),
          ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget _buildUserInfo(
      {required String name,
      required bool isCurrentUser,
      required String avatar,
      required CurrentUser current}) {
    return GestureDetector(
      onTap: () => onTap(current),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Container(
              height: 40,
              width: Get.width * 2 / 3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black26)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            name,
                            style: TextStyle(
                                fontSize: 12, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        buildCircleAvatarUi(avatar: avatar, radius: 25),
                      ],
                    ),
                    if (isCurrentUser)
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      )
                    else
                      SizedBox(
                        width: 25,
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onTap(CurrentUser user) {
    _shared.changeUser(user);
    if (_shared.userIsLogin(user)) {
      Get.offAll(() => DesktopView());
    } else {
      Get.offAll(() => Login());
    }
  }
}
