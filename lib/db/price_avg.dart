import 'package:frappe_app/utils/constants.dart';
import 'package:hive/hive.dart';

part 'price_avg.g.dart';

@HiveType(typeId: PRICE_ADG_HIVE_ID)
class PriceAvg {
  @HiveField(0)
  int shotor;

  @HiveField(1)
  int gov;

  @HiveField(2)
  int go;

  @HiveField(3)
  int gosfand;

  PriceAvg({
    required this.shotor,
    required this.go,
    required this.gosfand,
    required this.gov,
  });
}
