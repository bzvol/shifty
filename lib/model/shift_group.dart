import 'dart:math';

import 'assignable.dart';
import 'shift.dart';
import 'shift_display.dart';
import 'zone.dart';

class ShiftGroup implements Assignable, ShiftDisplay {
  final List<Shift> _shifts;

  @override
  DateTime get start => _shifts.first.start;

  @override
  DateTime get end => _shifts.first.end;

  @override
  Zone get zone => _shifts.first.zone;

  @override
  ShiftType get type => _shifts.first.type;

  ShiftGroup(List<Shift> shifts)
      : assert(shifts.isNotEmpty),
        assert(!shifts.any((shift) => shift.type == ShiftType.assigned)),
        assert(_allIdentical(shifts)),
        _shifts = shifts..sort(_groupComparator);

  static bool _allIdentical(List<Shift> shifts) {
    if (shifts.isEmpty) return true;
    final first = shifts.first;
    return shifts.every((shift) => shift.identicalDisplayData(first));
  }

  @override
  int getAssignableId() => _shifts.first.id;

  static int _groupComparator(Shift a, Shift b) => a.type != b.type
      ? a.type == ShiftType.swap
          ? -1
          : 1
      : Random().nextBool()
          ? -1
          : 1;
}
