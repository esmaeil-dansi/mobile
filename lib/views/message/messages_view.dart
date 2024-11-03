import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/message_service.dart';
import 'package:frappe_app/views/message/new_message_page.dart';
import 'package:frappe_app/views/visit/add_periodic_visit.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/new_from_widget.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../model/message.dart';

class MessagesView extends StatefulWidget {
  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final _messageService = GetIt.I.get<MessageService>();
  final _athService = GetIt.I.get<AutService>();
  RxList<Message> _messages = new RxList<Message>();
  final _noResult = false.obs;
  final _startSearch = false.obs;
  final _hasFilter = false.obs;

  @override
  void initState() {
    _messageService.fetchMessages().then((value) => _messages.addAll(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: _athService.isVisitingTeamOrIsRahbar()
            ? newFormWidget(()=>Get.to(()=>NewMessagePage()), title: "پیام جدید")
            : null,
        appBar: appSliverAppBar("پیام"),
        body: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white54),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt)),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: Get.width / 2,
                    child: TextField(
                      onChanged: (t) {
                        _filter(t);
                      },
                      decoration: InputDecoration(
                        labelText: "َشناسه",
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: Colors.black),
                          //<-- SEE HERE
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Obx(() => _messages.isNotEmpty
                  ? Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: Get.width * 0.25,
                                  child: Text(
                                    "شناسه",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                  width: Get.width * 0.2,
                                  child: Text(
                                    "وضعیت",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                  width: Get.width * 0.15,
                                  child: Text(
                                    "موضوع",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                  width: Get.width * 0.3,
                                  child: Text(
                                    "متن پیام",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: ListView.separated(
                              physics: ScrollPhysics(),
                              itemCount: _messages.length,
                              itemBuilder: (c, i) {
                                var record = _messages[i];
                                return Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          width: Get.width * 0.25,
                                          child: Text(record.name.toString())),
                                      SizedBox(
                                          width: Get.width * 0.2,
                                          child: Text(record.status)),
                                      SizedBox(
                                          width: Get.width * 0.15,
                                          child: Text(record.subject1)),
                                      SizedBox(
                                          width: Get.width * 0.3,
                                          child: Text(record.message)),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider();
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  : _startSearch.isTrue
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _noResult.isTrue
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("نتیجه ای یافت نشده است"),
                            )
                          : SizedBox.shrink())
            ],
          ),
        ),
      ),
    );
  }

  void _filter(String id) async {
    _messages.clear();
    _hasFilter.value = true;
    _startSearch.value = true;
    var s = await _messageService.fetchMessages(id: id);
    if (s.isNotEmpty) {
      _messages.addAll(s);
    }
    _startSearch.value = false;
  }
}
