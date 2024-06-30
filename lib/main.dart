import 'package:flutter/material.dart';
import 'package:frappe_app/db/advertisement.dart';
import 'package:frappe_app/db/dao/advertisement_dao.dart';
import 'package:frappe_app/db/dao/file_info_dao.dart';
import 'package:frappe_app/db/dao/request_dao.dart';
import 'package:frappe_app/db/file_info.dart';
import 'package:frappe_app/db/request.dart';
import 'package:frappe_app/db/request_statuse.dart';
import 'package:frappe_app/repo/RequestRepo.dart';
import 'package:frappe_app/repo/file_repo.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/services/file_service.dart';
import 'package:frappe_app/services/http_service.dart';
import 'package:frappe_app/services/message_service.dart';
import 'package:frappe_app/services/shop_service.dart';
import 'package:frappe_app/services/user_service.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter("Chopo/db");
  Hive.registerAdapter(RequestAdapter());
  Hive.registerAdapter(RequestStatusAdapter());
  Hive.registerAdapter(AdvertisementAdapter());
  Hive.registerAdapter(FileInfoAdapter());

  initServicesAndRepo();

  runApp(MyApp());
}

void initServicesAndRepo() {
  GetIt.instance.registerSingleton<AdvertisementDao>(AdvertisementDao());
  GetIt.instance.registerSingleton<AutService>(AutService());
  GetIt.instance.registerSingleton<FileInfoDao>(FileInfoDao());
  GetIt.instance.registerSingleton<FileRepo>(FileRepo());
  GetIt.instance.registerSingleton<HttpService>(HttpService());
  GetIt.instance.registerSingleton<FileService>(FileService());
  GetIt.instance.registerSingleton<RequestDao>(RequestDao());
  GetIt.instance.registerSingleton<RequestRepo>(RequestRepo());
  GetIt.instance.registerSingleton<MessageService>(MessageService());
  GetIt.instance.registerSingleton<VisitService>(VisitService());
  GetIt.instance.registerSingleton<ShopService>(ShopService());
  GetIt.instance.registerSingleton<UserService>(UserService());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return App();
  }
}
