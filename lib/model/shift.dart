import 'package:shifty/model/assignable.dart';
import 'package:shifty/model/shift_display.dart';
import 'package:shifty/model/zone.dart';

class Shift implements Comparable<Shift>, Assignable, ShiftDisplay {
  static List<Shift> searchResults = [];

  final int id;
  final DateTime _start;
  final DateTime _end;
  final Zone _zone;
  final ShiftType _type;

  @override
  DateTime get start => _start;
  @override
  DateTime get end => _end;
  @override
  Zone get zone => _zone;
  @override
  ShiftType get type => _type;

  Shift._create(
      {required this.id,
      required DateTime start,
      required DateTime end,
      required Zone zone,
      required ShiftType type})
      : _start = start,
        _end = end,
        _zone = zone,
        _type = type;

  factory Shift.fromJson(Map<String, dynamic> json,
          {required ShiftType type}) =>
      Shift._create(
          id: json['id'] ?? json['shift_id'],
          start: DateTime.parse(json['start'] + 'Z'),
          end: DateTime.parse(json['end'] + 'Z'),
          zone: json['starting_point_id'] != null
              ? Zone.fromId(json['starting_point_id'])
              : Zone.fromName(json['starting_point_name']),
          type: type);

  @override
  int compareTo(Shift other) {
    final isAssigned = type == ShiftType.assigned;
    final isOtherAssigned = other.type == ShiftType.assigned;

    if ((isAssigned && isOtherAssigned) || !(isAssigned || isOtherAssigned)) {
      return start.compareTo(other.start);
    }
    return isAssigned ? -1 : 1;
  }

  @override
  int getAssignableId() => id;

  bool identicalDisplayData(Shift other) =>
      start == other.start &&
      end == other.end &&
      zone == other.zone &&
      type == other.type;
}

enum ShiftType { assigned, unassigned, swap }
