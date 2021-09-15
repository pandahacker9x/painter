import 'package:flutter/painting.dart';
import 'dart:convert';

/// Custom [Path] with serialization and deserialization abilities
/// Note: only support [Path.moveTo] and [Path.lineTo] actions
class SerializablePath extends Path {
  final List<PathAction> actions = List<PathAction>.empty(growable: true);

  SerializablePath();

  @override
  void moveTo(double x, double y) {
    actions.add(PathAction.moveTo(x, y));
    super.moveTo(x, y);
  }

  @override
  void lineTo(double x, double y) {
    actions.add(PathAction.lineTo(x, y));
    super.lineTo(x, y);
  }

  void loadActions(List<PathAction> actions) {
    actions.forEach((action) {
      switch (action.action) {
        case Action.LINE_TO:
          lineTo(action.x, action.y);
          break;
        case Action.MOVE_TO:
          moveTo(action.x, action.y);
          break;
      }
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'actions': actions.map((e) => e.toMap()).toList(),
    };
  }

  factory SerializablePath.fromMap(Map<String, dynamic> map) {
    final actions = (map['actions'] as Iterable)
        .map(
          (e) => PathAction.fromMap(e),
        )
        .toList();
    return SerializablePath()..loadActions(actions);
  }

  String toJson() => json.encode(toMap());

  factory SerializablePath.fromJson(String source) =>
      SerializablePath.fromMap(json.decode(source));

}

class PathAction {
  final double x, y;
  final Action action;

  const PathAction({
    required this.x,
    required this.y,
    required this.action,
  });
  PathAction.moveTo(this.x, this.y) : action = Action.MOVE_TO;
  PathAction.lineTo(this.x, this.y) : action = Action.LINE_TO;

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'action': action.toString(),
    };
  }

  factory PathAction.fromMap(Map<String, dynamic> map) {
    return PathAction(
        x: map['x'],
        y: map['y'],
        action: Action.values
            .where((element) => element.toString() == map['action'])
            .first);
  }

  String toJson() => json.encode(toMap());

  factory PathAction.fromJson(String source) =>
      PathAction.fromMap(json.decode(source));
}

enum Action { MOVE_TO, LINE_TO }
