import 'package:flutter/painting.dart';

class Utils {
  static Color stringToColor(String colorString) {
    String valueString = colorString.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }
}
