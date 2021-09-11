import 'dart:convert';

import 'package:example/painter/utils.dart';
import 'package:flutter/painting.dart';

/// Custom [Paint] with serilization and deserialization abilities
/// Note: only support [Paint.strokeWith], [Paint.blendMode] and [Paint.color] actions
/// style = [PaintingStyle.fill] by default
class SerializablePaint extends Paint {
  SerializablePaint();

  Map<String, dynamic> toMap() {
    return {
      'strokeWidth': strokeWidth,
      'color': color.toString(),
      'blendMode': blendMode.toString(),
    };
  }

  String toJson() => json.encode(toMap());

  factory SerializablePaint.fromMap(Map<String, dynamic> map) {
    return SerializablePaint()
      ..strokeWidth = map['strokeWidth']
      ..color = Utils.stringToColor(map['color'])
      ..blendMode = BlendMode.values
          .firstWhere((element) => element.toString() == map['blendMode']);
  }
}
