import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../pages/home.dart';

class Debugger {
  static List<Response> responses = [];
  static BuildContext? context;

  static void log(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  static void addResponse(Response response) {
    final stateObject = context?.findAncestorStateOfType<HomePageState>();
    stateObject?.refreshDebugger(responses, response);
  }
}

class HttpResponseCard extends StatelessWidget {
  const HttpResponseCard(Response response, {Key? key})
      : _response = response,
        super(key: key);

  final Response _response;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${_response.statusCode} ${_response.reasonPhrase}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _colorFromStatusCode(_response.statusCode),
                  fontSize: 18)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.all(8),
              child: Text(_tryJsonParse(_response.body),
                  style: const TextStyle(fontFamily: 'Ubuntu Mono')),
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFromStatusCode(int statusCode) {
    switch (statusCode.toString()[0]) {
      case '2':
        return Colors.green;
      case '3':
        return Colors.blue;
      case '4':
        return Colors.amber;
      case '5':
        return Colors.red;
      default:
        return Colors.blueGrey.shade700;
    }
  }

  String _tryJsonParse(String body) {
    try {
      return const JsonEncoder.withIndent('  ').convert(jsonDecode(body));
    } catch (e) {
      return body;
    }
  }
}
