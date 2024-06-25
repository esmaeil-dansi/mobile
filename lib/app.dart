import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/views/desk/desk_view.dart';
import 'package:frappe_app/views/login/login_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _checkIfLoggedIn() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool("login") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetMaterialApp(
        textDirection: TextDirection.rtl,
        builder: EasyLoading.init(),
        theme: ThemeData(
          fontFamily: 'B nanzanin.ttf',
        ),
        debugShowCheckedModeBanner: false,
        title: "چوپو",
        localizationsDelegates: [
          FormBuilderLocalizations.delegate,
        ],
        home: FutureBuilder(
          future: _checkIfLoggedIn(),
          builder: (c, s) {
            if (s.hasData && s.data != null) {
              return s.data! ? DesktopView() : Login();
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
