import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/widgets/attach_image.dart';
import 'package:frappe_app/widgets/circle_avatar_widget.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class AvatarWidget extends StatelessWidget {
  final bool isCircular;
  Rx<String> avatar;
  double radius;

  AvatarWidget(
      {this.isCircular = true, required this.avatar, this.radius = 110});

  final _autService = GetIt.I.get<AutService>();
  final _uploading = false.obs;
  String newAvatar = "";

  @override
  Widget build(BuildContext context) {
    return Obx(() => !isCircular
        ? GestureDetector(
            onTap: () {
              _change();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                buildShopAvatar(_uploading.value, newAvatar, avatar),
                if (_uploading.isTrue)
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.yellowAccent,
                    ),
                  ),
              ],
            ))
        : Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: radius,
                  height: radius,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      buildCircleAvatar(_uploading.value, newAvatar, avatar),
                      if (_uploading.isTrue)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.yellowAccent,
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                            width: 37,
                            height: 37,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                                border: Border.all(color: MAIN_COLOR)),
                            child: IconButton(
                              onPressed: () {
                                _change();
                              },
                              icon: Icon(
                                CupertinoIcons.camera,
                                color: Colors.black,
                                size: 21,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
  }

  void _change() {
    showSelectImageBottomSheet((_) async {
      if (_.isNotEmpty) {
        newAvatar = _.first;
        _uploading.value = true;
        if (isCircular) {
          await _autService.changeProfileAvatar(newAvatar);
        } else {
          await GetIt.I.get<ShopService>().changeShopAvatar(newAvatar);
        }
        _uploading.value = false;
      }
    }, selectFromGallery: true);
  }
}
