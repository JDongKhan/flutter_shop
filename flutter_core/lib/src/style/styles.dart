import 'package:flutter/material.dart';

///@author JD
export 'color_style.dart';
export 'push_animation.dart';
export 'text_field_style.dart';

InputDecoration buildInputDecoration(
    {String? labelText, Widget? prefixIcon, TextStyle? labelStyle}) {
  return InputDecoration(
    border: const OutlineInputBorder(),
    labelText: labelText,
    isCollapsed: true,
    contentPadding:
        const EdgeInsets.only(right: 10, left: 10, top: 15, bottom: 15), //这里是关键
    prefixIcon: prefixIcon,
  );
}

///Default matrix
List<double> get _matrix => [
      1, 0, 0, 0, 0, //R
      0, 1, 0, 0, 0, //G
      0, 0, 1, 0, 0, //B
      0, 0, 0, 1, 0, //A
    ];

///Generate a matrix of specified saturation
///[sat] A value of 0 maps the color to gray-scale. 1 is identity.
List<double> getSaturation(double sat) {
  final m = _matrix;
  final double invSat = 1 - sat;
  final double R = 0.213 * invSat;
  final double G = 0.715 * invSat;
  final double B = 0.072 * invSat;
  m[0] = R + sat;
  m[1] = G;
  m[2] = B;
  m[5] = R;
  m[6] = G + sat;
  m[7] = B;
  m[10] = R;
  m[11] = G;
  m[12] = B + sat;
  return m;
}
