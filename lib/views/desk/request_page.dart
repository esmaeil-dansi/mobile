import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/db/request.dart';
import 'package:frappe_app/model/add_initial_visit_from_model.dart';
import 'package:frappe_app/model/add_per_vsiti_form_model.dart';
import 'package:frappe_app/model/add_product_form_model.dart';
import 'package:frappe_app/model/add_vetvisit_form_model.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/repo/request_repo.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/views/visit/add_initial_visit.dart';
import 'package:frappe_app/views/visit/add_periodic_visit.dart';
import 'package:frappe_app/views/visit/add_productivit_visit.dart';
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
  final _visitService = GetIt.I.get<VisitService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("درخواست ها"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    Progressbar.showProgress();
                    var res = await _requestRepo.backupRequests();
                    Progressbar.dismiss();
                    if (res) {
                      Fluttertoast.showToast(
                          msg: "ذخیره سازی درخواست ها انجام شد");
                    } else {
                      Fluttertoast.showToast(msg: "خطایی رخ داده است");
                    }
                  },
                  child: Column(
                    children: [
                      Icon(CupertinoIcons.cloud_download),
                      Text("ذخیره درخواست ها")
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _requestRepo.restoreRequests();
                  },
                  child: Column(
                    children: [
                      Icon(Icons.backup_outlined),
                      Text("بارگذاری درخواست ها")
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
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
                                height: 90,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all()),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            getType(record.type),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          if (record.nationId.isNotEmpty)
                                            Text(
                                              record.nationId,
                                            ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                time.hour.toString() +
                                                    ":" +
                                                    time.minute.toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blueAccent),
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                Jalali.fromDateTime(time)
                                                    .formatCompactDate()
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blueAccent),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          if (record.status ==
                                              RequestStatus.Success)
                                            SizedBox(
                                              width: 100,
                                              child: Icon(
                                                CupertinoIcons
                                                    .checkmark_alt_circle_fill,
                                                color: Colors.greenAccent,
                                                size: 35,
                                              ),
                                            )
                                          else if (record.status ==
                                              RequestStatus.Pending)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          backgroundColor:
                                                              Color(
                                                                  0xE452FF22)),
                                                  onPressed: () async {
                                                    // Progressbar.showProgress();
                                                    if (record.type ==
                                                        "Initial Visit") {
                                                      final model =
                                                          AddInitialVisitFormModel
                                                              .fromJson(json
                                                                  .decode(record
                                                                      .body));
                                                      Get.to(() =>
                                                          AddInitialReport(
                                                            addInitialVisitFormModel:
                                                                model,
                                                            time: record.time,
                                                          ));
                                                      // var agentInfo =
                                                      //     await _visitService
                                                      //         .getAgentInfo(model
                                                      //             .nationalId!);
                                                      // await _visitService
                                                      //     .saveInitVisit(
                                                      //         agentInfo:
                                                      //             agentInfo ??
                                                      //                 AgentInfo(),
                                                      //         model: model,
                                                      //         time:
                                                      //             record.time);
                                                    } else if (record.type ==
                                                        "Periodic visits") {
                                                      var model =
                                                          AddPerVisitFormModel
                                                              .fromJson(json
                                                                  .decode(record
                                                                      .body));
                                                      Get.to(() =>
                                                          AddPeriodicReport(
                                                            addPerVisitFormModel:
                                                                model,
                                                            time: record.time,
                                                          )); // if (model.fullName ==
                                                      //         null ||
                                                      //     model.fullName!
                                                      //         .isEmpty) {
                                                      //   var agentInfo =
                                                      //       await _visitService
                                                      //           .getAgentInfo(model
                                                      //               .nationalId!);
                                                      //   if (agentInfo != null) {
                                                      //     model.department =
                                                      //         agentInfo
                                                      //             .department;
                                                      //     model.province =
                                                      //         agentInfo
                                                      //             .province;
                                                      //     model.city =
                                                      //         agentInfo.city;
                                                      //     model.rahbar =
                                                      //         agentInfo.rahbar;
                                                      //     model.fullName =
                                                      //         agentInfo
                                                      //             .full_name;
                                                      //   }
                                                      // }
                                                      // await _visitService
                                                      //     .sendPeriodicVisits(
                                                      //         addPerVisitFormModel:
                                                      //             model,
                                                      //         time:
                                                      //             record.time);
                                                    } else if (record.type ==
                                                        "Vet Visit") {
                                                      var model =
                                                          AddVetVisitFormModel
                                                              .fromJson(json
                                                                  .decode(record
                                                                      .body));
                                                      Get.to(() => AddVetVisit(
                                                            addVetVisitFormModel:
                                                                model,
                                                            time: record.time,
                                                          ));
                                                      // final agentInfo =
                                                      //     await _visitService
                                                      //         .getAgentInfo(model
                                                      //             .nationalId!);
                                                      // await _visitService
                                                      //     .saveVetVisit(
                                                      //         model: model,
                                                      //         time: record.time,
                                                      //         agentInfo:
                                                      //             agentInfo ??
                                                      //                 AgentInfo());
                                                    } else if (record.type ==
                                                        "Product") {
                                                      Get.to(() => ProductVisitReport(
                                                          time: record.time,
                                                          addProductivityFormModel:
                                                              ProductivityFormModel
                                                                  .fromJson(json
                                                                      .decode(record
                                                                          .body))));
                                                    }
                                                    Progressbar.dismiss();
                                                  },
                                                  child: Text("ارسال ")),
                                            ),
                                          if (record.status ==
                                              RequestStatus.Pending)
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15)),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (_) => AlertDialog(
                                                                content: Text(
                                                                    "از حذف درخواست مطمئنید؟"),
                                                                actions: [
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator
                                                                            .pop(_);
                                                                      },
                                                                      child: Text(
                                                                          "لغو")),
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        _requestRepo
                                                                            .delete(record);
                                                                        Navigator
                                                                            .pop(_);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "بله",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red),
                                                                      )),
                                                                ],
                                                              ));
                                                },
                                                child: Text(
                                                  "حذف",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ));
                }
                if (sData.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
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
    if (text == "Product") {
      return "بهره وری";
    }
    return text;
  }
}
