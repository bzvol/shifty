class APIEndpoints {
  static const String base = 'https://hu.usehurrier.com/api';
  static const String v2 = '$base/rooster/v2';
  static const String v3 = '$base/rooster/v3';
  static const String auth = '$base/user/auth';

  static String shifts(String employeeId) => '$v3/employees/$employeeId/shifts';

  static String unassignedShifts(String employeeId) =>
      '$v3/employees/$employeeId/available_unassigned_shifts';

  static String swaps(String employeeId) =>
      '$v3/employees/$employeeId/available_swaps';

  static String assignShift(String shiftId) => '$v2/unassigned_shifts/$shiftId/assign';

  static String swapShift(String shiftId) => '$v2/shifts/$shiftId/swap';
}
