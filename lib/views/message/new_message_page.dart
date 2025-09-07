
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:frappe_app/model/message_user.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/message_service.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:frappe_app/widgets/file_picker_widget.dart';
import 'package:frappe_app/widgets/new_from_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_it/get_it.dart';

class NewMessagePage extends StatefulWidget {
  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  @override
  void initState() {
    _messageService.getAgent("");
    super.initState();
  }

  final _messageService = GetIt.I.get<MessageService>();

  final _autService = GetIt.I.get<AutService>();

  Map<int, MessageUser> receivers = <int, MessageUser>{}.obs;

  Map<int, MessageUser> ccrReceivers = <int, MessageUser>{}.obs;

  var receiverCount = 1;

  var ccrReceiverCount = 1;

  var _vaziat = "";

  var _olavaiat = "";

  var _issue = TextEditingController();

  var _body = TextEditingController();

  var _filePath = "".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: submitForm(
        () {
          _messageService.sendMessage(
              status: _vaziat,
              priority: _olavaiat,
              subject1: _issue.text,
              body: _body.text,
              audience1: receivers.values.toList(),
              audience_copy: ccrReceivers.values.toList(),
              imagePath: _filePath.value);
        },
      ),
      appBar: appSliverAppBar("پیام جدید"),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // color: Colors.green,
          child: Container(
            margin: EdgeInsets.only(left: 7, right: 7, top: 9, bottom: 90),
            decoration: BoxDecoration(
                border: Border.all(),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: TextField(
                      readOnly: true,
                      focusNode: FocusNode(canRequestFocus: false),
                      controller: TextEditingController(
                          text: _autService.fullName()),
                      decoration: InputDecoration(
                        labelText: "شناسه ارسال کننده",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: _autService.fullName()),
                      decoration: InputDecoration(
                        labelText: "نام ارسال کننده",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        labelText: "گیرندگان",
                        labelStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: receiverCount,
                            itemBuilder: (c, i) {
                              var messageUser = receivers[i];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TypeAheadField(
                                      emptyBuilder: (c) {
                                        return Text("موردی یافت نشد");
                                      },
                                      builder: (context, textController, focusNode) {
                                        textController.text = messageUser?.name ?? "";
                                        return TextField(
                                          controller: textController,
                                          focusNode: focusNode,
                                          decoration: InputDecoration(
                                            suffix: GestureDetector(
                                              child: const Icon(Icons.delete, color: Colors.red),
                                              onTap: () {
                                                if (receiverCount > 1) {
                                                  receiverCount = receiverCount - 1;
                                                }
                                                receivers.remove(i);
                                                setState(() {});
                                              },
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            labelText: messageUser?.email ?? "مخاطب",
                                          ),
                                        );
                                      },
                                      suggestionsCallback: (pattern) async {
                                        return (await _messageService
                                                .getAgent(""))
                                            .where((suggestion) =>
                                                suggestion.name.contains(
                                                    pattern.toLowerCase()))
                                            .toList();
                                      },
                                      // Widget to build each suggestion in the list
                                      itemBuilder: (context, suggestion) {
                                        return Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Column(
                                              children: [
                                                Text(suggestion.name),
                                                Text(suggestion.email),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      // Callback when a suggestion is selected
                                      onSelected: (suggestion) async {
                                        receivers[i] = suggestion;
                                        setState(() {});
                                      },
                                    )
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: 4,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              receiverCount = receiverCount + 1;
                              setState(() {});
                            },
                            child: Text("اضافه کردن ردیف"))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InputDecorator(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "گیرندگان رونوشت",
                          labelStyle: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: ccrReceiverCount,
                              itemBuilder: (c, i) {
                                var messageUser = ccrReceivers[i];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TypeAheadField(
                                        emptyBuilder: (c) {
                                          return Text("موردی یافت نشد");
                                        },
                                        builder: (context, textController, focusNode) {
                                          textController.text = messageUser?.name ?? "";

                                          return TextField(
                                            controller: textController,
                                            focusNode: focusNode,
                                            decoration: InputDecoration(
                                              suffix: GestureDetector(
                                                child: const Icon(Icons.delete, color: Colors.red),
                                                onTap: () {
                                                  if (ccrReceiverCount > 1) {
                                                    ccrReceiverCount = ccrReceiverCount - 1;
                                                  }
                                                  ccrReceivers.remove(i);
                                                  setState(() {});
                                                },
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              labelText: messageUser?.email ?? "مخاطب",
                                            ),
                                          );
                                        },
                                        suggestionsCallback: (pattern) async {
                                          return (await _messageService
                                                  .getAgent(""))
                                              .where((suggestion) =>
                                                  suggestion.name.contains(
                                                      pattern.toLowerCase()))
                                              .toList();
                                        },
                                        // Widget to build each suggestion in the list
                                        itemBuilder: (context, suggestion) {
                                          return Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: Column(
                                                children: [
                                                  Text(suggestion.name),
                                                  Text(suggestion.email),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        // Callback when a suggestion is selected
                                        onSelected:
                                            (suggestion) async {
                                          ccrReceivers[i] = suggestion;
                                          setState(() {});
                                        },
                                      )
                                    ],
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 4,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                ccrReceiverCount = ccrReceiverCount + 1;
                                setState(() {});
                              },
                              child: Text("اضافه کردن ردیف"))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 70,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "وضعیت",
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: Colors.red),
                          //<-- SEE HERE
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      items: ["باز", "بسته", "در حال انجام"]
                          .map((e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        _vaziat = value!;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 70,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "اولویت",
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: Colors.red),
                          //<-- SEE HERE
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      items: ["عادی", "فوری", "مهم", "مهم و فوری"]
                          .map((e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        _olavaiat = value!;
                      },
                    ),
                  ),
                  TextField(
                    controller: _issue,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "موضوع",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FilePickerWidget(_filePath),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _body,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "متن",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
