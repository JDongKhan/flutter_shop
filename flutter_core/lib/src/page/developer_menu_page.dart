import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../logger/ui/log_console_page.dart';
import 'float_menu_controller.dart';
import 'setting_proxy/setting_proxy_page.dart';

/// @author jd
///

class DeveloperMenuPage extends StatefulWidget {
  const DeveloperMenuPage({Key? key}) : super(key: key);

  @override
  State createState() => _DeveloperMenuPageState();
}

class _DeveloperMenuPageState extends State<DeveloperMenuPage> {
  final List<DeveloperMenu> _menuList = [
    DeveloperMenu(
      title: '代理设置',
      subtitle: '设置代理服务器的ip和端口',
      icon: Icons.phonelink_rounded,
      click: (context) => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SettingProxyPage(),
          ),
        )
      },
    ),
  ];
  final DeveloperMenu _logConfig = DeveloperMenu(
    title: '日志',
    subtitle: '查看flutter相关日志',
    icon: Icons.insert_drive_file,
    click: (context) => {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const LogConsolePage(),
        ),
      )
    },
  );

  late List<DeveloperMenu> _allList;

  @override
  void initState() {
    _allList = [];
    _allList.addAll(_menuList);
    if (!kIsWeb) {
      _allList.add(_logConfig);
    }
    _allList.addAll(floatMenuController.menuList);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: const Text('Debug 菜单'),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(_getIconData(Theme.of(context).platform)),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          DeveloperMenu e = _allList[index];
          return Card(
            child: ListTile(
              minLeadingWidth: 20,
              dense: true,
              leading: Icon(
                e.icon,
              ),
              title: Text(
                e.title,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              subtitle: Text(e.subtitle),
              // contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
              onTap: () {
                _onClick(e.click, context);
              },
            ),
          );
        },
        itemCount: _allList.length,
      ),
    );
  }

  static IconData _getIconData(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return Icons.arrow_back_ios;
    }
  }

  void _onClick(Function? click, BuildContext context) {
    if (click != null) {
      click.call(context);
    }
  }
}

class DeveloperMenu {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function click;
  DeveloperMenu(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.click});
}
