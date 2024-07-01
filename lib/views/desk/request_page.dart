import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frappe_app/db/request.dart';
import 'package:frappe_app/model/add_initial_visit_from_model.dart';
import 'package:frappe_app/model/add_per_vsiti_form_model.dart';
import 'package:frappe_app/model/add_vetvisit_form_model.dart';
import 'package:frappe_app/repo/RequestRepo.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/views/visit/add_initial_visit.dart';
import 'package:frappe_app/views/visit/add_periodic_visit.dart';
import 'package:frappe_app/views/visit/add_vetvisit.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../db/request_statuse.dart';

class RequestPage extends StatefulWidget {
  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _requestRepo = GetIt.I.get<RequestRepo>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<List<Request>>(
              stream: _requestRepo.watch(),
              builder: (c, sData) {
                if (sData.hasData &&
                    sData.data != null &&
                    sData.data!.isNotEmpty) {
                  return Expanded(
                      child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: sData.data!.length,
                          itemBuilder: (c, i) {
                            var record = sData.data![i];
                            var time = DateTime.fromMillisecondsSinceEpoch(
                                record.time);
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all()),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (record.nationId.isNotEmpty)
                                            Text(
                                              record.nationId,
                                            ),
                                          Text(
                                            getType(record.type),
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            Jalali.fromDateTime(time)
                                                .formatCompactDate()
                                                .toString(),
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          Text(
                                            time.hour.toString() +
                                                ":" +
                                                time.minute.toString(),
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      if (record.status ==
                                          RequestStatus.Success)
                                        Icon(
                                          CupertinoIcons
                                              .checkmark_alt_circle_fill,
                                          color: Colors.green,
                                          size: 35,
                                        ),
                                      if (record.status ==
                                          RequestStatus.Pending)
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xE452FF22)),
                                            onPressed: () async {
                                              var res = false;
                                              if (record.type ==
                                                  "Initial Visit") {
                                                Get.to(() => AddInitialReport(
                                                    time: record.time,
                                                    addInitialVisitFormModel:
                                                        AddInitialVisitFormModel
                                                            .fromJson(json
                                                                .decode(record
                                                                    .body))));
                                              } else if (record.type ==
                                                  "Periodic visits") {
                                                Get.to(() => AddPeriodicReport(
                                                    time: record.time,
                                                    addPerVisitFormModel:
                                                        AddPerVisitFormModel
                                                            .fromJson(json
                                                                .decode(record
                                                                    .body))));
                                              } else {
                                                Get.to(() => AddVetVisit(
                                                    time: record.time,
                                                    addVetVisitFormModel:
                                                        AddVetVisitFormModel
                                                            .fromJson(json
                                                                .decode(record
                                                                    .body))));
                                              }
                                            },
                                            child:
                                                Text("ویرایش و \nباز ارسال ")),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ));
                }
                return Center(
                    child: Text("درخواستی وجود ندارد.",
                        style: TextStyle(fontSize: 23)));
              })
        ],
      ),
    );
  }

  String getType(String text) {
    if (text == "Initial Visit") {
      return "بازدید اولیه";
    }
    if (text == "Periodic visits") {
      return "بازدید دوره ای";
    }
    if (text == "Vet Visit") {
      return "بازدید پزشکی";
    }
    return text;
  }
}
