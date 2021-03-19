import 'package:flutter/material.dart';

class Tools {
  static Color hetToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static List<Color> multiColors = [
    Colors.red,
    Colors.amber,
    Colors.blue,
    Colors.green
  ];


  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }

}
