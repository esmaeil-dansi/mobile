import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frappe_app/model/add_product_form_model.dart';
import 'package:frappe_app/model/agentInfo.dart';
import 'package:frappe_app/services/visit_service.dart';
import 'package:frappe_app/utils/date_mapper.dart';

import 'package:frappe_app/widgets/agent_info_widget.dart';
import 'package:frappe_app/widgets/app_sliver_app_bar.dart';
import 'package:frappe_app/widgets/constant.dart';
import 'package:frappe_app/widgets/date.dart';
import 'package:frappe_app/widgets/form/CustomTextFormField.dart';
import 'package:frappe_app/widgets/form/custom_dropownbuttom_formField.dart';
import 'package:frappe_app/widgets/image_view.dart';
import 'package:frappe_app/widgets/new_from_widget.dart';
import 'package:frappe_app/widgets/progressbar_wating.dart';
import 'package:frappe_app/widgets/select_location.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';

class ProductVisitReport extends StatefulWidget {
  bool isReport;
  int? time;
  ProductivityFormModel? addProductivityFormModel;

  ProductVisitReport(
      {this.addProductivityFormModel, this.time, this.isReport = false});

  @override
  State<ProductVisitReport> createState() => _AddPeriodicReportState();
}

class _AddPeriodicReportState extends State<ProductVisitReport> {
  int time = 0;
  late ProductivityFormModel model;

  @override
  void initState() {
    if (widget.addProductivityFormModel != null) {
      model = widget.addProductivityFormModel!;
      if (widget.isReport &&
          widget.addProductivityFormModel!.geolocation != null) {
        _latLng = widget.addProductivityFormModel!.geolocation!;
      } else {
        _latLng = LatLng(model.lat??0, model.lon??0);
      }

      _nationId.text = model.nationalId!;
      _fetchAgentInfo();
    } else {
      model = ProductivityFormModel();
    }
    time = widget.time ?? DateTime
        .now()
        .millisecondsSinceEpoch;
    super.initState();
  }

  final _visitService = GetIt.I.get<VisitService>();

  final _nationId = TextEditingController();

  LatLng? _latLng;
  final _formKey = GlobalKey<FormState>();

  Rxn<AgentInfo> agentInfo = Rxn();

