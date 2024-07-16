import 'dart:async';

import 'package:frappe_app/db/price_avg.dart';
import 'package:hive/hive.dart';

class PriceAvgDao {
  String main = "MAIN";
  String old = "OLD";

  Future<Box<PriceAvg>> _open() async {
    try {
      return Hive.openBox<PriceAvg>(_key());
    } catch (e) {
      await Hive.deleteBoxFromDisk(_key());
      return Hive.openBox<PriceAvg>(_key());
    }
  }

  Future<void> save(PriceAvg price) async {
    var box = await _open();
    var oldPrice = await box.get(main);
    box.put(main, price);
    if (oldPrice != null) {
      if (oldPrice.go != price.go ||
          oldPrice.shotor != price.shotor ||
          oldPrice.go != price.go ||
          oldPrice.gosfand != price.gosfand) {
        box.put(old, oldPrice);
      }
    }
  }

  Future<PriceAvg?> getMainPrice() async {
    try {
      var box = await _open();
      return box.get(main);
    } catch (e) {
      return null;
    }
  }

  Stream<PriceInfo?> watch() async* {
    var box = await _open();
    yield convertPrice(box.get(main), box.get(old));
    yield* box
        .watch()
        .map((event) => convertPrice(box.get(main), box.get(old)));
  }

  String _key() => "price";

  PriceInfo? convertPrice(PriceAvg? newPrice, PriceAvg? oldPrice) {
    try {
      if (newPrice == null && oldPrice == null) {
        return null;
      }
      if (newPrice != null && oldPrice == null) {
        return PriceInfo(
            go: newPrice.go,
            gov: newPrice.gov,
            shotor: newPrice.shotor,
            gosfand: newPrice.gosfand,
            goD: 0,
            govD: 0,
            shotorD: 0,
            dosfandD: 0);
      }
      if (newPrice == null && oldPrice != null) {
        return PriceInfo(
            go: oldPrice.go,
            gov: oldPrice.gov,
            shotor: oldPrice.shotor,
            gosfand: oldPrice.gosfand,
            goD: 0,
            govD: 0,
            shotorD: 0,
            dosfandD: 0);
      } else {
        return PriceInfo(
            go: newPrice!.go,
            gov: newPrice.gov,
            shotor: newPrice.shotor,
            gosfand: newPrice.gosfand,
            goD: d(newPrice.go, oldPrice!.go),
            govD: d(newPrice.gov, oldPrice.gov),
            shotorD: d(newPrice.shotor, oldPrice.shotor),
            dosfandD: d(newPrice.gosfand, oldPrice.gosfand));
      }
    } catch (e) {
      return null;
    }
  }

  double d(int n, int o) {
    return ((n - o) / o) * 100;
  }
}

class PriceInfo {
  int go;
  int gov;
  int shotor;
  int gosfand;
  double goD;
  double govD;
  double shotorD;
  double dosfandD;

  PriceInfo(
      {required this.go,
      required this.gov,
      required this.shotor,
      required this.gosfand,
      required this.goD,
      required this.govD,
      required this.shotorD,
      required this.dosfandD});
}
