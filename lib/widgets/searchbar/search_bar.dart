import 'package:flutter/material.dart';

///
/// @author jd
///

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    this.onTap,
    this.onSubmitted,
    this.text,
    this.hintText,
    this.height = 35,
    this.color = Colors.white,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.only(top: 10),
    this.radius = 20,
  }) : super(key: key);

  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;
  final Widget? suffixIcon;
  final String? text;
  final String? hintText;
  final Color color;
  final double height;
  final double radius;
  final EdgeInsetsGeometry contentPadding;

  @override
  State createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode(canRequestFocus: false);
  bool _editIconShow = false;
  @override
  void initState() {
    _controller.text = widget.text ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.all(
          Radius.circular(widget.radius),
        ),
      ),
      child: _buildSearchWidget(),
    );
  }

  Widget _buildSearchWidget() {
    return TextField(
//              enabled: false,
      controller: _controller,
      focusNode: _focusNode,
      style: const TextStyle(
        fontSize: 14,
      ),
      maxLines: 1,
      onChanged: (text) {
        if (text.isNotEmpty) {
          if (_editIconShow == false) {
            setState(() {
              _editIconShow = true;
            });
          }
        } else {
          setState(() {
            _editIconShow = false;
          });
        }
      },
      decoration: InputDecoration(
        contentPadding: widget.contentPadding,
        hintText: widget.hintText ?? '查找',
        hintStyle: const TextStyle(fontSize: 14),
        filled: true,
        isDense: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isCollapsed: true, //相当于高度包裹的意思，必须为true，不然有默认的最小高度
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        suffixIcon: widget.suffixIcon ??
            (_editIconShow
                ? GestureDetector(
                    child: Icon(
                      Icons.cancel,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                    onTap: () {
                      _controller.clear();
                      setState(() {
                        _editIconShow = false;
                      });
                    },
                  )
                : null),
      ),
      onSubmitted: (String value) {
        widget.onSubmitted?.call(value);
      },
      onTap: () {
        if (widget.onTap != null) {
          _focusNode.unfocus();
          widget.onTap?.call();
        }
      },
    );
  }
}