  void _fetchAgentInfo() {
    this._visitService.getAgentInfo(_nationId.text).then((value) {
      if (value != null) {
        agentInfo.value = value;
        model.province = value.province;
        model.city = value.city;
        model.mobile = value.mobile;
        model.lastName = value.full_name;
        model.rahbar = value.rahbar;
        model.id = _nationId.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: widget.isReport
            ? SizedBox.shrink()
            : submitForm(() async {
          if (_formKey.currentState?.validate() ?? false) {
            if (_latLng != null) {
              model.lat = _latLng!.latitude;
              model.lon = _latLng!.longitude;
              FocusScope.of(context).requestFocus(new FocusNode());
              Progressbar.showProgress();
              var res = await _visitService.sendProductFrom(
                time: time,
                model: model,
              );
              if (res) {
                Get.back();
                Get.back();
              }
            } else {
              Fluttertoast.showToast(msg: "موقعیت مکانی را انتخاب کنید");
            }
          } else {
            Fluttertoast.showToast(msg: "فیلد های مورد نیاز را پر کنید");
          }
        }),
        appBar:
        widget.isReport ? null : appSliverAppBar("پرونده بهره وری جدید"),
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
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                              label: "شناسه",
                              textEditingController: _nationId,
                              maxLength: 10,
                              height: 80,
                              readOnly: widget.addProductivityFormModel != null,
                              onChanged: (_) {
                                model.nationalId = _;
                                if (_.length == 10) {
                                  _fetchAgentInfo();
                                }
                              },
                              textInputType: TextInputType.number,
                              value: _nationId.text),
                          SizedBox(
                            height: 10,
                          ),
                          Obx(() =>
                          agentInfo.value != null
                              ? agentInfoWidget(agentInfo.value!)
                              : SizedBox.shrink()),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            label: "تعداد راس دام",
                            textInputType: TextInputType.number,
                            value: (model.damCount ?? '').toString() ?? '',
                            onChanged: (_) {
                              model.damCount = int.parse(_);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomDropdownButtonFormField(
                            label: "نوع دام",
                            items: [
                              "سبک(بز و گوسفند)",
                              "سنگین(گاو و شتر)",
                              "طیور(مرغ و بوقلمون)",
                            ],
                            onChange: (_) {
                              model.damType = _;
                            },
                            value: model.damType,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                            isReport: widget.isReport,
                            date: model.antro1Date,
                            image: model.antro1Img,
                            count: model.antro1Doz,
                            status: model.antro1,
                            onCountChange: (_) {
                              model.antro1Doz = int.parse(_);
                            },
                            onDateChange: (_) {
                              model.antro1Date = _;
                            },
                            onImageChange: (_) {
                              model.antro1Img = _;
                            },
                            onStatusChange: (_) {
                              model.antro1 = _;
                            },
                            title:
                            'تزریق نوبت اول واکسن آنتروتوکسمی (باید در بهار باشد)',
                            dateLabel: 'تاریخ تزریق نوبت اول آنتروتوکسمی',
                            imagePickerLabel:
                            'تصویر تزریق نوبت اول آنتروتوکسمی',
                            countLabel: 'تعداد دوز مصرفی نوبت اول آنتروتوکسمی',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.antro2Date,
                              image: model.antro2Img,
                              count: model.antro2Doz,
                              status: model.antro2,
                              onCountChange: (_) {
                                model.antro2Doz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.antro2Date = _;
                              },
                              onImageChange: (_) {
                                model.antro2Img = _;
                              },
                              onStatusChange: (_) {
                                model.antro2 = _;
                              },
                              title:
                              'تزریق نوبت دوم واکسن آنتروتوکسمی (باید در بهار باشد)',
                              dateLabel: 'تاریخ تزریق نوبت دوم آنتروتوکسمی',
                              imagePickerLabel:
                              'تصویر تزریق نوبت دوم آنتروتوکسمی',
                              countLabel:
                              'تعداد دوز مصرفی نوبت دوم آنتروتوکسمی'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.sharbonDate,
                              image: model.sharbonImg,
                              count: model.sharbonDoz,
                              status: model.sharbon,
                              onCountChange: (_) {
                                model.sharbonDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.sharbonDate = _;
                              },
                              onImageChange: (_) {
                                model.sharbonImg = _;
                              },
                              onStatusChange: (_) {
                                model.sharbon = _;
                              },
                              title: 'تزریق واکسن شاربن(باید در بهار باشد)',
                              dateLabel: 'تاریخ تزریق شاربن',
                              imagePickerLabel: 'تصویر تزریق شاربن',
                              countLabel: 'تعداد دوز مصرفی شاربن'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.abeleDate,
                              image: model.abeleImg,
                              count: model.abeleDoz,
                              status: model.abele,
                              onCountChange: (_) {
                                model.abeleDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.abeleDate = _;
                              },
                              onImageChange: (_) {
                                model.abeleImg = _;
                              },
                              onStatusChange: (_) {
                                model.abele = _;
                              },
                              title: 'تزریق واکسن آبله(باید در بهار باشد)',
                              dateLabel: 'تاریخ تزریق آبله',
                              imagePickerLabel: 'تصویر تزریق آبله',
                              countLabel: 'تعداد دوز مصرفی آبله'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.brucellosisDate,
                              image: model.brucellosisImg,
                              count: model.brucellosisDoz,
                              status: model.brucellosis,
                              onCountChange: (_) {
                                model.brucellosisDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.brucellosisDate = _;
                              },
                              onImageChange: (_) {
                                model.brucellosisImg = _;
                              },
                              onStatusChange: (_) {
                                model.brucellosis = _;
                              },
                              title:
                              'تزریق واکسن بروسلوز (باید در بهار باشد)(بره ها، بزغاله ها و گوساله های ماده پای کل)',
                              dateLabel: 'تاریخ تزریق بروسلوز',
                              imagePickerLabel: 'تصویر تزریق بروسلوز',
                              countLabel: 'تعداد دوز مصرفی بروسلوز'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.sharbon1Date,
                              image: model.sharbon1Img,
                              count: model.sharbon1Doz,
                              status: model.sharbon1,
                              onCountChange: (_) {
                                model.sharbon1Doz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.sharbon1Date = _;
                              },
                              onImageChange: (_) {
                                model.sharbon1Img = _;
                              },
                              onStatusChange: (_) {
                                model.sharbon1 = _;
                              },
                              title:
                              'تزریق واکسن شاربن علامتی (باید در بهار باشد)',
                              dateLabel: 'تاریخ تزریق شاربن علامتی',
                              imagePickerLabel: 'تصویر تزریق شاربن علامتی',
                              countLabel: 'تعداد دوز مصرفی شاربن علامتی'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.taonDate,
                              image: model.taonImg,
                              count: model.taonDoz,
                              status: model.taon,
                              onCountChange: (_) {
                                model.taonDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.taonDate = _;
                              },
                              onImageChange: (_) {
                                model.taonImg = _;
                              },
                              onStatusChange: (_) {
                                model.taon = _;
                              },
                              title:
                              'تزریق واکسن طاعون نشخوارکنندگان کوچک (باید در تابستان باشد) و فقط مخصوص گله های دام سبک',
                              dateLabel: 'تاریخ تزریق طاعون',
                              imagePickerLabel: 'تصویر تزریق طاعون',
                              countLabel: 'تعداد دوز مصرفی طاعون'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.pasteuroseDate,
                              image: model.pasteuroseImg,
                              count: model.pasteuroseDoz,
                              status: model.pasteurose,
                              onCountChange: (_) {
                                model.pasteuroseDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.pasteuroseDate = _;
                              },
                              onImageChange: (_) {
                                model.pasteuroseImg = _;
                              },
                              onStatusChange: (_) {
                                model.pasteurose = _;
                              },
                              title:
                              'تزریق واکسن پاسترولوز گاوی (باید در تابستان باشد)',
                              dateLabel: 'تاریخ تزریق پاسترولوز گاوی',
                              imagePickerLabel: 'تصویر تزریق پاسترولوز گاوی',
                              countLabel: 'تعداد دوز مصرفی پاسترولوز گاوی'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.barfakiDate,
                              image: model.barfakiImg,
                              count: model.barfakiDoz,
                              status: model.barfaki,
                              onCountChange: (_) {
                                model.barfakiDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.barfakiDate = _;
                              },
                              onImageChange: (_) {
                                model.barfakiImg = _;
                              },
                              onStatusChange: (_) {
                                model.barfaki = _;
                              },
                              title:
                              'تزریق واکسن تب برفکی (باید در پاییز باشد)',
                              dateLabel: 'تاریخ تزریق تب برفکی',
                              imagePickerLabel: 'تصویر تزریق تب برفکی',
                              countLabel: 'تعداد دوز مصرفی تب برفکی'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.ghanghariaDate,
                              image: model.ghanghariaImg,
                              count: model.ghanghariaDoz,
                              status: model.ghangharia,
                              onCountChange: (_) {
                                model.ghanghariaDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.ghanghariaDate = _;
                              },
                              onImageChange: (_) {
                                model.ghanghariaImg = _;
                              },
                              onStatusChange: (_) {
                                model.ghangharia = _;
                              },
                              title:
                              'تزریق واکسن قانقاریای عفونی (باید در پاییز باشد)',
                              dateLabel: 'تاریخ تزریق قانقاریا',
                              imagePickerLabel: 'تصویر تزریق قانقاریا',
                              countLabel: 'تعداد دوز مصرفی قانقاریا'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.agalacciDate,
                              image: model.agalacciImg,
                              count: model.agalacciDoz,
                              status: model.agalacci,
                              onCountChange: (_) {
                                model.agalacciDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.agalacciDate = _;
                              },
                              onImageChange: (_) {
                                model.agalacciImg = _;
                              },
                              onStatusChange: (_) {
                                model.agalacci = _;
                              },
                              title:
                              'تزریق واکسن آگالاکسی (باید در زمستان باشد)',
                              dateLabel: 'تاریخ تزریق آگالاکسی',
                              imagePickerLabel: 'تصویر تزریق آگالاکسی',
                              countLabel: 'عداد دوز مصرفی آگالاکسی'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.iverDate,
                              image: model.iverImg,
                              count: model.iverDoz,
                              status: model.iver,
                              onCountChange: (_) {
                                model.iverDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.iverDate = _;
                              },
                              onImageChange: (_) {
                                model.iverImg = _;
                              },
                              onStatusChange: (_) {
                                model.iver = _;
                              },
                              title:
                              'خوراندن شربت ضدانگل نوبت اول (باید در بهار باشد)',
                              dateLabel: 'تاریخ خوراندن شربت ضدانگل نوبت اول',
                              imagePickerLabel:
                              'تصویر خوراندن شربت ضدانگل نوبت اول',
                              countLabel: 'تعداد دوز مصرفی ضدانگل نوبت اول'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.iver2Date,
                              image: model.iver2Img,
                              count: model.iver2Doz,
                              status: model.iver2,
                              onCountChange: (_) {
                                model.iver2Doz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.iver2Date = _;
                              },
                              onImageChange: (_) {
                                model.iver2Img = _;
                              },
                              onStatusChange: (_) {
                                model.iver2 = _;
                              },
                              title:
                              'خوراندن شربت ضدانگل نوبت دوم (باید در بهار باشد)',
                              dateLabel: 'تاریخ خوراندن شربت ضدانگل نوبت دوم',
                              imagePickerLabel:
                              'تصویر خوراندن شربت ضدانگل نوبت دوم',
                              countLabel: 'تعداد دوز مصرفی ضدانگل نوبت دوم'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.spraying1Date,
                              image: model.spraying1Img,
                              count: model.spraying1Doz,
                              status: model.spraying1,
                              onCountChange: (_) {
                                model.spraying1Doz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.spraying1Date = _;
                              },
                              onImageChange: (_) {
                                model.spraying1Img = _;
                              },
                              onStatusChange: (_) {
                                model.spraying1 = _;
                              },
                              title:
                              'انجام سم پاشی جایگاه نوبت اول (باید در بهار باشد)',
                              dateLabel: 'تاریخ انجام سم پاشی جایگاه نوبت اول',
                              imagePickerLabel:
                              'تصویر انجام سم پاشی جایگاه نوبت اول',
                              countLabel:
                              'تعداد دوز مصرفی سم پاشی جایگاه نوبت اول'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.spraying2Date,
                              image: model.spraying2Img,
                              count: model.spraying2Doz,
                              status: model.spraying2,
                              onCountChange: (_) {
                                model.spraying2Doz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.spraying2Date = _;
                              },
                              onImageChange: (_) {
                                model.spraying2Img = _;
                              },
                              onStatusChange: (_) {
                                model.spraying2 = _;
                              },
                              title:
                              'انجام سم پاشی دام نوبت اول (باید در بهار باشد)',
                              dateLabel: 'تاریخ انجام سم پاشی دام نوبت اول',
                              imagePickerLabel:
                              'تصویر انجام سم پاشی دام نوبت اول',
                              countLabel:
                              'تعداد دوز مصرفی سم پاشی دام نوبت اول'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.iromactionDate,
                              image: model.iromactionImg,
                              count: model.iromactionDoz,
                              status: model.iromaction,
                              onCountChange: (_) {
                                model.iromactionDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.iromactionDate = _;
                              },
                              onImageChange: (_) {
                                model.iromactionImg = _;
                              },
                              onStatusChange: (_) {
                                model.iromaction = _;
                              },
                              title: 'تزریق آیورمکتین (باید در پاییز باشد)',
                              dateLabel: 'تاریخ تزریق آیورمکتین',
                              imagePickerLabel: 'تصویر تزریق آیورمکتین',
                              countLabel: 'تعداد دوز مصرفی آیورمکتین'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.froblokDate,
                              image: model.froblokImg,
                              count: model.froblokDoz,
                              status: model.froblok,
                              onCountChange: (_) {
                                model.froblokDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.froblokDate = _;
                              },
                              onImageChange: (_) {
                                model.froblokImg = _;
                              },
                              onStatusChange: (_) {
                                model.froblok = _;
                              },
                              title:
                              'خوراندن قرص فروبلوک(آجر معدنی/ مکمل ویتامین معدنی) (باید در زمستان باشد)',
                              dateLabel: 'تاریخ خوراندن قرص فروبلوک',
                              imagePickerLabel: 'تصویر خوراندن قرص فروبلوک',
                              countLabel: 'تعداد دوز مصرفی قرص فروبلوک'),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.antiparaTabDate,
                              image: model.antiparaTabImg,
                              count: model.antiparaTabDoz,
                              status: model.antiparaTab,
                              onCountChange: (_) {
                                model.antiparaTabDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.antiparaTabDate = _;
                              },
                              onImageChange: (_) {
                                model.antiparaTabImg = _;
                              },
                              onStatusChange: (_) {
                                model.antiparaTab = _;
                              },
                              title: 'خوراندن قرص ضدانگل',
                              dateLabel: 'تاریخ خوراندن قرص ضدانگل',
                              imagePickerLabel: 'تصویر خوراندن قرص ضدانگل',
                              countLabel: 'تعداد دوز مصرفی قرص ضدانگل'),
                          SizedBox(
                            height: 10,
                          ),
                          CustomDropdownButtonFormField(
                              label: "نام قرص ضد انگل",
                              required: false,
                              value: model.antiparaTabName,
                              items: [
                                "آلیندازول",
                                "رافوکساناید",
                                "نیکوزاماید",
                                "پرازی کوانتل",
                                "کلوزانتل"
                              ],
                              onChange: (_) {
                                model.antiparaTabName = _;
                              }),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.pashmDate,
                              image: model.pashmImg,
                              count: 0,
                              status: model.pashm,
                              onCountChange: (_) {
                                // model.spraying2Doz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.pashmDate = _;
                              },
                              onImageChange: (_) {
                                model.pashmImg = _;
                              },
                              onStatusChange: (_) {
                                model.pashm = _;
                              },
                              title:
                              'انجام پشم چینی (مناطق گرمسیری) (باید در بهار باشد)',
                              dateLabel: 'تاریخ انجام پشم چینی (مناطق گرمسیری)',
                              imagePickerLabel:
                              'تصویر انجام پشم چینی (مناطق گرمسیری)',
                              countLabel: ''),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.ghochDate,
                              image: model.ghochImg,
                              count: 0,
                              status: model.ghoch,
                              onCountChange: (_) {
                                // model.spraying2Doz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.ghochDate = _;
                              },
                              onImageChange: (_) {
                                model.ghochImg = _;
                              },
                              onStatusChange: (_) {
                                model.ghoch = _;
                              },
                              title: 'تقویت قوچ-ها (باید در بهار باشد)',
                              dateLabel: 'تاریخ تقویت قوچ-ها',
                              imagePickerLabel: 'تصویر تقویت قوچ-ها',
                              countLabel: ''),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.pashm2Date,
                              image: model.pashm2Img,
                              count: 0,
                              status: model.pashm2,
                              onCountChange: (_) {
                                // model.pa = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.pashm2Date = _;
                              },
                              onImageChange: (_) {
                                model.pashm2Img = _;
                              },
                              onStatusChange: (_) {
                                model.pashm2 = _;
                              },
                              title:
                              'انجام پشم چینی (مناطق سردسیری) (باید در تابستان باشد)',
                              dateLabel: 'تاریخ انجام پشم چینی (مناطق سردسیری)',
                              imagePickerLabel:
                              'تصویر انجام پشم چینی (مناطق سردسیری)',
                              countLabel: ''),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.ghochandaziDate,
                              image: model.ghochandaziImg,
                              count: 0,
                              status: model.ghochandazi,
                              onCountChange: (_) {
                                // model.ghanghariaDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.ghochandaziDate = _;
                              },
                              onImageChange: (_) {
                                model.ghochandaziImg = _;
                              },
                              onStatusChange: (_) {
                                model.ghochandazi = _;
                              },
                              title: 'قوچ اندازی (باید در تابستان باشد)',
                              dateLabel: 'تاریخ قوچ اندازی',
                              imagePickerLabel: 'تصویر قوچ اندازی',
                              countLabel: ''),
                          SizedBox(
                            height: 10,
                          ),
                          BuildCommonWidget(
                              isReport: widget.isReport,
                              date: model.somchiniDate,
                              image: model.somchiniImg,
                              count: 0,
                              status: model.somchini,
                              onCountChange: (_) {
                                // model.ghanghariaDoz = int.parse(_);
                              },
                              onDateChange: (_) {
                                model.somchiniDate = _;
                              },
                              onImageChange: (_) {
                                model.somchiniImg = _;
                              },
                              onStatusChange: (_) {
                                model.somchini = _;
                              },
                              title: 'سم چینی سالیانه (باید در تابستان باشد)',
                              dateLabel: 'تاریخ سم چینی سالیانه',
                              imagePickerLabel: 'تصویر سم چینی سالیانه',
                              countLabel: ''),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            label: "تعداد زایمان های طبیعی",
                            textInputType: TextInputType.number,
                            value: model.zayeman != null
                                ? (model.zayeman!.toString())
                                : '0',
                            onChanged: (_) {
                              model.zayeman = int.parse(_);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            label: "وزن هر بره پس از تولد",
                            textInputType: TextInputType.number,
                            value: model.zayemanWht != null
                                ? (model.zayemanWht!.toString())
                                : '0',
                            onChanged: (_) {
                              model.zayemanWht = int.parse(_);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            label: "وزن بره به هنگام از شیرگیری",
                            textInputType: TextInputType.number,
                            value: model.zayemanShir != null
                                ? (model.zayemanShir!.toString())
                                : '0',
                            onChanged: (_) {
                              model.zayemanShir = int.parse(_);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            label: "تعداد سقط جنین و مرده زایی",
                            textInputType: TextInputType.number,
                            value: model.seght != null
                                ? (model.seght!.toString())
                                : '0',
                            onChanged: (_) {
                              model.seght = int.parse(_);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            label: "فاصله زایش ها",
                            textInputType: TextInputType.number,
                            value: model.zayesh != null
                                ? (model.zayesh!.toString())
                                : '0',
                            onChanged: (_) {
                              model.zayesh = int.parse(_);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SelectLocation(
                              readOnly: widget.addProductivityFormModel != null,
                              latLng: _latLng,
                              onSelected: (_) {
                                _latLng = _;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class BuildCommonWidget extends StatefulWidget {
  String dateLabel;
  String? date;
  int? count;
  String? image;
  String? status;
  String title;
  bool isReport;
  String countLabel;
  String imagePickerLabel;
  Function(String) onStatusChange;
  Function(String) onDateChange;
  Function(String) onCountChange;
  Function(String) onImageChange;

  BuildCommonWidget({
    required this.title,
    this.isReport = false,
    required this.dateLabel,
    required this.imagePickerLabel,
    required this.onStatusChange,
    required this.onDateChange,
    required this.onCountChange,
    required this.onImageChange,
    required this.date,
    required this.status,
    required this.image,
    required this.count,
    this.countLabel = "",
  });

  @override
  State<BuildCommonWidget> createState() => _BuildCommonWidgetState();
}

class _BuildCommonWidgetState extends State<BuildCommonWidget> {
  Rx<String> imagePath = "".obs;

  Rx<bool> have = false.obs;
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    if (widget.date != null) {
      _dateController.text = DateMapper.convert(widget.date!);
    }
    if (!widget.isReport) {
      imagePath.listen((p0) {
        widget.onImageChange(p0);
      });
    }

    have.value = widget.status == "بله";
    imagePath.value = widget.image ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: GRADIANT_COLOR),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all()),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(widget.title, style: TextStyle()),
                CustomDropdownButtonFormField(
                    value: widget.status ?? "خیر",
                    label: "",
                    items: ["بله", "خیر"],
                    onChange: (_) {
                      widget.onStatusChange(_);
                      if (_ == "بله") {
                        have.value = true;
                      } else {
                        have.value = false;
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                Obx(() =>
                have.isTrue
                    ? Column(
                  children: [
                    SizedBox(
                      height: 70,
                      child: TextField(
                        onTap: () =>
                            selectDate((_) {
                              widget.onDateChange(_);
                            }, _dateController),
                        readOnly: true,
                        canRequestFocus: false,
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: widget.dateLabel,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageView(imagePath, widget.imagePickerLabel,
                        defaultValue: imagePath.value,
                        isNetWorkImage: widget.isReport,
                        canReplace: widget.image == null,
                        labelFontSize: 18),
                    SizedBox(
                      height: 10,
                    ),
                    if (widget.countLabel.isNotEmpty)
                      CustomTextFormField(
                        label: widget.countLabel,
                        value: widget.count != null
                            ? widget.count.toString()
                            : "",
                        textInputType: TextInputType.number,
                        onChanged: (_) {
                          widget.onCountChange(_);
                        },
                      )
                  ],
                )
                    : SizedBox.shrink())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
