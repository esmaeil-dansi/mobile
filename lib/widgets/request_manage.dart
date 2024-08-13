import 'package:flutter/material.dart';
import 'package:frappe_app/db/request.dart';
import 'package:frappe_app/repo/request_repo.dart';
import 'package:get_it/get_it.dart';

void manageRequest(
    String title, Request request, BuildContext context, Function change) {
  final _requestRepo = GetIt.I.get<RequestRepo>();
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'درخواست تکراری',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 7,
                ),
                Text("شما یه درخواست" +
                    "\t" +
                    title +
                    "\t" +
                    "با کد ملی" +
                    "\t" +
                    request.nationId +
                    "به صورت معوق دارید"),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(_);
                    _requestRepo.delete(request);
                  },
                  child: Text("حذف")),
              ElevatedButton(
                  onPressed: () async {
                    change();
                    Navigator.pop(_);
                  },
                  child: Text(
                    "ویرایش",
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ));
}
