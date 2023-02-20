import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shifty/controller/debugger.dart';
import 'package:shifty/model/shift.dart';

import 'endpoints.dart';

class API {
  static const _jsonHeaders = {'Content-Type': 'application/json; charset=UTF-8'};

  static Map<String, String> _authHeaders(String token) =>
      {'Authorization': token, 'Content-Type': 'application/json; charset=UTF-8'};

  static Future<String> auth(String email, String password) async {
    final response = await http.post(
      Uri.parse(APIEndpoints.auth),
      headers: _jsonHeaders,
      body: jsonEncode({
        'user': {'email': email, 'password': password}
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  static Future<Map<String, dynamic>> getEmployeeData(
      String token, String employeeId) async {
    final response = await http.get(
      Uri.parse(APIEndpoints.employeeData(employeeId, withCity: true)),
      headers: _authHeaders(token),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get employee data');
    }
  }

  static Future<List<Shift>> getShifts(
    String token,
    String employeeId,
    int cityId, {
    required DateTime start,
    required DateTime end,
  }) async {
    final List<Shift> shifts = [];

    const shiftTypes = ShiftType.values;
    final responses = await Future.wait(shiftTypes.map((shiftType) => http.get(
          Uri.parse(APIEndpoints.shifts(shiftType, employeeId,
              start: start, end: end, cityId: cityId)),
          headers: _authHeaders(token),
        )));

    for (int i = 0; i < responses.length; i++) {
      final response = responses[i];

      if (response.statusCode != 200) {
        Debugger.log(
            'Failed to get ${shiftTypes[i]} shifts\n${response.statusCode} '
            '${response.reasonPhrase}\n${response.body}');
        throw Exception('Failed to get ${shiftTypes[i]} shifts');
      }

      final shiftType = shiftTypes[i];
      final shiftList = jsonDecode(response.body);

      if (shiftList.length == 0) {
        continue;
      }

      if (shiftType == ShiftType.unassigned) {
        shiftList.forEach(_fixTimeZone);
      }

      shifts.addAll((shiftList as List)
          .map((s) => Shift.fromJson(s, type: shiftType))
          .toList());
    }

    shifts.sort();
    return shifts;
  }

  static void _fixTimeZone(s) {
    final tzOffset = DateTime.now().timeZoneOffset;
    s['start'] = DateTime.parse(s['start']).add(tzOffset).toIso8601String();
    s['end'] = DateTime.parse(s['end']).add(tzOffset).toIso8601String();
  }
}
