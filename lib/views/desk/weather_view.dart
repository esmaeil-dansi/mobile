import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_it/get_it.dart';

import '../../methods.dart';
import '../../services/aut_service.dart';
import '../../widgets/app_sliver_app_bar.dart';

class WeatherView extends StatefulWidget {
  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final _autService = GetIt.I.get<AutService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appSliverAppBar("آب و هوا"),
      body: Padding(
        padding:
        const EdgeInsets.symmetric(vertical: 13, horizontal: 3),
        child: Obx(() => _autService.weathers.isNotEmpty
            ? SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _autService.weathers
                .map((element) => Container(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                mainAxisAlignment:
                MainAxisAlignment.start,
                children: [
                  Icon(
                    getWeatherDescription(element.main,
                        element.description)
                        .$2,
                    size: 30,
                    color: getWeatherDescription(
                        element.main,
                        element.description)
                        .$3,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "\tC",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(
                                left: 30),
                            child: Icon(
                              Icons.circle_outlined,
                              size: 7,
                            ),
                          ),
                          Text(
                            element.temp.toString(),
                            style: TextStyle(
                                fontSize: 9.5),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    getWeatherDescription(
                      element.main,
                      element.description,
                    ).$1,
                    style: TextStyle(fontSize: 10),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(element.w),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        element.date,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ))
                .toList(),
          ),
        )
            : SizedBox(
          height: 90,
        )),
      )
    );
  }
}