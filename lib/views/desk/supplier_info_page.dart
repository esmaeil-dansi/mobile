import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/repo/shop_repo.dart';
import 'package:frappe_app/services/aut_service.dart';
import 'package:frappe_app/views/desk/desk_view.dart';
import 'package:frappe_app/widgets/form/CustomTextFormField.dart';
import 'package:frappe_app/widgets/form/custom_dropownbuttom_formField.dart';
import 'package:frappe_app/widgets/image_view.dart';
import 'package:frappe_app/widgets/new_from_widget.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class SupplierInfoPage extends StatelessWidget {
  final _autService = GetIt.I.get<AutService>();
  final _shopRepo = GetIt.I.get<ShopRepo>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _imagePath = "".obs;
    TextEditingController textEditingController = new TextEditingController();
    TextEditingController nameEditingController = new TextEditingController();
    return Scaffold(
      floatingActionButton: submitForm(() async {
        if (_imagePath.isNotEmpty) {
          if (_formKey.currentState?.validate() ?? false) {
            if (await _autService.submitSupplierInfo(
                image: _imagePath.value,
                cardNumber: textEditingController.text,
                name: nameEditingController.text)) {
              Get.offAll(DesktopView());
            }
          }
        } else {
          Fluttertoast.showToast(msg: "تصویر کارت ملی را وارد  کنید");
        }
      }),
      appBar: AppBar(
        title: Text("اطلاعات تامین کننده"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  textInputType: TextInputType.number,
                  label: "َشماره شبا",
                  textEditingController: textEditingController,
                  validator: "َشماره شبا خود را وارد کنید",
                ),
                SizedBox(
                  height: 20,
                ),
                ImageView(_imagePath, "عکس کارت ملی"),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: _shopRepo.getAll(),
                    builder: (c, s) {
                      return CustomDropdownButtonFormField(
                          label: "فروشکاه",
                          items: (s.data ?? []).map((e) => e.id).toList(),
                          onChange: (_) {
                            nameEditingController.text = _;
                          });
                    }),
                SizedBox(
                  height: 90,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
