import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/agent.dart';
import 'package:frappe_app/model/message.dart';
import 'package:frappe_app/model/message_user.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/file_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../widgets/methodes.dart';

class MessageService {
  final _httpService = GetIt.I.get<HttpService>();
  final _fileService = GetIt.I.get<FileService>();
  final _autService = GetIt.I.get<AutService>();
  final _logger = Logger();
  var agents = <MessageUser>[];

  Future<List<Message>> fetchMessages({int start = 0, String id = ""}) async {
    var messages = <Message>[];
    try {
      List<List<String>> filters = [];
      if (id != "") {
        filters.add(["Message", "name", "like", "%$id%"]);
      }
      var result = await _httpService.post(
          "/api/method/frappe.desk.reportview.get",
          FormData.fromMap({
            'doctype': "Message",
            'fields': json.encode([
              "`tabMessage`.`name`",
              "`tabMessage`.`owner`",
              "`tabMessage`.`creation`",
              "`tabMessage`.`modified`",
              "`tabMessage`.`modified_by`",
              "`tabMessage`.`_user_tags`",
              "`tabMessage`.`_comments`",
              "`tabMessage`.`_assign`",
              "`tabMessage`.`_liked_by`",
              "`tabMessage`.`docstatus`",
              "`tabMessage`.`idx`",
              "`tabMessage`.`status`",
              "`tabMessage`.`subject1`",
              "`tabMessage`.message",
              "`tabMessage`.`_seen`"
            ]),
            'filters': json.encode(filters),
            'order_by': '`tabMessage`.`modified` DESC',
            'start': start,
            'page_length': 50,
            'view': "List",
            'group_by': '`tabMessage`.`name`',
            'with_comment_count': 1
          }));
      for (var data in result?.data["message"]["values"]) {
        var msg = Message.fromJson(data);
        if (msg != null) {
          messages.add(msg);
        }
      }
      return messages
          .where((element) =>
              element.owner.contains(_autService.fullNameChar()) ||
              element.modified_by.contains(_autService.fullNameChar()) ||
              element.owner.contains(_autService.mainUserId()) ||
              element.modified_by.contains(_autService.mainUserId()))
          .toList();
    } catch (e) {
      _logger.e(e);
    }
    return messages;
  }

  Future<List<MessageUser>> getAgent(String txt) async {
    if (txt.isEmpty && agents.isNotEmpty) {
      return agents;
    }
    return fetchAgents(txt: txt);
  }

  Future<List<MessageUser>> fetchAgents({String txt = ""}) async {
    try {
      agents.clear();
      var result = await _httpService.post(
          "/api/method/frappe.desk.search.search_link",
          FormData.fromMap({
            'txt': txt.isNotEmpty ? int.parse(txt) : '',
            'doctype': 'User',
            'ignore_user_permissions': '0',
            'reference_doctype': 'Audience'
          }));

      for (var element in (result?.data["results"] as List<dynamic>)) {
        MessageUser? agent = MessageUser.fromJson(element);
        if (agent != null) {
          agents.add(agent);
        }
      }
    } catch (e) {
      _logger.e(e);
    }
    return agents;
  }

  Future<bool> sendMessage({
    required String status,
    required String priority,
    required String subject1,
    required String body,
    required List<MessageUser> audience1,
    required List<MessageUser> audience_copy,
    required String imagePath,
  }) async {
    try {
      var image = await _fileService.uploadFile(imagePath, "Message",
          docname: "new-message-1", fieldname: "upload_files");
      if (image != null && image.isNotEmpty) {
        var result = await _httpService.post(
            "/api/method/frappe.desk.form.save.savedocs",
            FormData.fromMap({
              'doc': json.encode({
                "docstatus": 0,
                "doctype": "Message",
                "name": "new-message-1",
                "__islocal": 1,
                "__unsaved": 1,
                "owner": _autService.getUserId(),
                "status": status,
                "priority": priority,
                "audience1": audience1
                    .map((e) => {
                          "docstatus": 0,
                          "doctype": "Audience",
                          "name": "new-audience-1",
                          "__islocal": 1,
                          "__unsaved": 1,
                          "owner": "Administrator",
                          "parent": "new-message-1",
                          "parentfield": "audience1",
                          "parenttype": "Message",
                          "idx": 1,
                          "name_contact": e.name,
                          "audience": e.email
                        })
                    .toList(),
                "sender_name": _autService.getUserId(),
                "user_id": _autService.getUserId(),
                "audience_copy": audience1
                    .map((e) => {
                          "docstatus": 0,
                          "doctype": "Audience",
                          "name": "new-audience-3",
                          "__islocal": 1,
                          "__unsaved": 1,
                          "owner": "Administrator",
                          "parent": "new-message-1",
                          "parentfield": "audience_copy",
                          "parenttype": "Message",
                          "idx": 1,
                          "__unedited": false,
                          "name_contact": e.name,
                          "audience": e.email
                        })
                    .toList(),
                "subject1": subject1,
                "upload_files": image,
                "message":
                    "<div class=\"ql-editor read-mode\"><p>${body} &nbsp;of message</p></div>"
              }),
              'action': 'Save'
            }));

        if (result?.statusCode == 200) {
          Fluttertoast.showToast(msg: "ثبت شد");
          return true;
        }
      } else {
        Fluttertoast.showToast(msg: "خطایی رخ داده است.");
      }
    } on DioException catch (e) {
      var msg = e.response?.data["_server_messages"];
      if (msg != null) {
        msg = jsonDecode(
            jsonDecode(utf8.decode(msg.toString().codeUnits)).toString());
      }
      showErrorToast(msg.toString());
      _logger.e(e);
    } catch (e) {
      showErrorToast(null);
    }
    return false;
  }
}
