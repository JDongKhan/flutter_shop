import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// 动态iconfont
class DynamicIconFont {
  static const String _family = 'dynamicIconFontFamily';
  static var fontLoader = FontLoader(_family);

  static const IconData iconTest01 = IconData(0xe8c2, fontFamily: _family);
  static const IconData iconTest02 = IconData(0xe8c3, fontFamily: _family);
  static const IconData iconTest03 = IconData(0xe8c4, fontFamily: _family);

  /// 获取 iconfont
  static Future<ByteData> _fetchFont(String iconFontURL) async {
    try {
      final response = await http.get(Uri.parse(iconFontURL));
      if (response.statusCode == 200) {
        return ByteData.view(response.bodyBytes.buffer);
      } else {
        throw Exception('Failed to load font');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Object?>? init(List<String> iconFontUrls) async {
    try {
      for (String url in iconFontUrls) {
        fontLoader.addFont(_fetchFont(url));
      }
      await fontLoader.load();
    } catch (e) {
      debugPrint('addFont catch error: $e');
    }
    return true;
  }
}
