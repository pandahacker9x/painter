import 'dart:convert';

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

// extension ActionExtension on Action {
//   String value() {
//     switch (this) {
//       case Action.MOVETO:
//         return 'mt';
//       case Action.LINETO:
//         return 'lt';
//     }
//   }
// }
