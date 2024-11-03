import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/utils/SharedPreferenceHelper.dart';
import 'package:frappe_app/views/desk/desk_view.dart';
import 'package:frappe_app/views/login/login_page.dart';
import 'package:frappe_app/views/login/user_info.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
  }

  var _shared = GetIt.I.get<SharedPreferencesHelper>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetMaterialApp(
        textDirection: TextDirection.rtl,
        builder: EasyLoading.init(),
        theme: ThemeData(
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Estedad-VF',
            textTheme: TextTheme()),
        debugShowCheckedModeBanner: false,
        title: "چوپو",
        localizationsDelegates: [
          FormBuilderLocalizations.delegate,
        ],
        home: _shared.isLogin() ? DesktopView() : Login(),
      ),
    );
  }
}
