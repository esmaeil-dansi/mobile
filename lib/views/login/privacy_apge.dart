import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/constant.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(colors: GRADIANT_COLOR)),
            child: Center(
                child: Text(
              "فهمیدم",
              style: Get.textTheme.bodyLarge?.copyWith(color: Colors.black),
            )),
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("حریم خصوصی"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: GRADIANT_COLOR),
                border: Border.all(),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      " چوپو از کدملی و شماره موبایل شما جهت ایجاد حساب کاربری و ارائه خدمات استفاده می کند.\n" +
                           "این اطلاعات  شما نیز به صورت رمزنگاری‌شده در بستر امن HTTPS به وب ‌سایت ما منتقل و برای تعاملات بعدی نگهداری خواهند شد.\n"
                          "همچنین تعهد میدهد که این اطلاعات نزد ما به صورت رمز نگاری شده محفوظ است و به هیچ عنوان از آن‌ها سواستفاده نخواهد شد و در اختیار شخص یا سازمان ثالثی قرار نخواهد گرفت."),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
