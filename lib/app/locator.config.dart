// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:frappe_app/services/connectivity_service.dart' as _i7;
import 'package:frappe_app/services/storage_service.dart' as _i15;
import 'package:frappe_app/views/awesome_bar/awesome_bar_viewmodel.dart' as _i6;
import 'package:frappe_app/views/form_view/bottom_sheets/assignees/assignees_bottom_sheet_viewmodel.dart'
    as _i5;
import 'package:frappe_app/views/form_view/bottom_sheets/attachments/add_attachments_bottom_sheet_viewmodel.dart'
    as _i3;
import 'package:frappe_app/views/form_view/bottom_sheets/attachments/view_attachments_bottom_sheet_viewmodel.dart'
    as _i17;
import 'package:frappe_app/views/form_view/bottom_sheets/reviews/add_review_bottom_sheet_viewmodel.dart'
    as _i4;
import 'package:frappe_app/views/form_view/bottom_sheets/reviews/view_reviews_bottom_sheet_viewmodel.dart'
    as _i18;
import 'package:frappe_app/views/form_view/bottom_sheets/share/share_bottom_sheet_viewmodel.dart'
    as _i13;
import 'package:frappe_app/views/form_view/bottom_sheets/tags/tags_bottom_sheet_viewmodel.dart'
    as _i16;
import 'package:frappe_app/views/list_view/bottom_sheets/edit_filter_bottom_sheet_viewmodel.dart'
    as _i8;
import 'package:frappe_app/views/list_view/bottom_sheets/filters_bottom_sheet_viewmodel.dart'
    as _i9;
import 'package:frappe_app/views/list_view/bottom_sheets/sort_by_fields_bottom_sheet_viewmodel.dart'
    as _i14;
import 'package:frappe_app/views/list_view/list_view_viewmodel.dart' as _i10;
import 'package:frappe_app/views/new_doc/new_doc_viewmodel.dart' as _i11;
import 'package:frappe_app/views/send_email/send_email_viewmodel.dart' as _i12;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.AddAttachmentsBottomSheetViewModel>(
        () => _i3.AddAttachmentsBottomSheetViewModel());
    gh.lazySingleton<_i4.AddReviewBottomSheetViewModel>(
        () => _i4.AddReviewBottomSheetViewModel());
    gh.lazySingleton<_i5.AssigneesBottomSheetViewModel>(
        () => _i5.AssigneesBottomSheetViewModel());
    gh.lazySingleton<_i6.AwesomBarViewModel>(() => _i6.AwesomBarViewModel());
    gh.lazySingleton<_i7.ConnectivityService>(() => _i7.ConnectivityService());
    gh.lazySingleton<_i8.EditFilterBottomSheetViewModel>(
        () => _i8.EditFilterBottomSheetViewModel());
    gh.lazySingleton<_i9.FiltersBottomSheetViewModel>(
        () => _i9.FiltersBottomSheetViewModel());
    gh.lazySingleton<_i10.ListViewViewModel>(() => _i10.ListViewViewModel());
    gh.lazySingleton<_i11.NewDocViewModel>(() => _i11.NewDocViewModel());
    gh.lazySingleton<_i12.SendEmailViewModel>(() => _i12.SendEmailViewModel());
    gh.lazySingleton<_i13.ShareBottomSheetViewModel>(
        () => _i13.ShareBottomSheetViewModel());
    gh.lazySingleton<_i14.SortByFieldsBottomSheetViewModel>(
        () => _i14.SortByFieldsBottomSheetViewModel());
    gh.lazySingleton<_i15.StorageService>(() => _i15.StorageService());
    gh.lazySingleton<_i16.TagsBottomSheetViewModel>(
        () => _i16.TagsBottomSheetViewModel());
    gh.lazySingleton<_i17.ViewAttachmenetsBottomSheetViewModel>(
        () => _i17.ViewAttachmenetsBottomSheetViewModel());
    gh.lazySingleton<_i18.ViewReviewsBottomSheetViewModel>(
        () => _i18.ViewReviewsBottomSheetViewModel());
    return this;
  }
}
