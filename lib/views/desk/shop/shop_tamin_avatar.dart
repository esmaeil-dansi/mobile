import 'package:flutter/cupertino.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class ShopTaminavatar extends StatelessWidget {
  String? image;

  ShopTaminavatar(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width*.9,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: GRADIANT_COLOR),
        // border: Border.all(color: Color(0xFF12E312), width: 2),
        shape: BoxShape.rectangle,
        image: image != null
            ? DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage("https://icasp.ir" + image!, headers: {
                  'cookie': GetIt.I.get<HttpService>().getCookie(),
                }))
            : null,
      ),
      child: image != null ? null : Icon(CupertinoIcons.shopping_cart),
    );
  }
}
