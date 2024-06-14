import 'package:frappe_app/db/dao/request_dao.dart';
import 'package:frappe_app/db/request.dart';
import 'package:frappe_app/db/request_statuse.dart';
import 'package:frappe_app/repo/RequestRepo.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/file_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/services/message_service.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

final locator = GetIt.instance;

const bool USE_FAKE_IMPLEMENTATION = false;

@injectableInit
void setupLocator() {
  // hive
  Hive.registerAdapter(RequestAdapter());
  Hive.registerAdapter(RequestStatusAdapter());
  //db & service
  GetIt.I.registerSingleton<RequestDao>(RequestDao());
  GetIt.I.registerSingleton<RequestRepo>(RequestRepo());
  GetIt.I.registerSingleton<AutService>(AutService());
  GetIt.I.registerSingleton<HttpService>(HttpService());
  GetIt.I.registerSingleton<FileService>(FileService());
  GetIt.I.registerSingleton<MessageService>(MessageService());
  GetIt.I.registerSingleton<VisitService>(VisitService());

}
