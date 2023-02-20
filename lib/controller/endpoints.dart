import 'package:shifty/model/shift.dart';

class APIEndpoints {
  static const String base = 'https://hu.usehurrier.com/api';
  static const String v2 = '$base/rooster/v2';
  static const String v3 = '$base/rooster/v3';
  static const String auth = '$base/user/auth'; // response: 201

  static String shifts(ShiftType shiftType, String employeeId,
      {required DateTime start, required DateTime end, required int cityId}) {
    final startIso = '${start.toIso8601String()}Z';
    final endIso = '${end.toIso8601String()}Z';

    String typeRoute;
    switch (shiftType) {
      case ShiftType.assigned:
        typeRoute = 'shifts';
        break;
      case ShiftType.unassigned:
        typeRoute = 'available_unassigned_shifts';
        break;
      case ShiftType.swap:
        typeRoute = 'available_swaps';
        break;
    }

    return '$v3/employees/$employeeId/$typeRoute?start_at=$startIso'
        '&end_at=$endIso&city_id=$cityId&with_time_zone=Europe%2FBudapest';
  }

  static String assignShift(String shiftId) =>
      '$v2/unassigned_shifts/$shiftId/assign';

  static String swapShift(String shiftId) =>
      '$v2/shifts/$shiftId/swap'; // response: 202

  static String employeeData(
    String employeeId, {
    bool withFields = false,
    withContracts = false,
    withCity = false,
    withStartingPoints = false,
    withSuspensionDates = false,
  }) =>
      '$v2/employees/$employeeId?with_fields=$withFields'
      '&with_contracts=$withContracts&with_city=$withCity'
      '&with_starting_points=$withStartingPoints'
      '&with_suspension_dates=$withSuspensionDates';
}
