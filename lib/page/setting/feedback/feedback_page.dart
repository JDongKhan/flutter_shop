import 'package:flutter/material.dart';

import '../../../style/styles.dart';

/// @author jd

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackPage> {
  final _list = ['直播', '会员', '账号', '其他', '建议优化'];
  String? _selectedType = '建议优化';

  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: myAppBar(
        title: Text('反馈'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: DropdownButton<String>(
                value: _selectedType,
                isExpanded: true,
                elevation: 0,
                underline: Container(),
                style: const TextStyle(color: Colors.black),
                dropdownColor: Colors.grey[100],
                items: _list
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
              ),
            ),
            Container(
              height: 200,
              color: Colors.white,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextField(
                controller: _messageController,
                // minLines: 1,
                // maxLines: 10,
                maxLength: 100,
                maxLines: null,
                expands: true,
                style: const TextStyle(color: Colors.black),
                // strutStyle: StrutStyle(height: 100),
                decoration: const InputDecoration(
                  hintText: '请输入您的意见或建议',
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: TextField(
                controller: _emailController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'QQ/电话/邮箱，方便我们联系',
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 40,
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  '提交',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
