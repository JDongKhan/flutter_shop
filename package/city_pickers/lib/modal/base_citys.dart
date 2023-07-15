import 'package:city_pickers/modal/point.dart';
import 'package:lpinyin/lpinyin.dart';

import '../meta/province.dart';
import '../src/util.dart';

/// tree point

class CityTree {
  /// build cityTrees's meta, it can be changed bu developers
  Map<String, dynamic> metaInfo;

  /// provData user self-defining data
  Map<String, String>? provincesInfo;
  Cache _cache = new Cache();

  /// the tree's modal
  /// data = Point(
  ///   letter,
  ///   name
  ///   code,
  ///   letter,
  ///   child: [
  ///     Point
  ///   ]
  /// )
  /// data = [
  ///   {
  ///     letter: 'Z',
  ///     name: '浙江',
  ///     code: 330000
  ///     child: [
  ///       letter: 'h',
  ///       name: '杭州',
  ///       child
  ///     ]
  ///   }
  /// ]
  late Point tree;

  /// @param metaInfo city and areas meta describe
  CityTree({this.metaInfo = citiesData, this.provincesInfo});

  Map<String, String> get _provincesData => this.provincesInfo ?? provincesData;

  /// build tree by int provinceId,
  /// @param provinceId this is province id
  /// @return tree
  Point initTree(String provinceId) {
    String _cacheKey = provinceId;
//    这里为了避免 https://github.com/hanxu317317/city_pickers/issues/68
//    if (_cache.has(_cacheKey)) {
//      return tree = _cache.get(_cacheKey);
//    }

    String name = this._provincesData[provinceId]!;
    String letter = PinyinHelper.getFirstWordPinyin(name).substring(0, 1);
    var root =
        new Point(code: provinceId, letter: letter, children: [], name: name);
    tree = _buildTree(root, metaInfo[provinceId], metaInfo);
    _cache.set(_cacheKey, tree);
    return tree;
  }

  /// this is a private function, used the return to get a correct tree contain cities and areas
  /// @param code one of province city or area id;
  /// @return provinceId return id which province's child contain code
  String? _getProvinceByCode(String code) {
    String _code = code.toString();
    List<String> keys = metaInfo.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      Map<String, dynamic> child = metaInfo[key];
      if (child.containsKey(_code)) {
        // 当前元素的父key在省份内
        if (this._provincesData.containsKey(key)) {
          return key;
        }
        return _getProvinceByCode(key);
      }
    }
    return null;
  }

  /// build tree by any code provinceId or cityCode or areaCode
  /// @param code build a tree
  /// @return Point a province with its cities and areas tree
  Point initTreeByCode(String code) {
    String _code = code.toString();
    if (this._provincesData[_code] != null) {
      return initTree(code);
    }
    String? provinceId = _getProvinceByCode(code);
    if (provinceId != null) {
      return initTree(provinceId);
    }
    return Point.nullPoint();
//    return Point.nullPoint;
  }

  /// private function
  /// recursion to build tree
  Point _buildTree(Point target, Map<String, dynamic>? citys, Map meta) {
    if (citys == null || citys.isEmpty) {
      return target;
    } else {
      List<String> keys = citys.keys.toList();

      for (int i = 0; i < keys.length; i++) {
        String key = keys[i];
        Map value = citys[key];
        Point _point = new Point(
          code: key,
          letter: value['alpha'],
          children: [],
          name: value['name'],
          isClassificationNode: value['isClassificationNode'] ?? false,
        );

        // for avoid the data  error that such as
        //  "469027": {
        //        "469027": {
        //            "name": "乐东黎族自治县",
        //            "alpha": "l"
        //        }
        //    }
        if (citys.keys.length == 1) {
          if (target.code.toString() == citys.keys.first) {
            continue;
          }
        }

        _point = _buildTree(_point, meta[key], meta);
        target.addChild(_point);
      }
    }
    return target;
  }
}

/// Province Class
class Provinces {
  Map<String, String> metaInfo;

  // 是否将省份排序, 进行排序
  bool sort;

  Provinces({this.metaInfo = provincesData, this.sort = true});

  // 获取省份数据
  get provinces {
    List<Point> provList = [];
    List<String> keys = metaInfo.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      String name = metaInfo[keys[i]]!;
      provList.add(Point(
          code: keys[i],
          children: [],
          letter: PinyinHelper.getFirstWordPinyin(name).substring(0, 1),
          name: name));
    }
    if (this.sort == true) {
      provList.sort((Point a, Point b) {
        if (a.letter == null && b.letter == null) {
          return 0;
        }

        if (a.letter == null) {
          return 1;
        }

        return a.letter!.compareTo(b.letter!);
      });
    }

    return provList;
  }
}
//main() {
//  var tree = new CityTree();
//  tree.initTree(460000);
//  print("treePo>>> ${tree.tree.toString()}");
//}
//

//main() {
//  var p = new Provinces(
////    metaInfo: provincesData
//  );
//  print("p.provinces ${p.provinces}");
//}
