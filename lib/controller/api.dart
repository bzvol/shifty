import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shifty/controller/debugger.dart';
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
      Uri.parse(APIEndpoints.employeeData(employeeId)),
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
}
