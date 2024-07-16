import 'package:frappe_app/model/SortKey.dart';

class VisitFilters {
  static List<SortKey> productVisitSortKeys() => [
        SortKey(
            title: "آخرین بروزرسانی", key: "`tabProductivity File`.`modified`"),
        SortKey(title: "شناسه", key: "`tabProductivity File`.`id`"),
        SortKey(title: "تاریخ ایجاد", key: "`tabProductivity File`.`creation`"),
        SortKey(title: "مکان یابی", key: "`tabProductivity File`.`location`"),
        SortKey(
            title: "تعداد راس دام", key: "`tabProductivity File`.`dam_count`"),
      ];

  static List<SortKey> initVisitSortKeys() => [
        SortKey(title: "آخرین بروزرسانی", key: "`tabInitial Visit`.`modified`"),
        SortKey(title: "شناسه", key: "`tabInitial Visit`.`name`"),
        SortKey(title: "تاریخ ایجاد", key: "`tabInitial Visit`.`creation`"),
        SortKey(title: "مکان یابی", key: "`tabInitial Visit`.`geolocation`")
      ];

  static List<SortKey> periodicVisitSortKeys() => [
        SortKey(
            title: "آخرین بروزرسانی", key: "`tabPeriodic visits`.`modified`"),
        SortKey(title: "شناسه", key: "`tabPeriodic visits`.`name`"),
        SortKey(title: "تاریخ ایجاد", key: "`tabPeriodic visits`.`creation`"),
        SortKey(title: "مکان یابی", key: "`tabPeriodic visits`.`geolocation`")
      ];

  static List<SortKey> vetVisitSortKeys() => [
// SortKey(title: "موقعیت محلی", key: "`tabVet Visit`.`geolocation`"),
        SortKey(title: "آخرین بروزرسانی", key: "`tabVet Visit`.`modified`"),
        SortKey(title: "شناسه", key: "`tabVet Visit`.`name`"),
        SortKey(title: "تعداد", key: "`tabVet Visit`.`number`"),
        SortKey(title: "تاریخ ایجاد", key: "`tabVet Visit`.`creation`"),
      ];
}
