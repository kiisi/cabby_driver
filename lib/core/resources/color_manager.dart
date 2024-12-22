import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex("#2e6edf");
  static Color pink = HexColor.fromHex("#E0678C");
  static Color green = HexColor.fromHex("#4DC591");
  static Color primaryOpacity70 = HexColor.fromHex("#2196F328");

  static Color white = HexColor.fromHex("#ffffff");
  static Color white700 = HexColor.fromHex("#a9a9a9");
  static Color whiteGrey = HexColor.fromHex("#f4f4f6");
  static Color whiteSmoke = HexColor.fromHex("#cccccc");
  static Color error = HexColor.fromHex("#e61f34");
  static Color black = HexColor.fromHex("#1c1f24");
  static Color blackDark = HexColor.fromHex("#323943");
  static Color blue = HexColor.fromHex("#2196F3");
  static Color blueOpacity70 = HexColor.fromHex("#b3064db7");
  static Color blueDark = HexColor.fromHex("#96b5d3");
  static Color blueLight = HexColor.fromHex("#282e33");
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll("#", "");
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString";
    }

    return Color(int.parse(hexColorString, radix: 16));
  }
}
