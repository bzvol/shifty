import 'assignable.dart';
import 'shift.dart';
import 'zone.dart';

abstract class ShiftDisplay<T extends Assignable> {
  DateTime get start;
  DateTime get end;
  Zone get zone;
  ShiftType get type;
}