import 'dart:convert';

import 'package:http/http.dart' as http;
import 'endpoints.dart';

class RoosterAPI {
  static Future<String> auth(String email, String password) async {
    var response = await http.post(
      Uri.parse(APIEndpoints.auth),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user': {
          'email': email,
          'password': password
        }
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Failed to authenticate');
    }
  }
}