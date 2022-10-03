import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shifty/controller/debugger.dart';
import 'package:shifty/model/shift.dart';
import 'endpoints.dart';

class API {
  static Future<String> auth(String email, String password) async {
    var response = await http.post(
      Uri.parse(APIEndpoints.auth),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user': {'email': email, 'password': password}
      }),
    );

    Debugger.addResponse(response);

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  static Future<Map<String, dynamic>> getEmployeeData(
      String token, String employeeId) async {
    var response = await http.get(
      Uri.parse(APIEndpoints.employeeData(employeeId, withCity: true)),
      headers: {
        'Authorization': token,
        'Accept': 'application/json; charset=UTF-8'
      },
    );

    Debugger.addResponse(response);

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
    List<Shift> shifts = [];

    // Get assigned shifts
    var assignedShiftsResponse = await http.get(
      Uri.parse(APIEndpoints.shifts(employeeId,
          start: start, end: end, cityId: cityId)),
      headers: {
        'Authorization': token,
        'Accept': 'application/json; charset=UTF-8'
      },
    );
    Debugger.addResponse(assignedShiftsResponse);
    if (assignedShiftsResponse.statusCode == 200) {
      var assignedShifts = jsonDecode(assignedShiftsResponse.body);
      shifts.addAll(assignedShifts
          .map((s) => Shift.fromJson(s, type: ShiftType.assigned)));
    } else {
      throw Exception('Failed to get assigned shifts');
    }

    // Get unassigned shifts
    var uaShiftsResponse = await http.get(
      Uri.parse(APIEndpoints.unassignedShifts(employeeId,
          start: start, end: end, cityId: cityId)),
      headers: {
        'Authorization': token,
        'Accept': 'application/json; charset=UTF-8'
      },
    );
    Debugger.addResponse(uaShiftsResponse);
    if (uaShiftsResponse.statusCode == 200) {
      var uaShifts = jsonDecode(uaShiftsResponse.body);
      // Ua. shifts are set to UTC timezone by default.
      // We need to set them to the local timezone.
      uaShifts.forEach((s) {
        final tzOffset = DateTime.now().timeZoneOffset;
        s['start'] = DateTime.parse(s['start']).add(tzOffset).toIso8601String();
        s['end'] = DateTime.parse(s['end']).add(tzOffset).toIso8601String();
      });
      shifts.addAll(
          uaShifts.map((s) => Shift.fromJson(s, type: ShiftType.unassigned)));
    } else {
      throw Exception('Failed to get unassigned shifts');
    }

    // Get swap shifts
    var swapsResponse = await http.get(
      Uri.parse(APIEndpoints.swaps(employeeId,
          start: start, end: end, cityId: cityId)),
      headers: {
        'Authorization': token,
        'Accept': 'application/json; charset=UTF-8'
      },
    );
    Debugger.addResponse(swapsResponse);
    if (swapsResponse.statusCode == 200) {
      var swaps = jsonDecode(swapsResponse.body);
      shifts.addAll(swaps.map((s) => Shift.fromJson(s, type: ShiftType.swap)));
    } else {
      throw Exception('Failed to get swaps');
    }

    return shifts;
  }
}
