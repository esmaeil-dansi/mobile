import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/db/advertisement.dart';
import 'package:frappe_app/db/dao/advertisement_dao.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class AdvertisementPage extends StatefulWidget {
  @override
  State<AdvertisementPage> createState() => _AdvertisementPageState();
}

class _AdvertisementPageState extends State<AdvertisementPage> {
  var advDao = GetIt.I.get<AdvertisementDao>();

  var date = DateTime.now();

  @override
  void initState() {
    GetIt.I.get<AutService>().fetchAdvertisement(date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("اطلاعیه ها"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: StreamBuilder<Advertisement?>(
              stream: advDao.watch(DateFormat('yyyy-MM-dd').format(date)),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  var adv = snapshot.data!;
                  return ListView.builder(
                    itemCount: adv.title.length,
                    itemBuilder: (c, i) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: GRADIANT_COLOR)),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(adv.title[i]),
                                    )),
                              )),
                        ),
                        onTap: () {
                          Get.bottomSheet(Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  width: Get.width,
                                  height: Get.height * 0.5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: SingleChildScrollView(
                                          child: Text(
                                            adv.body[i],
                                            maxLines: null,
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10)),
                                      color: Colors.white),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  gradient: LinearGradient(colors: GRADIANT_COLOR)),
                            ),
                          ));
                        },
                      );
                    },
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Text("اطلاعیه ی جدیدی وجود ندارد.");
              }),
        ),
      ),
    );
  }
}
