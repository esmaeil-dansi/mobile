import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../db/dao/price_dao.dart';
import '../../widgets/app_sliver_app_bar.dart';
import '../../widgets/constant.dart';

class PricesView extends StatefulWidget {
  @override
  State<PricesView> createState() => _PricesViewState();
}

class _PricesViewState extends State<PricesView> {
  final _priceDao = GetIt.I.get<PriceAvgDao>();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: appSliverAppBar("قیمت ها"),
        body:  SingleChildScrollView(
          child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 300,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        height: 300,
                        width: width + 20,
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1000),
                            child: Container(
                              child: SvgPicture.asset(
                                'assets/icons/money.svg', // مسیر فایل SVG شما
                                height: 200.0,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
             StreamBuilder<PriceInfo?>(
                stream: _priceDao.watch(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    var info = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildReport(
                                  "گوسفند داشتی(راس)",
                                  info.gosfand.toString(),
                                  info.dosfandD,
                                ),
                                _buildReport(
                                  "گاو شیری(راس)",
                                  info.gov.toString(),
                                  info.govD,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildReport("شتر پرواری(نفر)",
                                    info.shotor.toString(), info.shotorD),
                                _buildReport("قیمت جو(کیلوگرم)",
                                    info.go.toString(), info.goD),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "*",
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                SizedBox(
                                  width: Get.width*0.9,
                                  child: Text(
                                    "منبع میانگین قیمت ها شرکت گسترش توسعه گری پردیس می باشد.",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),

    ],
    )
        )
    );
  }
  Widget _buildReport(String s, String count, double d) {
    return Container(
      height: 76,
      width: 162,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: GRADIANT_COLOR,
        ),
        borderRadius: BorderRadius.circular(10),
        // border: Border.all()
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          height: 80,
          // width: Get.width * 0.43,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(s, style: TextStyle(fontSize: 11, color: Colors.black54)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _splitPrice(count.toString()),
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                if (d != 0.0)
                  Row(
                    children: [
                      Text(
                          "%" +
                              d
                                  .abs()
                                  .toString()
                                  .substring(0, min(d.toString().length, 6)),
                          style: TextStyle(fontSize: 8)),
                      if (d != 0)
                        if (d > 0)
                          Icon(
                            Icons.trending_up,
                            color: Colors.blue,
                            size: 11,
                          )
                        else
                          Icon(
                            Icons.trending_down,
                            color: Colors.red,
                            size: 11,
                          ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("از دیروز", style: TextStyle(fontSize: 8)),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
  String _splitPrice(String t) {
    var s = t.split('').reversed.toList();
    List<List<String>> sf = [];
    var j = 0;
    int start = 0;
    while (j < s.length) {
      sf.add(s.sublist(start, min(start + 3, t.length)).reversed.toList());
      start = start + 3;
      j = j + 3;
    }
    sf = sf.reversed.toList();
    String sr = "";
    for (int i = 0; i < sf.length; i++) {
      sr = sr + sf[i].join("");
      if (sf.length - i != 1) {
        sr = sr + ",";
      }
    }
    return sr;
  }
}
