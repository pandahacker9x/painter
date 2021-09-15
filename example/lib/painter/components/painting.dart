import 'dart:convert';

import 'painting_path.dart';

class Painting {
  List<PaintingPath> paths;

  Painting() : paths = <PaintingPath>[];

  Map<String, dynamic> toMap() {
    return {
      'paths': paths
          .map<Map<String, dynamic>>(
            (e) => e.toMap(),
          )
          .toList(),
    };
  }

  factory Painting.fromMap(Map<String, dynamic> map) {
    final paths = (map['paths'] as Iterable).map(
      (e) => PaintingPath.fromMap(e),
    );
    return Painting()..paths.addAll(paths);
  }

  String toJson() => json.encode(toMap());

  factory Painting.fromJson(String source) =>
      Painting.fromMap(json.decode(source));
}
