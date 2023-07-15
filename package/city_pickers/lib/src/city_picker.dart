import 'dart:async';
import 'dart:core';
import 'package:city_pickers/src/base/base.dart';
import 'package:city_pickers/src/cities_selector/cities_selector.dart';
import 'package:city_pickers/src/cities_selector/utils.dart';
import 'package:city_pickers/src/full_page/full_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:city_pickers/src/utils/index.dart';

import '../meta/province.dart' as meta;
import '../modal/result.dart';
import './util.dart';
import 'mod/picker_popup_route.dart';
import 'show_types.dart';

/// ios city pickers
/// provide config height, initLocation and so on
///
/// Sample:flutter format
/// ```
/// await CityPicker.showPicker(
///   location: String,
///   height: double
/// );
///
/// ```

class CityPickers {
  /// static original city data for this plugin
  static Map<String, dynamic> metaCities = meta.citiesData;

  /// static original province data for this plugin
  static Map<String, String> metaProvinces = meta.provincesData;

  static utils(
      {Map<String, String>? provinceData, Map<String, dynamic>? citiesData}) {
    print("CityPickers.metaProvinces::: ${CityPickers.metaCities}");
    return CityPickerUtil(
      provincesData: provinceData ?? CityPickers.metaProvinces,
      citiesData: citiesData ?? CityPickers.metaCities,
    );
  }

  /// use
  /// @param context BuildContext for navigator
  /// @param locationCode initial select, one of province area or city id
  ///                 if given id is provinceId, the city and area id will be this province's first city and first area in metadata
  /// @param height Container's height
  ///
  /// @param Theme used it's primaryColor
  ///
  /// @param barrierDismissible whether user can dismiss the modal by touch background
  ///
  /// @param cancelWidget customer widget for building cancel button
  ///
  /// @param confirmWidget customer widget for building confirm button
  ///
  /// @param itemBuilder customer widget for building item
  ///
  /// @parma borderRadius Container topleft and topRight radius default 0.
  /// @return Result see [Result]
  ///
  static Future<Result?> showCityPicker(
      {required BuildContext context,
      showType = ShowType.pca,
      double height = 400.0,
      String locationCode = '110000',
      ThemeData? theme,
      Map<String, dynamic>? citiesData,
      Map<String, String>? provincesData,
      // CityPickerRoute params
      bool barrierDismissible = true,
      double barrierOpacity = 0.5,
      ItemWidgetBuilder? itemBuilder,
      double? itemExtent,
      Widget? cancelWidget,
      Widget? confirmWidget,
      double borderRadius = 0,
      bool isSort = false}) {
    return Navigator.of(context, rootNavigator: true).push(
      new CityPickerRoute(
        theme: theme ?? Theme.of(context),
        canBarrierDismiss: barrierDismissible,
        barrierOpacity: barrierOpacity,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        child: BaseView(
          isSort: isSort,
          showType: showType,
          height: height,
          itemExtent: itemExtent,
          itemBuilder: itemBuilder,
          cancelWidget: cancelWidget,
          confirmWidget: confirmWidget,
          citiesData: citiesData ?? meta.citiesData,
          provincesData: provincesData ?? meta.provincesData,
          locationCode: locationCode,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  /// @theme Theme used it's primaryColor
  static Future<Result?> showFullPageCityPicker({
    required BuildContext context,
    ThemeData? theme,
    ShowType showType = ShowType.pca,
    String locationCode = '110000',
    Map<String, dynamic>? citiesData,
    Map<String, String>? provincesData,
  }) {
    return Navigator.push(
      context,
      new PageRouteBuilder(
        settings: RouteSettings(name: 'fullPageCityPicker'),
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, _, __) => new Theme(
          data: theme ?? Theme.of(context),
          child: FullPage(
            showType: showType,
            locationCode: locationCode,
            citiesData: citiesData ?? meta.citiesData,
            provincesData: provincesData ?? meta.provincesData,
          ),
        ),
        transitionsBuilder:
            (_, Animation<double> animation, __, Widget child) =>
                new SlideTransition(
          position: new Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end: Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        ),
      ),
    );
  }

  static Future<Result?> showCitiesSelector({
    required BuildContext context,
    ThemeData? theme,
    String? locationCode,
    String title = '城市选择器',
    Map<String, dynamic> citiesData = meta.citiesData,
    Map<String, String> provincesData = meta.provincesData,
    AppBarBuilder? appBarBuilder,
    List<HotCity>? hotCities,
    BaseStyle? sideBarStyle,
    BaseStyle? cityItemStyle,
    BaseStyle? topStickStyle,
    Color? scaffoldBackgroundColor,
    bool useSearchAppBar = false,
    EdgeInsetsGeometry tagBarTextPadding =
        const EdgeInsets.symmetric(horizontal: 4.0),
  }) {
    BaseStyle _sideBarStyle = BaseStyle(
      fontSize: 14,
      color: defaultTagFontColor,
      activeColor: defaultTagActiveBgColor,
      backgroundColor: defaultTagBgColor,
      backgroundActiveColor: defaultTagActiveBgColor,
    );
    if (sideBarStyle != null) {
      _sideBarStyle = _sideBarStyle.merge(sideBarStyle);
    }

    BaseStyle _cityItemStyle = BaseStyle(
      fontSize: 12,
      color: Colors.black,
      activeColor: Colors.red,
    );
    if (cityItemStyle != null) {
      _cityItemStyle = _cityItemStyle.merge(cityItemStyle);
    }

    BaseStyle _topStickStyle = BaseStyle(
      fontSize: 16,
      height: 40,
      color: defaultTopIndexFontColor,
      backgroundColor: defaultTopIndexBgColor,
    );
    if (topStickStyle != null) {
      _topStickStyle = _topStickStyle.merge(topStickStyle);
    }
    return Navigator.push(
      context,
      new PageRouteBuilder(
        settings: RouteSettings(name: 'CitiesPicker'),
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, _, __) => new Theme(
          data: theme ?? Theme.of(context),
          child: CitiesSelectorPage(
            title: title,
            appBarBuilder: appBarBuilder,
            scaffoldBackgroundColor:
                scaffoldBackgroundColor ?? defaultScaffoldBackgroundColor,
            useSearchAppBar: useSearchAppBar,
            provincesData: provincesData,
            citiesData: citiesData,
            buildCitiesSelector: (context, cities) => CitiesSelector(
              cities: cities,
              hotCities: hotCities,
              locationCode: locationCode,
              tagBarActiveColor: _sideBarStyle.backgroundActiveColor!,
              tagBarFontActiveColor: _sideBarStyle.activeColor!,
              tagBarBgColor: _sideBarStyle.backgroundColor!,
              tagBarFontColor: _sideBarStyle.color,
              tagBarFontSize: _sideBarStyle.fontSize,
              tagBarTextPadding: tagBarTextPadding,
              topIndexFontSize: _topStickStyle.fontSize,
              topIndexHeight: _topStickStyle.height!,
              topIndexFontColor: _topStickStyle.color,
              topIndexBgColor: _topStickStyle.backgroundColor!,
              itemFontColor: _cityItemStyle.color,
              itemFontSize: _cityItemStyle.fontSize,
              itemSelectFontColor: _cityItemStyle.activeColor,
              onSelected: (value) => Navigator.pop(context, value),
            ),
          ),
        ),
        transitionsBuilder:
            (_, Animation<double> animation, __, Widget child) =>
                new SlideTransition(
          position: new Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end: Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        ),
      ),
    );
  }
}
