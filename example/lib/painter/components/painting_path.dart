
import 'dart:convert';

import 'serializable_path.dart';
import 'serilizable_paint.dart';

/// PaintingPath that describes a drawing path in a painting
/// A drawing path contains a path and a paint
class PaintingPath {
  final SerializablePath path;
  final SerializablePaint paint;

  PaintingPath(this.path, this.paint);

  Map<String, dynamic> toMap() {
    return {
      'path': path.toMap(),
      'paint': paint.toMap(),
    };
  }

  factory PaintingPath.fromMap(Map<String, dynamic> map) {
    return PaintingPath(
      SerializablePath.fromMap(map['path']),
      SerializablePaint.fromMap(map['paint']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaintingPath.fromJson(String source) =>
      PaintingPath.fromMap(json.decode(source));
}

