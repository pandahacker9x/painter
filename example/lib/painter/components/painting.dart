import 'dart:convert';
import 'dart:ui';

import 'painting_path.dart';
import 'serilizable_paint.dart';

class Painting {
  List<PaintingPath> paths;
  SerializablePaint backgroundPaint;

  Painting()
      : paths = <PaintingPath>[],
        backgroundPaint = new SerializablePaint()
          ..blendMode = BlendMode.dstOver;

  Map<String, dynamic> toMap() {
    return {
      'paths': paths
          .map<Map<String, dynamic>>(
            (e) => e.toMap(),
          )
          .toList(),
      'backgroundPaint': backgroundPaint.toMap(),
    };
  }

  factory Painting.fromMap(Map<String, dynamic> map) {
    final paths = (map['paths'] as Iterable).map(
      (e) => PaintingPath.fromMap(e),
    );
    return Painting()
      ..paths.addAll(paths)
      ..backgroundPaint = SerializablePaint.fromMap(map["backgroundPaint"]);
  }

  String toJson() => json.encode(toMap());

  factory Painting.fromJson(String source) =>
      Painting.fromMap(json.decode(source));
}
