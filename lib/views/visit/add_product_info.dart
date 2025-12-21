import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/widgets/form/CustomTextFormField.dart';
import 'package:frappe_app/widgets/image_view.dart';
import 'package:frappe_app/widgets/new_from_widget.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:frappe_app/widgets/select_location.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import '../../model/add_product_info_req.dart';
import '../../widgets/app_sliver_app_bar.dart';

class AddProductInfoReport extends StatefulWidget {
  AddProductInfoReq? addProductInfoReq;
  int? time;

  AddProductInfoReport({this.addProductInfoReq, this.time, super.key});

  @override
  State<AddProductInfoReport> createState() => _AddProductInfoReportState();
}

class _AddProductInfoReportState extends State<AddProductInfoReport> {
  late AddProductInfoReq model;

  @override
  void initState() {
    if (widget.addProductInfoReq != null) {
      model = widget.addProductInfoReq!;
      _imagePath.value = widget.addProductInfoReq!.imageApp!;
      _latLng.value = LatLng(model.lat!, model.lat!);
    } else {
      model = AddProductInfoReq(password: "", username: "");
      this.time = widget.time ?? DateTime.now().millisecondsSinceEpoch;
    }

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  var time = 0;
  Rxn<AgentInfo> agentInfo = Rxn();
  Rxn<LatLng> _latLng = Rxn();
  final _visitService = GetIt.I.get<VisitService>();
  final _imagePath = "".obs;

  String office = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: submitForm(() async {
        if (widget.addProductInfoReq != null) {
          await _submit(context);
        } else {
          if (_formKey.currentState?.validate() ?? false) {
            if (_latLng.value != null) {
              model.lon = _latLng.value!.longitude;
              model.lat = _latLng.value!.latitude;
              model.imageApp = _imagePath.value;

              if (model.imageApp == null || model.imageApp!.isEmpty) {
                Fluttertoast.showToast(msg: "تصویر را وارد  کنید");
              } else {
                await _submit(context);
              }
            } else {
              Fluttertoast.showToast(msg: "موقعیت مکانی را انتخاب کنید");
            }
          } else {
            Fluttertoast.showToast(msg: "فیلد های مورد نیاز را پر کنید");
          }
        }
      }),
      appBar: appSliverAppBar("اضافه کردن بازدید"),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Container(
            margin: EdgeInsets.only(left: 7, right: 7, top: 9, bottom: 90),
            decoration: BoxDecoration(
                border: Border.all(),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CustomTextFormField(
                      label: "کد ملی",
                      // textEditingController: _nationId,
                      maxLength: 10,
                      value: model.nationalId ?? '',
                      // readOnly: widget.addInitialVisitFormModel != null,
                      height: 80,
                      onChanged: (_) {
                        model.nationalId = _;
                      },
                      textInputType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageView(
                      _imagePath,
                      "تصویر بازدید",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SelectLocation(
                        readOnly: false,
                        latLng: model.lon != null
                            ? LatLng(model.lat!, model.lon!)
                            : _latLng.value,
                        onSelected: (_) {
                          _latLng.value = _;
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    Progressbar.showProgress();
    var res = await _visitService.SaveNewProductInfo(
      time: time,
      agentInfo: agentInfo.value ?? AgentInfo(),
      model: model,
    );
    if (res) {
      Get.back();
      Get.back();
    }
  }
}
