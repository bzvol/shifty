class Shift {
  static List<Shift> searchResults = [];

  final int id;
  final DateTime start;
  final DateTime end;
  final int zoneId;
  final ShiftType type;

  Shift._create(
      {required this.id,
      required this.start,
      required this.end,
      required this.zoneId,
      required this.type});

  factory Shift.fromJson(Map<String, dynamic> json,
          {required ShiftType type}) =>
      Shift._create(
          id: json['id'],
          start: DateTime.parse(json['start'] + 'Z'),
          end: DateTime.parse(json['end'] + 'Z'),
          zoneId: json['starting_point_id'],
          type: type);
}

enum ShiftType { assigned, unassigned, swap }
