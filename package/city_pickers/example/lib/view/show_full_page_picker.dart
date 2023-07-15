//
// Created with Android Studio.
// User: 三帆
// Date: 12/02/2019
// Time: 16:53
// email: sanfan.hx@alibaba-inc.com
// tartget:  xxx
//

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:city_pickers/city_pickers.dart';
import '../src/attr_item_container.dart';
import '../src/location_selector.dart';
import '../src/picker.dart';
import '../meta/province.dart';

var emptyResult = Result();

class ShowFullPageCityPicker extends StatefulWidget {
  const ShowFullPageCityPicker({Key? key}) : super(key: key);

  @override
  State<ShowFullPageCityPicker> createState() => _ShowFullPageCityPickerState();
}

class _ShowFullPageCityPickerState extends State<ShowFullPageCityPicker> {
  PickerItem showTypeAttr = PickerItem(name: '省+市+县', value: ShowType.pca);
  Result resultAttr = Result();
  Result result = Result();
  double barrierOpacityAttr = 0.5;
  bool barrierDismissibleAttr = false;
  bool customerMeta = false;
  PickerItem? themeAttr;

  Widget _buildShowTypes() {
    return Picker(
      target: showTypeAttr != null && showTypeAttr.name != null
          ? Text(showTypeAttr.name)
          : const Text("显示几级联动"),
      onConfirm: (PickerItem item) {
        setState(() {
          showTypeAttr = item;
        });
      },
      items: [
        PickerItem(name: '省', value: ShowType.p),
        PickerItem(name: '市', value: ShowType.c),
        PickerItem(name: '县', value: ShowType.a),
        PickerItem(name: '省+市', value: ShowType.pc),
        PickerItem(name: '省+市+县', value: ShowType.pca),
        PickerItem(name: '市+县', value: ShowType.ca),
      ],
    );
  }

  Widget _buildDefaultLocation() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: LocationSelector(
            target: Text("${resultAttr.provinceName ?? '省'}",
                maxLines: 1, overflow: TextOverflow.ellipsis),
            showType: ShowType.p,
            initResult: resultAttr,
            onConfirm: (Result result) {
              if (result.provinceId != null) {
                setState(() {
                  resultAttr = result;
                });
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: LocationSelector(
            target: Text("${resultAttr.cityName ?? '市'}",
                maxLines: 1, overflow: TextOverflow.ellipsis),
            showType: ShowType.c,
            initResult: resultAttr,
            onConfirm: (Result result) {
              if (result.cityId != null) {
                setState(() {
                  resultAttr = result;
                });
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: LocationSelector(
            target: Text("${resultAttr.areaName ?? '区'}",
                maxLines: 1, overflow: TextOverflow.ellipsis),
            showType: ShowType.a,
            initResult: resultAttr,
            onConfirm: (Result result) {
              if (result.areaId != null) {
                setState(() {
                  resultAttr = result;
                });
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildTheme() {
    return Picker(
        target: Text(themeAttr?.name ?? "主题切换"),
        onConfirm: (PickerItem item) {
          setState(() {
            themeAttr = item;
          });
        },
        items: [
          PickerItem(name: 'ThemeData.light()', value: ThemeData.light()),
          PickerItem(name: 'ThemeData.fallback()', value: ThemeData.fallback()),
          PickerItem(name: 'ThemeData.dark()', value: ThemeData.dark()),
          PickerItem(name: 'ThemeData.of(context)', value: null),
        ]);
  }

  Widget _buildCustomerMeta() {
    return Container(
        alignment: Alignment.centerRight,
        child: CupertinoSwitch(
          value: customerMeta,
          onChanged: (bool val) {
            setState(() {
              customerMeta = !customerMeta;
            });
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("省市县三级全屏联动"),
      ),
      body: Column(
        children: <Widget>[
          AttrItemContainer(title: '级联方式', editor: _buildShowTypes()),
          AttrItemContainer(title: '默认地址', editor: _buildDefaultLocation()),
          AttrItemContainer(title: '主题选择', editor: _buildTheme()),
          AttrItemContainer(title: '是否采用自定义数据', editor: _buildCustomerMeta()),
          AttrItemContainer(
              title: '选择结果', editor: Text("${result.toString()}")),
          ElevatedButton(
            onPressed: () async {
              print("locationCode $resultAttr");
              Result? tempResult = await CityPickers.showFullPageCityPicker(
                  context: context,
                  theme: themeAttr?.value,
                  locationCode: resultAttr.areaId ??
                      resultAttr.cityId ??
                      resultAttr.provinceId ??
                      "110000",
                  showType: showTypeAttr.value,
                  citiesData: customerMeta ? citiesData : null,
                  provincesData: customerMeta ? provincesData : null);
              if (tempResult == null) {
                return;
              }
              setState(() {
                result = tempResult;
              });
            },
            child: const Text("展示city picker"),
          )
        ],
      ),
    );
  }
}
