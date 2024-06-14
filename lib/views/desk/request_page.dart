import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/db/request.dart';
import 'package:frappe_app/repo/RequestRepo.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:get_it/get_it.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../db/request_statuse.dart';

class RequestPage extends StatefulWidget {
  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _requestRepo = GetIt.I.get<RequestRepo>();

  final _visitiService = GetIt.I.get<VisitService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<List<Request>>(
              future: _requestRepo.getAll(),
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
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),

                                      Column(
                                        children: [
                                          Text(
                                            Jalali.fromDateTime(time)
                                                .formatCompactDate(),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          Text(
                                            time.hour.toString() +
                                                ":" +
                                                time.minute.toString(),
                                            style: TextStyle(fontSize: 17),
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
                                              BuildContext? v;
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: c,
                                                  builder: (c) {
                                                    v = c;
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  });
                                              var res = false;
                                              if (record.type ==
                                                  "Initial Visit") {
                                                res = await _visitiService
                                                    .resendInitVisit(record);
                                              } else if (record.type ==
                                                  "Periodic visits") {
                                                res = await _visitiService
                                                    .reSendPeriodicVisitsRequest(
                                                        record);
                                              } else {
                                                res = await _visitiService
                                                    .resendVetVisit(record);
                                              }
                                              Navigator.pop(v!);
                                              if (res) {
                                                _requestRepo.delete(record);
                                                setState(() {});
                                              }
                                            },
                                            child: Text("باز ارسال")),

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
