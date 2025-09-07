import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class SelectLocation extends StatelessWidget {
  Function(LatLng) onSelected;

  LatLng? latLng;
  bool readOnly;

  SelectLocation(
      {super.key,
      required this.onSelected,
      this.latLng,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'مکان یابی'.tr,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          LocationWidget(
            onSelected: onSelected,
            latLng: latLng,
            readOnly: readOnly,
          ),
          const SizedBox(
            height: 7,
          ),
        ],
      ),
    );
  }
}

class LocationWidget extends StatefulWidget {
  Function(LatLng) onSelected;
  LatLng? latLng;
  bool readOnly;

  LocationWidget(
      {required this.onSelected,
      this.latLng,
      this.readOnly = false,
      super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  MapController mapController = MapController();

  var latLng = const LatLng(0, 0).obs;

  @override
  void initState() {
    if (widget.latLng != null) {
      latLng.value = widget.latLng!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
    latLng.value.longitude != 0
        ? Stack(
      fit: StackFit.passthrough,
      children: [
        SizedBox(
          height: 150,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              maxZoom: 17,
              zoom: 15,
              minZoom: 7,
              center: latLng.value,
              enableScrollWheel: true,
            ),
            children: [
              TileLayer(
                tileProvider: NetworkTileProvider(),
                urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: latLng.value,
                    builder: (_) {
                      return GestureDetector(
                        child: Icon(
                          Icons.location_pin,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .error,
                          size: 33,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!widget.readOnly)
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(50)),
              child: IconButton(
                onPressed: () {
                  AttachLocation(
                      onSelected: (_) {
                        latLng.value = _;
                        widget.onSelected(_);
                        mapController.move(latLng.value, 14);
                      },
                      selectedLocation: latLng.value)
                      .showLocation();
                },
                icon: const Icon(
                  Icons.change_circle_outlined,
                  color: Colors.yellowAccent,
                  size: 28,
                ),
              ),
            ),
          )
      ],
    )
        : GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        AttachLocation(onSelected: (_) {
          latLng.value = _;
          widget.onSelected(_);
        }).showLocation();
      },
      child: Column(
        children: [
          const Icon(Icons.location_on),
          Text("برای مکان یابی کلیک کنید".tr)
        ],
      ),
    ));
  }
}

class AttachLocation {
  LatLng? selectedLocation;
  final Function(LatLng) onSelected;

  AttachLocation({required this.onSelected, this.selectedLocation});

  void showLocation() =>
      Get.bottomSheet(
        selectedLocation != null
            ? location(selectedLocation!)
            : FutureBuilder<LocationPermission>(
          future: Geolocator.requestPermission(),
          builder: (context, havePermission) {
            if (havePermission.hasData && havePermission.data != null) {
              return FutureBuilder<Position>(
                future: Geolocator.getCurrentPosition(),
                builder: (c, position) {
                  if (position.hasData && position.data != null) {
                    return location(LatLng(position.data!.latitude,
                        position.data!.longitude));
                  } else {
                    return Container(
                      color: Colors.white70,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              );
            } else {
              return Container(
                  color: Colors.white70,
                  child:
                  const Center(child: CircularProgressIndicator()));
            }
          },
        ),
      );

  Widget location(LatLng latLng) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        height: MediaQuery
            .of(Get.context!)
            .size
            .height / 2,
        child: PointToLatLngPage(
          onSelected: onSelected,
          latlng: latLng,
        ),
      );
}

class PointToLatLngPage extends StatefulWidget {
  final LatLng latlng;
  final Function(LatLng) onSelected;

  const PointToLatLngPage(
      {Key? key, required this.latlng, required this.onSelected})
      : super(key: key);

  @override
  PointToLatlngPage createState() {
    return PointToLatlngPage();
  }
}

class PointToLatlngPage extends State<PointToLatLngPage> {
  final MapController mapController = MapController();
  final pointSize = 20.0;
  final pointY = 150.0;
  late LatLng currentLocation;
  late LatLng pointerLocation;
  Position? userCurrentLocation;

  @override
  void initState() {
    _getLocation();
    super.initState();
    currentLocation = widget.latlng;
    pointerLocation = currentLocation;
  }

  void _getLocation() async {
    userCurrentLocation = await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.surfaceVariant,
      body: ListView(
        shrinkWrap: true,
        children: [
          LimitedBox(
            maxHeight: MediaQuery.of(context).size.height / 2,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    maxZoom: 17,
                    zoom: 16,
                    minZoom: 7,
                    onMapEvent: (event) {
                      updatePoint(null, context);
                    },
                    center: pointerLocation,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          height: 40,
                          width: 40,
                          point: currentLocation,
                          builder: (_) {
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // borderRadius: BorderRadius.circular(48.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue,
                                    blurRadius: 20.0,
                                  )
                                ],
                              ),
                              child: Container(
                                width: 40,
                                height: 70,
                                // padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                  color: Colors.blue,
                                ),
                              ),
                            );
                          },
                        ),
                        Marker(
                          point: pointerLocation,
                          builder: (_) {
                            return GestureDetector(
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 50,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            pointerLocation = currentLocation;
                            mapController.move(pointerLocation, 14);
                          },
                          icon: const Icon(
                            Icons.my_location,
                            color: Colors.blue,
                            size: 36,
                          ),
                          color: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.blue,
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () async {
                            if (await distance(pointerLocation.latitude,
                                pointerLocation.longitude)) {
                              widget.onSelected(pointerLocation);
                              Get.back();
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "حداکثر فاصله مکان انتخاب شده با موقعیت فعلی شما یاید 400 متر باشد.",
                                  backgroundColor: Colors.red);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updatePoint(MapEvent? event, BuildContext context) {
    final pointX = _getPointX(context);

    setState(() {
      final newLocation =
          mapController.pointToLatLng(CustomPoint(pointX, pointY));
      pointerLocation = newLocation;
    });
  }

  Future<bool> distance(double lat2, double lon2) async {
    const r = 6371; // km
    const p = pi / 180;
    if (userCurrentLocation == null) {
      userCurrentLocation = await Geolocator.getCurrentPosition();
    }

    var a = 0.5 -
        cos((lat2 - userCurrentLocation!.latitude) * p) / 2 +
        cos(userCurrentLocation!.latitude * p) *
            cos(lat2 * p) *
            (1 - cos((lon2 - userCurrentLocation!.longitude) * p)) /
            2;

    return (2 * r * asin(sqrt(a))) * 1000 < 400;
  }

  double _getPointX(BuildContext context) {
    return MediaQuery.of(context).size.width / 2;
  }
}
